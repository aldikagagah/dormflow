/// Unit tests untuk RateLimiter
library;
import 'package:dormflow_mobile/core/utils/rate_limiter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RateLimiter', () {
    late RateLimiter rateLimiter;

    setUp(() {
      rateLimiter = RateLimiter();
    });

    group('canPerformAction', () {
      test('should return true for first action', () {
        final result = rateLimiter.canPerformAction('test_action');
        expect(result, isTrue);
      });

      test('should return false immediately after action', () {
        rateLimiter.recordAction('test_action');
        final result = rateLimiter.canPerformAction('test_action');
        expect(result, isFalse);
      });

      test('should return true for different action keys', () {
        rateLimiter.recordAction('action_1');
        final result = rateLimiter.canPerformAction('action_2');
        expect(result, isTrue);
      });
    });

    group('recordAction', () {
      test('should record action timestamp', () {
        rateLimiter.recordAction('test_action');
        expect(rateLimiter.canPerformAction('test_action'), isFalse);
      });

      test('should update timestamp for repeated recordings', () {
        rateLimiter.recordAction('test_action');
        final firstCheck = rateLimiter.canPerformAction('test_action');

        // Record again - should reset the timer
        rateLimiter.recordAction('test_action');
        final secondCheck = rateLimiter.canPerformAction('test_action');

        expect(firstCheck, isFalse);
        expect(secondCheck, isFalse);
      });
    });

    group('getRemainingCooldown', () {
      test('should return null for unknown action', () {
        final result = rateLimiter.getRemainingCooldown('unknown_action');
        expect(result, isNull);
      });

      test('should return remaining duration after action', () {
        rateLimiter.recordAction('test_action');
        final result = rateLimiter.getRemainingCooldown('test_action');

        expect(result, isNotNull);
        expect(result!.inSeconds, lessThanOrEqualTo(5));
        expect(result.inSeconds, greaterThan(0));
      });
    });

    group('resetAction', () {
      test('should allow action after reset', () {
        rateLimiter.recordAction('test_action');
        expect(rateLimiter.canPerformAction('test_action'), isFalse);

        rateLimiter.resetAction('test_action');
        expect(rateLimiter.canPerformAction('test_action'), isTrue);
      });
    });

    group('resetAll', () {
      test('should reset all action cooldowns', () {
        rateLimiter.recordAction('action_1');
        rateLimiter.recordAction('action_2');

        expect(rateLimiter.canPerformAction('action_1'), isFalse);
        expect(rateLimiter.canPerformAction('action_2'), isFalse);

        rateLimiter.resetAll();

        expect(rateLimiter.canPerformAction('action_1'), isTrue);
        expect(rateLimiter.canPerformAction('action_2'), isTrue);
      });
    });

    group('with short cooldown', () {
      test('should allow action after cooldown expires', () async {
        final shortLimiter = RateLimiter(cooldown: const Duration(milliseconds: 100));

        shortLimiter.recordAction('test_action');
        expect(shortLimiter.canPerformAction('test_action'), isFalse);

        // Wait for cooldown to expire
        await Future.delayed(const Duration(milliseconds: 150));

        expect(shortLimiter.canPerformAction('test_action'), isTrue);
      });
    });
  });

  group('DurationFormatting extension', () {
    test('should format seconds correctly', () {
      const duration = Duration(seconds: 30);
      expect(duration.toReadableString(), '30 detik');
    });

    test('should format minutes correctly', () {
      const duration = Duration(minutes: 5);
      expect(duration.toReadableString(), '5 menit');
    });

    test('should format hours correctly', () {
      const duration = Duration(hours: 2);
      expect(duration.toReadableString(), '2 jam');
    });
  });
}
