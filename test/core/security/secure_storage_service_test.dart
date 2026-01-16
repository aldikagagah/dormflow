/// Unit tests for SecureStorageService
library;

import 'package:dormflow_mobile/core/security/secure_storage_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SecureStorageService keys', () {
    test('should have correct key constants', () {
      expect(SecureStorageService.keyAuthToken, 'auth_token');
      expect(SecureStorageService.keyRefreshToken, 'refresh_token');
      expect(SecureStorageService.keyUserId, 'user_id');
      expect(SecureStorageService.keyUserEmail, 'user_email');
      expect(SecureStorageService.keySessionExpiry, 'session_expiry');
      expect(SecureStorageService.keyBiometricEnabled, 'biometric_enabled');
      expect(SecureStorageService.keyLastLogin, 'last_login');
      expect(SecureStorageService.keyDeviceId, 'device_id');
    });

    test('should have unique key values', () {
      final keys = [
        SecureStorageService.keyAuthToken,
        SecureStorageService.keyRefreshToken,
        SecureStorageService.keyUserId,
        SecureStorageService.keyUserEmail,
        SecureStorageService.keySessionExpiry,
        SecureStorageService.keyBiometricEnabled,
        SecureStorageService.keyLastLogin,
        SecureStorageService.keyDeviceId,
      ];
      final uniqueKeys = keys.toSet();
      expect(uniqueKeys.length, keys.length);
    });
  });

  group('SecureStorageService singleton', () {
    test('should return the same instance', () {
      final instance1 = SecureStorageService.instance;
      final instance2 = SecureStorageService.instance;
      expect(identical(instance1, instance2), true);
    });

    test('factory constructor should return singleton', () {
      final factory = SecureStorageService();
      final instance = SecureStorageService.instance;
      expect(identical(factory, instance), true);
    });
  });

  group('SecureStorageService auth token methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('getAuthToken should return String?', () async {
      final token = await storage.getAuthToken();
      expect(token, isA<String?>());
    });

    test('deleteAuthToken should not throw', () async {
      await expectLater(storage.deleteAuthToken(), completes);
    });
  });

  group('SecureStorageService refresh token methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('getRefreshToken should return String?', () async {
      final token = await storage.getRefreshToken();
      expect(token, isA<String?>());
    });
  });

  group('SecureStorageService user session methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('getUserId should return String?', () async {
      final userId = await storage.getUserId();
      expect(userId, isA<String?>());
    });

    test('getUserEmail should return String?', () async {
      final email = await storage.getUserEmail();
      expect(email, isA<String?>());
    });

    test('isSessionValid should return bool', () async {
      final isValid = await storage.isSessionValid();
      expect(isValid, isA<bool>());
    });

    test('getLastLogin should return DateTime?', () async {
      final lastLogin = await storage.getLastLogin();
      expect(lastLogin, isA<DateTime?>());
    });
  });

  group('SecureStorageService biometric methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('isBiometricEnabled should return bool', () async {
      final enabled = await storage.isBiometricEnabled();
      expect(enabled, isA<bool>());
    });

    test('setBiometricEnabled should not throw', () async {
      await expectLater(storage.setBiometricEnabled(true), completes);
      await expectLater(storage.setBiometricEnabled(false), completes);
    });
  });

  group('SecureStorageService generic methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('getSecureData should return String?', () async {
      final data = await storage.getSecureData('test_key');
      expect(data, isA<String?>());
    });

    test('getSecureJson should return Map?', () async {
      final json = await storage.getSecureJson('test_json_key');
      expect(json, isA<Map<String, dynamic>?>());
    });

    test('deleteSecureData should not throw', () async {
      await expectLater(storage.deleteSecureData('test_key'), completes);
    });
  });

  group('SecureStorageService utility methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('hasStoredCredentials should return bool', () async {
      final hasCredentials = await storage.hasStoredCredentials();
      expect(hasCredentials, isA<bool>());
    });

    test('getAllKeys should return Map', () async {
      final keys = await storage.getAllKeys();
      expect(keys, isA<Map<String, String>>());
    });
  });

  group('SecureStorageService clear methods', () {
    late SecureStorageService storage;

    setUp(() {
      storage = SecureStorageService.instance;
    });

    test('clearAuthData should not throw', () async {
      await expectLater(storage.clearAuthData(), completes);
    });

    test('clearAll should not throw', () async {
      await expectLater(storage.clearAll(), completes);
    });
  });
}
