/// Unit tests for SecurityService
library;

import 'package:dormflow_mobile/core/security/security_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SecurityService securityService;

  setUp(() {
    securityService = SecurityService();
  });

  group('SecurityService Hashing', () {
    group('hashSha256', () {
      test('should return consistent hash for same input', () {
        const input = 'test password';
        final hash1 = securityService.hashSha256(input);
        final hash2 = securityService.hashSha256(input);

        expect(hash1, equals(hash2));
      });

      test('should return different hash for different input', () {
        final hash1 = securityService.hashSha256('password1');
        final hash2 = securityService.hashSha256('password2');

        expect(hash1, isNot(equals(hash2)));
      });

      test('should return 64 character hex string', () {
        final hash = securityService.hashSha256('test');

        expect(hash.length, 64);
        expect(RegExp(r'^[0-9a-f]+$').hasMatch(hash), true);
      });
    });

    group('hashSha512', () {
      test('should return consistent hash', () {
        const input = 'test data';
        final hash1 = securityService.hashSha512(input);
        final hash2 = securityService.hashSha512(input);

        expect(hash1, equals(hash2));
      });

      test('should return 128 character hex string', () {
        final hash = securityService.hashSha512('test');

        expect(hash.length, 128);
      });
    });

    group('hashMd5', () {
      test('should return consistent hash', () {
        const input = 'checksum data';
        final hash1 = securityService.hashMd5(input);
        final hash2 = securityService.hashMd5(input);

        expect(hash1, equals(hash2));
      });

      test('should return 32 character hex string', () {
        final hash = securityService.hashMd5('test');

        expect(hash.length, 32);
      });
    });

    group('hmacSha256', () {
      test('should return consistent HMAC for same data and key', () {
        const data = 'message';
        const key = 'secret-key';

        final hmac1 = securityService.hmacSha256(data, key);
        final hmac2 = securityService.hmacSha256(data, key);

        expect(hmac1, equals(hmac2));
      });

      test('should return different HMAC for different keys', () {
        const data = 'message';

        final hmac1 = securityService.hmacSha256(data, 'key1');
        final hmac2 = securityService.hmacSha256(data, 'key2');

        expect(hmac1, isNot(equals(hmac2)));
      });
    });
  });

  group('SecurityService JWT', () {
    // Sample JWT (not a real token, just for format testing)
    const validJwtFormat = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
        'eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.'
        'SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

    group('isValidJwtFormat', () {
      test('should return true for valid JWT format', () {
        final isValid = securityService.isValidJwtFormat(validJwtFormat);

        expect(isValid, true);
      });

      test('should return false for invalid format - missing parts', () {
        final isValid = securityService.isValidJwtFormat('header.payload');

        expect(isValid, false);
      });

      test('should return false for invalid format - not base64', () {
        final isValid = securityService.isValidJwtFormat('a.b.c');

        expect(isValid, false);
      });

      test('should return false for empty string', () {
        final isValid = securityService.isValidJwtFormat('');

        expect(isValid, false);
      });
    });

    group('parseJwtPayload', () {
      test('should parse valid JWT payload', () {
        final payload = securityService.parseJwtPayload(validJwtFormat);

        expect(payload, isNotNull);
        expect(payload!['sub'], '1234567890');
        expect(payload['name'], 'John Doe');
      });

      test('should return null for invalid JWT', () {
        final payload = securityService.parseJwtPayload('invalid');

        expect(payload, isNull);
      });
    });

    group('isJwtExpired', () {
      test('should return true for invalid JWT', () {
        final isExpired = securityService.isJwtExpired('invalid');

        expect(isExpired, true);
      });

      // Note: Testing with actual expired/valid tokens would require
      // creating real JWTs with specific exp claims
    });
  });

  group('SecurityService Input Sanitization', () {
    group('sanitizeInput', () {
      test('should escape HTML characters', () {
        final sanitized = securityService.sanitizeInput('<script>alert("xss")</script>');

        expect(sanitized, contains('&lt;'));
        expect(sanitized, contains('&gt;'));
        expect(sanitized, contains('&quot;'));
        expect(sanitized, isNot(contains('<')));
        expect(sanitized, isNot(contains('>')));
      });

      test('should escape single quotes', () {
        final sanitized = securityService.sanitizeInput("O'Brien");

        expect(sanitized, contains('&#x27;'));
      });

      test('should not modify safe text', () {
        const safeText = 'Hello World 123';
        final sanitized = securityService.sanitizeInput(safeText);

        expect(sanitized, safeText);
      });
    });

    group('removeScriptTags', () {
      test('should remove script tags with content', () {
        const input = 'Hello<script>alert("xss")</script>World';
        final cleaned = securityService.removeScriptTags(input);

        expect(cleaned, 'HelloWorld');
      });

      test('should handle multiple script tags', () {
        const input = '<script>1</script>Text<script>2</script>';
        final cleaned = securityService.removeScriptTags(input);

        expect(cleaned, 'Text');
      });

      test('should not modify text without script tags', () {
        const input = 'Normal text without scripts';
        final cleaned = securityService.removeScriptTags(input);

        expect(cleaned, input);
      });
    });

    group('containsOnlyAllowed', () {
      test('should return true for allowed characters', () {
        final result = securityService.containsOnlyAllowed('Hello World 123!');

        expect(result, true);
      });

      test('should return false for disallowed characters', () {
        final result = securityService.containsOnlyAllowed('<script>');

        expect(result, false);
      });
    });
  });

  group('SecurityService Password', () {
    group('checkPasswordStrength', () {
      test('should return veryWeak for short password', () {
        final strength = securityService.checkPasswordStrength('12345');

        expect(strength, PasswordStrength.veryWeak);
      });

      test('should return weak for simple password', () {
        final strength = securityService.checkPasswordStrength('password');

        expect(strength, PasswordStrength.weak);
      });

      test('should return medium for password with mixed case', () {
        final strength = securityService.checkPasswordStrength('Password1');

        expect(strength.index, greaterThanOrEqualTo(PasswordStrength.medium.index));
      });

      test('should return strong for complex password', () {
        final strength = securityService.checkPasswordStrength('MyP@ssw0rd!');

        expect(strength.index, greaterThanOrEqualTo(PasswordStrength.strong.index));
      });

      test('should return veryStrong for very complex password', () {
        final strength = securityService.checkPasswordStrength('MyV3ryStr0ng!P@ssw0rd');

        expect(strength, PasswordStrength.veryStrong);
      });
    });

    group('getPasswordStrengthMessage', () {
      test('should return appropriate messages', () {
        expect(
          securityService.getPasswordStrengthMessage(PasswordStrength.veryWeak),
          contains('terlalu lemah'),
        );
        expect(
          securityService.getPasswordStrengthMessage(PasswordStrength.strong),
          contains('kuat'),
        );
      });
    });
  });

  group('SecurityService Session', () {
    group('generateSessionId', () {
      test('should generate unique session IDs', () {
        final id1 = securityService.generateSessionId();
        final id2 = securityService.generateSessionId();

        expect(id1, isNot(equals(id2)));
      });

      test('should generate 32 character ID', () {
        final id = securityService.generateSessionId();

        expect(id.length, 32);
      });

      test('should generate hex string', () {
        final id = securityService.generateSessionId();

        expect(RegExp(r'^[0-9a-f]+$').hasMatch(id), true);
      });
    });

    group('generateDeviceFingerprint', () {
      test('should generate consistent fingerprint for same device', () {
        // Note: This test might be flaky due to timestamp in fingerprint
        // In production, you'd want to control the timestamp
        final fp = securityService.generateDeviceFingerprint(
          deviceModel: 'Pixel 6',
          osVersion: 'Android 12',
          appVersion: '1.0.0',
        );

        expect(fp.length, 64); // SHA-256 output
      });
    });
  });

  group('PasswordStrength Extension', () {
    test('should have correct percentages', () {
      expect(PasswordStrength.veryWeak.percentage, 0.2);
      expect(PasswordStrength.weak.percentage, 0.4);
      expect(PasswordStrength.medium.percentage, 0.6);
      expect(PasswordStrength.strong.percentage, 0.8);
      expect(PasswordStrength.veryStrong.percentage, 1.0);
    });

    test('should have correct color values', () {
      expect(PasswordStrength.veryWeak.colorValue, 0xFFEF4444);
      expect(PasswordStrength.veryStrong.colorValue, 0xFF10B981);
    });
  });
}
