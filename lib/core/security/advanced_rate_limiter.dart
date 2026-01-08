import 'dart:collection';

import 'package:flutter/foundation.dart';

/// Action types for rate limiting
enum RateLimitAction {
  /// Login attempt
  login,
  /// Registration attempt
  register,
  /// Password reset request
  passwordReset,
  /// OTP verification
  otpVerification,
  /// Attendance check-in
  attendanceCheckIn,
  /// Attendance check-out
  attendanceCheckOut,
  /// Transaction creation
  createTransaction,
  /// Schedule creation
  createSchedule,
  /// API request
  apiRequest,
  /// File upload
  fileUpload,
  /// Profile update
  profileUpdate,
}

/// Rate limit configuration for each action type
class RateLimitConfig {

  const RateLimitConfig({
    required this.maxAttempts,
    required this.window,
    required this.lockoutDuration,
  });
  /// Maximum attempts allowed within the window
  final int maxAttempts;

  /// Time window for counting attempts
  final Duration window;

  /// Lockout duration after max attempts exceeded
  final Duration lockoutDuration;

  /// Strict config for auth actions
  static const RateLimitConfig auth = RateLimitConfig(
    maxAttempts: 5,
    window: Duration(minutes: 15),
    lockoutDuration: Duration(minutes: 30),
  );

  /// Medium config for sensitive actions
  static const RateLimitConfig sensitive = RateLimitConfig(
    maxAttempts: 10,
    window: Duration(minutes: 5),
    lockoutDuration: Duration(minutes: 10),
  );

  /// Relaxed config for normal actions
  static const RateLimitConfig normal = RateLimitConfig(
    maxAttempts: 30,
    window: Duration(minutes: 1),
    lockoutDuration: Duration(minutes: 2),
  );
}

/// Rate limit status result
class RateLimitResult {

  const RateLimitResult({
    required this.isAllowed,
    required this.remainingAttempts,
    this.lockoutRemaining,
    this.windowResetIn,
    this.message,
  });

  factory RateLimitResult.allowed(int remaining) => RateLimitResult(
    isAllowed: true,
    remainingAttempts: remaining,
  );

  factory RateLimitResult.blocked({
    required Duration lockoutRemaining,
    String? message,
  }) => RateLimitResult(
    isAllowed: false,
    remainingAttempts: 0,
    lockoutRemaining: lockoutRemaining,
    message: message ?? 'Terlalu banyak percobaan. Coba lagi dalam ${_formatDuration(lockoutRemaining)}.',
  );
  /// Whether the action is allowed
  final bool isAllowed;

  /// Remaining attempts before lockout
  final int remainingAttempts;

  /// Time until lockout ends (if locked out)
  final Duration? lockoutRemaining;

  /// Time until window resets
  final Duration? windowResetIn;

  /// Error message if blocked
  final String? message;

  static String _formatDuration(Duration duration) {
    if (duration.inSeconds < 60) {
      return '${duration.inSeconds} detik';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} menit';
    } else {
      return '${duration.inHours} jam';
    }
  }
}

/// Advanced rate limiter with sliding window and lockout support
class AdvancedRateLimiter {

  /// Factory constructor for DI
  factory AdvancedRateLimiter() => instance;

  AdvancedRateLimiter._();
  static AdvancedRateLimiter? _instance;

  /// Config for each action type
  final Map<RateLimitAction, RateLimitConfig> _configs = {
    RateLimitAction.login: RateLimitConfig.auth,
    RateLimitAction.register: RateLimitConfig.auth,
    RateLimitAction.passwordReset: RateLimitConfig.auth,
    RateLimitAction.otpVerification: RateLimitConfig.auth,
    RateLimitAction.attendanceCheckIn: RateLimitConfig.sensitive,
    RateLimitAction.attendanceCheckOut: RateLimitConfig.sensitive,
    RateLimitAction.createTransaction: RateLimitConfig.normal,
    RateLimitAction.createSchedule: RateLimitConfig.normal,
    RateLimitAction.apiRequest: RateLimitConfig.normal,
    RateLimitAction.fileUpload: RateLimitConfig.sensitive,
    RateLimitAction.profileUpdate: RateLimitConfig.sensitive,
  };

  /// Attempt timestamps for each action
  final Map<String, Queue<DateTime>> _attempts = {};

  /// Lockout end timestamps
  final Map<String, DateTime> _lockouts = {};

  /// Failed attempt counter for progressive lockout
  final Map<String, int> _failedAttemptCount = {};

