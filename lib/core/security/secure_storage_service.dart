import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage service for storing sensitive data with encryption.
/// Uses flutter_secure_storage which provides:
/// - Keychain on iOS
/// - EncryptedSharedPreferences on Android
class SecureStorageService {

  /// Factory constructor for DI
  factory SecureStorageService() => instance;

  SecureStorageService._() {
    _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
  }
  static SecureStorageService? _instance;
  late final FlutterSecureStorage _storage;

  /// Keys for secure storage
  static const String keyAuthToken = 'auth_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keySessionExpiry = 'session_expiry';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyLastLogin = 'last_login';
  static const String keyDeviceId = 'device_id';

  /// Get singleton instance
  static SecureStorageService get instance {
    _instance ??= SecureStorageService._();
    return _instance!;
  }

  // ==================== AUTH TOKEN ====================

  /// Store authentication token securely
  Future<void> saveAuthToken(String token) async {
    try {
      await _storage.write(key: keyAuthToken, value: token);
    } catch (e) {
      debugPrint('Error saving auth token: $e');
      rethrow;
    }
  }

  /// Retrieve authentication token
  Future<String?> getAuthToken() async {
    try {
      return await _storage.read(key: keyAuthToken);
    } catch (e) {
      debugPrint('Error reading auth token: $e');
      return null;
    }
  }

  /// Delete authentication token
  Future<void> deleteAuthToken() async {
    try {
      await _storage.delete(key: keyAuthToken);
    } catch (e) {
      debugPrint('Error deleting auth token: $e');
    }
  }

  // ==================== REFRESH TOKEN ====================

  /// Store refresh token securely
  Future<void> saveRefreshToken(String token) async {
    try {
      await _storage.write(key: keyRefreshToken, value: token);
    } catch (e) {
      debugPrint('Error saving refresh token: $e');
      rethrow;
    }
  }

  /// Retrieve refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: keyRefreshToken);
    } catch (e) {
      debugPrint('Error reading refresh token: $e');
      return null;
    }
  }

  // ==================== USER SESSION ====================

  /// Store user session data
  Future<void> saveUserSession({
    required String userId,
    required String email,
    DateTime? expiry,
  }) async {
    try {
      await _storage.write(key: keyUserId, value: userId);
      await _storage.write(key: keyUserEmail, value: email);
      await _storage.write(
        key: keyLastLogin,
        value: DateTime.now().toIso8601String(),
      );
      if (expiry != null) {
        await _storage.write(
          key: keySessionExpiry,
          value: expiry.toIso8601String(),
        );
      }
    } catch (e) {
      debugPrint('Error saving user session: $e');
      rethrow;
    }
  }

  /// Get stored user ID
  Future<String?> getUserId() async {
    try {
      return await _storage.read(key: keyUserId);
    } catch (e) {
      debugPrint('Error reading user ID: $e');
      return null;
    }
  }

  /// Get stored user email
  Future<String?> getUserEmail() async {
    try {
      return await _storage.read(key: keyUserEmail);
    } catch (e) {
      debugPrint('Error reading user email: $e');
      return null;
    }
  }

  /// Check if session is valid (not expired)
  Future<bool> isSessionValid() async {
    try {
      final expiryStr = await _storage.read(key: keySessionExpiry);
      if (expiryStr == null) return true; // No expiry set = valid

      final expiry = DateTime.parse(expiryStr);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      debugPrint('Error checking session validity: $e');
      return false;
    }
  }

  /// Get last login time
  Future<DateTime?> getLastLogin() async {
    try {
      final lastLoginStr = await _storage.read(key: keyLastLogin);
      if (lastLoginStr == null) return null;
      return DateTime.parse(lastLoginStr);
    } catch (e) {
      debugPrint('Error reading last login: $e');
      return null;
    }
  }

  // ==================== BIOMETRIC ====================

  /// Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    try {
      await _storage.write(
        key: keyBiometricEnabled,
        value: enabled.toString(),
      );
    } catch (e) {
      debugPrint('Error setting biometric: $e');
    }
  }

  /// Check if biometric is enabled
  Future<bool> isBiometricEnabled() async {
    try {
      final value = await _storage.read(key: keyBiometricEnabled);
      return value == 'true';
    } catch (e) {
      debugPrint('Error reading biometric setting: $e');
      return false;
    }
  }

  // ==================== GENERIC SECURE DATA ====================

  /// Store any sensitive data securely
  Future<void> saveSecureData(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      debugPrint('Error saving secure data: $e');
      rethrow;
    }
  }

  /// Store JSON object securely
  Future<void> saveSecureJson(String key, Map<String, dynamic> data) async {
    try {
      final jsonString = jsonEncode(data);
      await _storage.write(key: key, value: jsonString);
    } catch (e) {
      debugPrint('Error saving secure JSON: $e');
      rethrow;
    }
  }

  /// Retrieve secure data
  Future<String?> getSecureData(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      debugPrint('Error reading secure data: $e');
      return null;
    }
  }

  /// Retrieve secure JSON
  Future<Map<String, dynamic>?> getSecureJson(String key) async {
    try {
      final jsonString = await _storage.read(key: key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('Error reading secure JSON: $e');
      return null;
    }
  }

  /// Delete specific secure data
  Future<void> deleteSecureData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      debugPrint('Error deleting secure data: $e');
    }
  }

  // ==================== CLEAR ALL ====================

  /// Clear all secure storage (use on logout)
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing secure storage: $e');
    }
  }

  /// Clear only authentication data (keep preferences)
  Future<void> clearAuthData() async {
    try {
      await _storage.delete(key: keyAuthToken);
      await _storage.delete(key: keyRefreshToken);
      await _storage.delete(key: keyUserId);
      await _storage.delete(key: keyUserEmail);
      await _storage.delete(key: keySessionExpiry);
      await _storage.delete(key: keyLastLogin);
    } catch (e) {
      debugPrint('Error clearing auth data: $e');
    }
  }

  // ==================== UTILITY ====================

  /// Check if any secure data exists
  Future<bool> hasStoredCredentials() async {
    try {
      final token = await _storage.read(key: keyAuthToken);
      final userId = await _storage.read(key: keyUserId);
      return token != null && userId != null;
    } catch (e) {
      debugPrint('Error checking credentials: $e');
      return false;
    }
  }

  /// Get all stored keys (for debugging only)
  Future<Map<String, String>> getAllKeys() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      debugPrint('Error reading all keys: $e');
      return {};
    }
  }
}
