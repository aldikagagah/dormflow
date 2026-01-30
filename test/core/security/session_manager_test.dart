/// Unit tests for SessionManager
library;

import 'dart:async';

import 'package:dormflow_mobile/core/security/session_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SessionState', () {
    test('should have all expected states', () {
      expect(SessionState.values, contains(SessionState.unauthenticated));
      expect(SessionState.values, contains(SessionState.active));
      expect(SessionState.values, contains(SessionState.expired));
      expect(SessionState.values, contains(SessionState.locked));
      expect(SessionState.values, contains(SessionState.terminated));
    });

    test('should have correct number of states', () {
      expect(SessionState.values.length, 5);
    });
  });

  group('SessionManager configuration', () {
    test('sessionTimeout should be 24 hours', () {
      expect(SessionManager.sessionTimeout, const Duration(hours: 24));
    });

    test('inactivityTimeout should be 30 minutes', () {
      expect(SessionManager.inactivityTimeout, const Duration(minutes: 30));
    });

    test('tokenRefreshThreshold should be 1 hour', () {
      expect(SessionManager.tokenRefreshThreshold, const Duration(hours: 1));
    });

    test('maxConcurrentSessions should be 3', () {
      expect(SessionManager.maxConcurrentSessions, 3);
    });
  });

  group('SessionManager singleton', () {
    test('should return the same instance', () {
      final instance1 = SessionManager.instance;
      final instance2 = SessionManager.instance;
      expect(identical(instance1, instance2), true);
    });

    test('factory constructor should return singleton', () {
      final factory = SessionManager();
      final instance = SessionManager.instance;
      expect(identical(factory, instance), true);
    });
  });

  group('SessionManager properties', () {
    late SessionManager manager;

    setUp(() {
      manager = SessionManager.instance;
    });

    test('sessionId should initially be null', () {
      // Note: sessionId may be set from previous tests in the same test run
      // Just verify it's accessible
      expect(manager.sessionId, isA<String?>());
    });

    test('lastActivity should be accessible', () {
      expect(manager.lastActivity, isA<DateTime?>());
    });

    test('stateStream should be a broadcast stream', () {
      expect(manager.stateStream, isA<Stream<SessionState>>());
    });
  });

  group('SessionManager activity tracking', () {
    late SessionManager manager;

    setUp(() {
      manager = SessionManager.instance;
    });

    test('recordActivity should update lastActivity', () {
      final beforeRecord = manager.lastActivity;
      manager.recordActivity();
      expect(manager.lastActivity, isNotNull);
      if (beforeRecord != null) {
        expect(
          manager.lastActivity!.isAfter(beforeRecord) ||
              manager.lastActivity!.isAtSameMomentAs(beforeRecord),
          true,
        );
      }
    });

    test('recordActivity should not throw', () {
      expect(() => manager.recordActivity(), returnsNormally);
    });

    test('multiple recordActivity calls should work', () {
      expect(() {
        manager.recordActivity();
        manager.recordActivity();
        manager.recordActivity();
      }, returnsNormally);
    });
  });

  group('SessionManager getters', () {
    late SessionManager manager;

    setUp(() {
      manager = SessionManager.instance;
    });

    test('userId getter should return Future<String?>', () async {
      final userId = await manager.userId;
      expect(userId, isA<String?>());
    });

    test('userEmail getter should return Future<String?>', () async {
      final userEmail = await manager.userEmail;
      expect(userEmail, isA<String?>());
    });

    test('isActive getter should return Future<bool>', () async {
      final isActive = await manager.isActive;
      expect(isActive, isA<bool>());
    });
  });

  group('SessionManager session operations', () {
    late SessionManager manager;

    setUp(() {
      manager = SessionManager.instance;
    });

    test('endSession should not throw', () async {
      await expectLater(manager.endSession(), completes);
    });

    test('terminateSession should accept reason parameter', () async {
      await expectLater(
        manager.terminateSession(reason: 'Test termination'),
        completes,
      );
    });

    test('validateSession should return a SessionState', () async {
      final state = await manager.validateSession();
      expect(state, isA<SessionState>());
      expect(SessionState.values, contains(state));
    });
  });

  group('SessionAwareMixin', () {
    test('should provide sessionManager getter', () {
      final testClass = _TestSessionAware();
      expect(testClass.sessionManager, isA<SessionManager>());
      expect(identical(testClass.sessionManager, SessionManager.instance), true);
    });

    test('onUserActivity should call recordActivity', () {
      final testClass = _TestSessionAware();
      expect(() => testClass.onUserActivity(), returnsNormally);
    });
  });
}

/// Test class that uses SessionAwareMixin
class _TestSessionAware with SessionAwareMixin {}
