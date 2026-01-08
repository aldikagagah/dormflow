import 'dart:async';

import 'package:flutter/foundation.dart';

import 'advanced_rate_limiter.dart';
import 'secure_storage_service.dart';
import 'security_service.dart';

/// Session state
enum SessionState {
  /// Not authenticated
  unauthenticated,
  /// Authenticated and active
  active,
  /// Session expired
  expired,
  /// Session locked (due to inactivity)
  locked,
  /// Session terminated (security issue)
  terminated,
}

/// Session manager for handling user sessions securely.
/// Features:
/// - Session expiry tracking
/// - Inactivity timeout
/// - Device binding
/// - Concurrent session control
class SessionManager {

  /// Factory constructor for DI
  factory SessionManager() => instance;

  SessionManager._();
  static SessionManager? _instance;

  final SecureStorageService _storage = SecureStorageService.instance;
  final SecurityService _security = SecurityService.instance;
  final AdvancedRateLimiter _rateLimiter = AdvancedRateLimiter.instance;

  /// Session configuration
  static const Duration sessionTimeout = Duration(hours: 24);
  static const Duration inactivityTimeout = Duration(minutes: 30);
  static const Duration tokenRefreshThreshold = Duration(hours: 1);
  static const int maxConcurrentSessions = 3;

  /// Stream controller for session state changes
  final StreamController<SessionState> _stateController =
      StreamController<SessionState>.broadcast();

  /// Last activity timestamp
  DateTime? _lastActivity;

  /// Current session ID
  String? _currentSessionId;

  /// Inactivity timer
  Timer? _inactivityTimer;

  /// Get singleton instance
  static SessionManager get instance {
    _instance ??= SessionManager._();
    return _instance!;
  }

  /// Stream of session state changes
  Stream<SessionState> get stateStream => _stateController.stream;

  /// Record user activity (call on any user interaction)
  void recordActivity() {
    _lastActivity = DateTime.now();
    _resetInactivityTimer();
  }

  /// Reset inactivity timer
  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(inactivityTimeout, _onInactivityTimeout);
  }

  /// Handle inactivity timeout
  void _onInactivityTimeout() {
    debugPrint('[SessionManager] Inactivity timeout reached');
    _stateController.add(SessionState.locked);
  }

  // ==================== SESSION LIFECYCLE ====================

  /// Start a new session
  Future<bool> startSession({
    required String userId,
    required String email,
    String? authToken,
    String? refreshToken,
    String? deviceId,
  }) async {
    try {
      // Check rate limit for login
      final rateLimitResult = _rateLimiter.checkAndRecord(
        RateLimitAction.login,
        userId: userId,
      );

      if (!rateLimitResult.isAllowed) {
        debugPrint('[SessionManager] Rate limited: ${rateLimitResult.message}');
        return false;
      }

      // Generate session ID
      _currentSessionId = _security.generateSessionId();

      // Calculate expiry
      final expiry = DateTime.now().add(sessionTimeout);

      // Store session data
      await _storage.saveUserSession(
        userId: userId,
        email: email,
        expiry: expiry,
      );

      if (authToken != null) {
        await _storage.saveAuthToken(authToken);
      }

      if (refreshToken != null) {
        await _storage.saveRefreshToken(refreshToken);
      }

      if (deviceId != null) {
        await _storage.saveSecureData(
          SecureStorageService.keyDeviceId,
          deviceId,
        );
      }

      // Start activity tracking
      recordActivity();

      // Record successful login
      _rateLimiter.recordSuccess(RateLimitAction.login, userId: userId);

      // Emit active state
      _stateController.add(SessionState.active);

      debugPrint('[SessionManager] Session started for $email');
      return true;
    } catch (e) {
      debugPrint('[SessionManager] Error starting session: $e');
      _rateLimiter.recordFailedAttempt(RateLimitAction.login, userId: userId);
      return false;
    }
  }

  /// End current session (logout)
  Future<void> endSession() async {
    try {
      _inactivityTimer?.cancel();
      _currentSessionId = null;
      _lastActivity = null;

      await _storage.clearAuthData();

      _stateController.add(SessionState.unauthenticated);

      debugPrint('[SessionManager] Session ended');
    } catch (e) {
      debugPrint('[SessionManager] Error ending session: $e');
    }
  }

  /// Terminate session due to security reason
  Future<void> terminateSession({String? reason}) async {
    debugPrint('[SessionManager] Session terminated: ${reason ?? 'Unknown'}');

    await _storage.clearAll();
    _inactivityTimer?.cancel();
    _currentSessionId = null;
    _lastActivity = null;

    _stateController.add(SessionState.terminated);
  }

  // ==================== SESSION VALIDATION ====================

  /// Check if session is valid
  Future<SessionState> validateSession() async {
    try {
      // Check if we have stored credentials
      final hasCredentials = await _storage.hasStoredCredentials();
      if (!hasCredentials) {
        return SessionState.unauthenticated;
      }

      // Check session expiry
      final isValid = await _storage.isSessionValid();
      if (!isValid) {
        debugPrint('[SessionManager] Session expired');
        _stateController.add(SessionState.expired);
        return SessionState.expired;
      }

      // Check inactivity
      if (_lastActivity != null) {
        final inactivityDuration = DateTime.now().difference(_lastActivity!);
        if (inactivityDuration > inactivityTimeout) {
          debugPrint('[SessionManager] Session locked due to inactivity');
          _stateController.add(SessionState.locked);
          return SessionState.locked;
        }
      }

      // Check if token needs refresh
      await _checkTokenRefresh();

      return SessionState.active;
    } catch (e) {
      debugPrint('[SessionManager] Error validating session: $e');
      return SessionState.unauthenticated;
    }
  }

  /// Check if token needs refresh
  Future<void> _checkTokenRefresh() async {
    final token = await _storage.getAuthToken();
    if (token == null) return;

    // If JWT, check expiry
    if (_security.isValidJwtFormat(token)) {
      final payload = _security.parseJwtPayload(token);
      if (payload != null) {
        final exp = payload['exp'];
        if (exp != null) {
          final expInt = (exp is int) ? exp : int.tryParse(exp.toString()) ?? 0;
          final expiryTime = DateTime.fromMillisecondsSinceEpoch(expInt * 1000);
          final timeUntilExpiry = expiryTime.difference(DateTime.now());

          if (timeUntilExpiry < tokenRefreshThreshold) {
            debugPrint('[SessionManager] Token nearing expiry, refresh needed');
            // Here you would call your token refresh logic
            // await _refreshToken();
          }
        }
      }
    }
  }

  // ==================== GETTERS ====================

  /// Get current session ID
  String? get sessionId => _currentSessionId;

  /// Get last activity time
  DateTime? get lastActivity => _lastActivity;

  /// Check if session is active
  Future<bool> get isActive async {
    final state = await validateSession();
    return state == SessionState.active;
  }

  /// Get current user ID
  Future<String?> get userId => _storage.getUserId();

  /// Get current user email
  Future<String?> get userEmail => _storage.getUserEmail();

  // ==================== CLEANUP ====================

  /// Dispose resources
  void dispose() {
    _inactivityTimer?.cancel();
    _stateController.close();
  }
}

/// Mixin for widgets that need session awareness
mixin SessionAwareMixin {
  /// Get session manager
  SessionManager get sessionManager => SessionManager.instance;

  /// Record activity when user interacts
  void onUserActivity() {
    sessionManager.recordActivity();
  }
}