  /// Get singleton instance
  static AdvancedRateLimiter get instance {
    _instance ??= AdvancedRateLimiter._();
    return _instance!;
  }

  /// Generate unique key for user+action combination
  String _getKey(RateLimitAction action, [String? userId]) {
    final userPart = userId ?? 'anonymous';
    return '${action.name}:$userPart';
  }

  /// Check if action is allowed and record attempt
  RateLimitResult checkAndRecord(
    RateLimitAction action, {
    String? userId,
    bool recordOnSuccess = true,
  }) {
    final key = _getKey(action, userId);
    final config = _configs[action] ?? RateLimitConfig.normal;
    final now = DateTime.now();

    // Check for active lockout
    final lockoutEnd = _lockouts[key];
    if (lockoutEnd != null && now.isBefore(lockoutEnd)) {
      final remaining = lockoutEnd.difference(now);
      debugPrint('[RateLimiter] Blocked: $key - Lockout remaining: $remaining');
      return RateLimitResult.blocked(lockoutRemaining: remaining);
    }

    // Clear expired lockout
    if (lockoutEnd != null && now.isAfter(lockoutEnd)) {
      _lockouts.remove(key);
      _failedAttemptCount.remove(key);
    }

    // Initialize or get attempts queue
    _attempts.putIfAbsent(key, () => Queue<DateTime>());
    final attempts = _attempts[key]!;

    // Remove attempts outside the window
    final windowStart = now.subtract(config.window);
    while (attempts.isNotEmpty && attempts.first.isBefore(windowStart)) {
      attempts.removeFirst();
    }

    // Check if limit exceeded
    if (attempts.length >= config.maxAttempts) {
      // Calculate progressive lockout (increases with repeated violations)
      final violationCount = (_failedAttemptCount[key] ?? 0) + 1;
      _failedAttemptCount[key] = violationCount;

      // Progressive lockout: 1x, 2x, 4x...
      final multiplier = (1 << (violationCount - 1)).clamp(1, 8);
      final lockoutDuration = config.lockoutDuration * multiplier;

      _lockouts[key] = now.add(lockoutDuration);

      debugPrint('[RateLimiter] Rate limit exceeded: $key - Lockout: $lockoutDuration (${multiplier}x)');

      return RateLimitResult.blocked(
        lockoutRemaining: lockoutDuration,
        message: 'Terlalu banyak percobaan. Coba lagi dalam ${RateLimitResult._formatDuration(lockoutDuration)}.',
      );
    }

    // Record attempt if configured
    if (recordOnSuccess) {
      attempts.add(now);
    }

    final remaining = config.maxAttempts - attempts.length;
    debugPrint('[RateLimiter] Allowed: $key - Remaining: $remaining');

    return RateLimitResult.allowed(remaining);
  }

  /// Record a failed attempt (increases lockout on next violation)
  void recordFailedAttempt(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    _failedAttemptCount[key] = (_failedAttemptCount[key] ?? 0) + 1;
  }

  /// Record a successful action (resets failed attempt counter)
  void recordSuccess(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    _failedAttemptCount.remove(key);
  }

  /// Get remaining attempts without recording
  int getRemainingAttempts(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    final config = _configs[action] ?? RateLimitConfig.normal;
    final now = DateTime.now();

    final attempts = _attempts[key];
    if (attempts == null) return config.maxAttempts;

    // Count valid attempts within window
    final windowStart = now.subtract(config.window);
    final validAttempts = attempts.where((t) => t.isAfter(windowStart)).length;

    return config.maxAttempts - validAttempts;
  }

  /// Check if currently locked out
  bool isLockedOut(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    final lockoutEnd = _lockouts[key];
    if (lockoutEnd == null) return false;
    return DateTime.now().isBefore(lockoutEnd);
  }

  /// Get lockout remaining time
  Duration? getLockoutRemaining(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    final lockoutEnd = _lockouts[key];
    if (lockoutEnd == null) return null;

    final now = DateTime.now();
    if (now.isAfter(lockoutEnd)) return null;

    return lockoutEnd.difference(now);
  }

  /// Reset rate limit for specific action
  void reset(RateLimitAction action, {String? userId}) {
    final key = _getKey(action, userId);
    _attempts.remove(key);
    _lockouts.remove(key);
    _failedAttemptCount.remove(key);
  }

  /// Reset all rate limits (for testing)
  void resetAll() {
    _attempts.clear();
    _lockouts.clear();
    _failedAttemptCount.clear();
  }

  /// Update config for specific action
  void updateConfig(RateLimitAction action, RateLimitConfig config) {
    _configs[action] = config;
  }
}
