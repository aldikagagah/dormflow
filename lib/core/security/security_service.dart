import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Service for handling secure operations like hashing and encryption utilities.
class SecurityService {

  /// Factory constructor for DI
  factory SecurityService() => instance;

  SecurityService._();
  static SecurityService? _instance;

  /// Get singleton instance
  static SecurityService get instance {
    _instance ??= SecurityService._();
    return _instance!;
  }

  // ==================== HASHING ====================

  /// Hash a string using SHA-256
  String hashSha256(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Hash a string using SHA-512
  String hashSha512(String input) {
    final bytes = utf8.encode(input);
    final digest = sha512.convert(bytes);
    return digest.toString();
  }

  /// Hash a string using MD5 (NOT for security, only for checksums)
  String hashMd5(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Generate HMAC-SHA256 for data integrity
  String hmacSha256(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final hmacSha = Hmac(sha256, keyBytes);
    final digest = hmacSha.convert(dataBytes);
    return digest.toString();
  }

  // ==================== DEVICE FINGERPRINTING ====================

  /// Generate a device fingerprint hash from device info
  String generateDeviceFingerprint({
    required String deviceModel,
    required String osVersion,
    required String appVersion,
    String? deviceId,
  }) {
    final fingerprintData = {
      'model': deviceModel,
      'os': osVersion,
      'app': appVersion,
      if (deviceId != null) 'id': deviceId,
      'timestamp': DateTime.now().toIso8601String(),
    };

    final jsonStr = jsonEncode(fingerprintData);
    return hashSha256(jsonStr);
  }

  // ==================== TOKEN VALIDATION ====================

  /// Validate JWT token format (basic check)
  bool isValidJwtFormat(String token) {
    // JWT has 3 parts separated by dots
    final parts = token.split('.');
    if (parts.length != 3) return false;

    // Each part should be base64 encoded
    try {
      for (final part in parts.take(2)) {
        // Add padding if needed
        final buffer = StringBuffer(part.replaceAll('-', '+').replaceAll('_', '/'));
        while (buffer.length % 4 != 0) {
          buffer.write('=');
        }
        base64Decode(buffer.toString());
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Parse JWT payload (without verification - use server-side for verification)
  Map<String, dynamic>? parseJwtPayload(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final buffer = StringBuffer(parts[1].replaceAll('-', '+').replaceAll('_', '/'));
      while (buffer.length % 4 != 0) {
        buffer.write('=');
      }

      final decoded = utf8.decode(base64Decode(buffer.toString()));
      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if JWT is expired (from exp claim)
  bool isJwtExpired(String token) {
    final payload = parseJwtPayload(token);
    if (payload == null) return true;

    final exp = payload['exp'];
    if (exp == null) return false; // No expiry

    final expInt = (exp is int) ? exp : int.tryParse(exp.toString()) ?? 0;
    final expiryTime = DateTime.fromMillisecondsSinceEpoch(expInt * 1000);
    return DateTime.now().isAfter(expiryTime);
  }

  // ==================== INPUT SANITIZATION ====================

  /// Sanitize input for XSS prevention
  String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .replaceAll('\\', '&#x5C;');
  }

  /// Remove potential script tags
  String removeScriptTags(String input) {
    // Remove script tags and their content
    final scriptPattern = RegExp(
      r'<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>',
      caseSensitive: false,
    );
    return input.replaceAll(scriptPattern, '');
  }

  /// Validate input contains only allowed characters
  bool containsOnlyAllowed(String input, {String allowed = r'[a-zA-Z0-9\s\-_.,@!?]'}) {
    final pattern = RegExp('^$allowed*\$');
    return pattern.hasMatch(input);
  }

  // ==================== PASSWORD UTILITIES ====================

  /// Check password strength
  PasswordStrength checkPasswordStrength(String password) {
    if (password.length < 6) return PasswordStrength.veryWeak;

    int score = 0;

    // Length bonus
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character variety
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    return switch (score) {
      <= 2 => PasswordStrength.weak,
      3 || 4 => PasswordStrength.medium,
      5 => PasswordStrength.strong,
      _ => PasswordStrength.veryStrong,
    };
  }

  /// Generate password strength message
  String getPasswordStrengthMessage(PasswordStrength strength) {
    return switch (strength) {
      PasswordStrength.veryWeak => 'Password terlalu lemah',
      PasswordStrength.weak => 'Password lemah',
      PasswordStrength.medium => 'Password cukup',
      PasswordStrength.strong => 'Password kuat',
      PasswordStrength.veryStrong => 'Password sangat kuat',
    };
  }

  // ==================== SESSION ID ====================

  /// Generate a random session ID
  String generateSessionId() {
    final now = DateTime.now();
    final random = now.microsecondsSinceEpoch.toString();
    return hashSha256('$random${now.toIso8601String()}').substring(0, 32);
  }
}

/// Password strength levels
enum PasswordStrength {
  veryWeak,
  weak,
  medium,
  strong,
  veryStrong,
}

/// Extension for password strength
extension PasswordStrengthExtension on PasswordStrength {
  /// Get strength percentage
  double get percentage => switch (this) {
    PasswordStrength.veryWeak => 0.2,
    PasswordStrength.weak => 0.4,
    PasswordStrength.medium => 0.6,
    PasswordStrength.strong => 0.8,
    PasswordStrength.veryStrong => 1.0,
  };

  /// Get strength color value (as hex)
  int get colorValue => switch (this) {
    PasswordStrength.veryWeak => 0xFFEF4444, // Red
    PasswordStrength.weak => 0xFFF97316, // Orange
    PasswordStrength.medium => 0xFFFBBF24, // Yellow
    PasswordStrength.strong => 0xFF22C55E, // Green
    PasswordStrength.veryStrong => 0xFF10B981, // Emerald
  };
}
