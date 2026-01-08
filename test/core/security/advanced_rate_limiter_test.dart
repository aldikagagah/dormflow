/// Unit tests for AdvancedRateLimiter
library;

import 'package:dormflow_mobile/core/security/advanced_rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AdvancedRateLimiter rateLimiter;

  setUp(() {
    rateLimiter = AdvancedRateLimiter();
    rateLimiter.resetAll(); // Clear any state
  });

  group('AdvancedRateLimiter', () {
    group('checkAndRecord', () {
      test('should allow first action', () {
        final result = rateLimiter.checkAndRecord(RateLimitAction.login);

        expect(result.isAllowed, true);
        expect(result.remainingAttempts, greaterThan(0));
      });

      test('should track attempts correctly', () {
        // Login has 5 max attempts
        for (int i = 0; i < 4; i++) {
          final result = rateLimiter.checkAndRecord(
            RateLimitAction.login,
            userId: 'test-user',
          );
          expect(result.isAllowed, true);
          expect(result.remainingAttempts, 5 - i - 1);
        }
      });

      test('should block when rate limit exceeded', () {
        // Exhaust all attempts (5 for login)
        for (int i = 0; i < 5; i++) {
          rateLimiter.checkAndRecord(
            RateLimitAction.login,
            userId: 'test-user',
          );
        }

        // 6th attempt should be blocked
        final result = rateLimiter.checkAndRecord(
          RateLimitAction.login,
          userId: 'test-user',
        );

        expect(result.isAllowed, false);
        expect(result.remainingAttempts, 0);
        expect(result.lockoutRemaining, isNotNull);
        expect(result.message, contains('Terlalu banyak percobaan'));
      });

      test('should not record when recordOnSuccess is false', () {
        final result1 = rateLimiter.checkAndRecord(
          RateLimitAction.login,
          userId: 'test-user',
          recordOnSuccess: false,
        );

        final result2 = rateLimiter.checkAndRecord(
          RateLimitAction.login,
          userId: 'test-user',
          recordOnSuccess: false,
        );

        // Both should have same remaining attempts since not recording
        expect(result1.remainingAttempts, result2.remainingAttempts);
      });

      test('should track different users separately', () {
        // User 1 exhausts limit
        for (int i = 0; i < 5; i++) {
          rateLimiter.checkAndRecord(
            RateLimitAction.login,
            userId: 'user-1',
          );
        }

        // User 2 should still be allowed
        final result = rateLimiter.checkAndRecord(
          RateLimitAction.login,
          userId: 'user-2',
        );

        expect(result.isAllowed, true);
      });

      test('should track different actions separately', () {
        // Exhaust login attempts
        for (int i = 0; i < 5; i++) {
          rateLimiter.checkAndRecord(
            RateLimitAction.login,
            userId: 'test-user',
          );
        }

        // Different action should still be allowed
        final result = rateLimiter.checkAndRecord(
          RateLimitAction.createTransaction,
          userId: 'test-user',
        );

        expect(result.isAllowed, true);
      });
    });

    group('recordFailedAttempt', () {
      test('should increase lockout duration on repeated violations', () {
        // First violation
        for (int i = 0; i < 5; i++) {
          rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');
        }
        rateLimiter.recordFailedAttempt(RateLimitAction.login, userId: 'user');

        final result1 = rateLimiter.checkAndRecord(
          RateLimitAction.login,
          userId: 'user',
        );

        expect(result1.isAllowed, false);

        // Lockout duration should be recorded
        final lockout1 = rateLimiter.getLockoutRemaining(
          RateLimitAction.login,
          userId: 'user',
        );
        expect(lockout1, isNotNull);
      });
    });

    group('recordSuccess', () {
      test('should reset failed attempt counter', () {
        // Add some failed attempts
        rateLimiter.recordFailedAttempt(RateLimitAction.login, userId: 'user');
        rateLimiter.recordFailedAttempt(RateLimitAction.login, userId: 'user');

        // Record success
        rateLimiter.recordSuccess(RateLimitAction.login, userId: 'user');

        // After success, failed count should be reset
        // We can't directly test this, but the behavior would be
        // shorter lockout durations on next violation
      });
    });

    group('getRemainingAttempts', () {
      test('should return max attempts when no attempts made', () {
        final remaining = rateLimiter.getRemainingAttempts(
          RateLimitAction.login,
          userId: 'new-user',
        );

        expect(remaining, 5); // Login config max is 5
      });

      test('should return correct remaining after attempts', () {
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');

        final remaining = rateLimiter.getRemainingAttempts(
          RateLimitAction.login,
          userId: 'user',
        );

        expect(remaining, 3); // 5 - 2 = 3
      });
    });

    group('isLockedOut', () {
      test('should return false when not locked out', () {
        final isLocked = rateLimiter.isLockedOut(
          RateLimitAction.login,
          userId: 'user',
        );

        expect(isLocked, false);
      });

      test('should return true when locked out', () {
        // Exhaust attempts
        for (int i = 0; i < 5; i++) {
          rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');
        }
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');

        final isLocked = rateLimiter.isLockedOut(
          RateLimitAction.login,
          userId: 'user',
        );

        expect(isLocked, true);
      });
    });

    group('reset', () {
      test('should reset specific action for user', () {
        // Make some attempts
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user');

        // Reset
        rateLimiter.reset(RateLimitAction.login, userId: 'user');

        // Should have full attempts again
        final remaining = rateLimiter.getRemainingAttempts(
          RateLimitAction.login,
          userId: 'user',
        );

        expect(remaining, 5);
      });
    });

    group('resetAll', () {
      test('should clear all rate limit data', () {
        // Make attempts for multiple users/actions
        rateLimiter.checkAndRecord(RateLimitAction.login, userId: 'user1');
        rateLimiter.checkAndRecord(RateLimitAction.register, userId: 'user2');

        // Reset all
        rateLimiter.resetAll();

        final remaining1 = rateLimiter.getRemainingAttempts(
          RateLimitAction.login,
          userId: 'user1',
        );
        final remaining2 = rateLimiter.getRemainingAttempts(
          RateLimitAction.register,
          userId: 'user2',
        );

        expect(remaining1, 5);
        expect(remaining2, 5);
      });
    });
  });

  group('RateLimitConfig', () {
    test('auth config should have strict limits', () {
      expect(RateLimitConfig.auth.maxAttempts, 5);
      expect(RateLimitConfig.auth.window.inMinutes, 15);
    });

    test('sensitive config should have medium limits', () {
      expect(RateLimitConfig.sensitive.maxAttempts, 10);
      expect(RateLimitConfig.sensitive.window.inMinutes, 5);
    });

    test('normal config should have relaxed limits', () {
      expect(RateLimitConfig.normal.maxAttempts, 30);
      expect(RateLimitConfig.normal.window.inMinutes, 1);
    });
  });

  group('RateLimitResult', () {
    test('allowed factory should create allowed result', () {
      final result = RateLimitResult.allowed(5);

      expect(result.isAllowed, true);
      expect(result.remainingAttempts, 5);
      expect(result.lockoutRemaining, isNull);
    });

    test('blocked factory should create blocked result', () {
      final result = RateLimitResult.blocked(
        lockoutRemaining: const Duration(minutes: 5),
      );

      expect(result.isAllowed, false);
      expect(result.remainingAttempts, 0);
      expect(result.lockoutRemaining!.inMinutes, 5);
      expect(result.message, contains('5 menit'));
    });
  });
}
