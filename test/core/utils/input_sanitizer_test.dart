/// Unit tests untuk InputSanitizer
library;
import 'package:dormflow_mobile/core/utils/input_sanitizer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InputSanitizer', () {
    group('sanitizeText', () {
      test('should escape HTML special characters', () {
        final result = InputSanitizer.sanitizeText('<script>alert("xss")</script>');
        expect(result, contains('&lt;'));
        expect(result, contains('&gt;'));
        expect(result, contains('&quot;'));
        expect(result, isNot(contains('<script>')));
      });

      test('should escape ampersand', () {
        final result = InputSanitizer.sanitizeText('Tom & Jerry');
        expect(result, 'Tom &amp; Jerry');
      });

      test('should escape single quotes', () {
        final result = InputSanitizer.sanitizeText("It's a test");
        expect(result, contains('&#x27;'));
      });

      test('should trim whitespace', () {
        final result = InputSanitizer.sanitizeText('  hello world  ');
        expect(result, 'hello world');
      });
    });

    group('sanitizeEmail', () {
      test('should lowercase email', () {
        final result = InputSanitizer.sanitizeEmail('Test@EXAMPLE.COM');
        expect(result, 'test@example.com');
      });

      test('should trim whitespace', () {
        final result = InputSanitizer.sanitizeEmail('  test@example.com  ');
        expect(result, 'test@example.com');
      });
    });

    group('stripHtml', () {
      test('should remove HTML tags', () {
        final result = InputSanitizer.stripHtml('<p>Hello <b>World</b></p>');
        expect(result, 'Hello World');
      });

      test('should remove HTML entities', () {
        final result = InputSanitizer.stripHtml('Hello&nbsp;World');
        expect(result, 'HelloWorld');
      });

      test('should handle complex HTML', () {
        final result = InputSanitizer.stripHtml(
          '<div class="test"><span>Content</span></div>',
        );
        expect(result, 'Content');
      });
    });

    group('sanitizeName', () {
      test('should keep valid name characters', () {
        final result = InputSanitizer.sanitizeName('John Doe');
        expect(result, 'John Doe');
      });

      test('should keep apostrophe in names', () {
        final result = InputSanitizer.sanitizeName("O'Brien");
        expect(result, contains("'"));
      });

      test('should keep hyphen in names', () {
        final result = InputSanitizer.sanitizeName('Mary-Jane');
        expect(result, 'Mary-Jane');
      });

      test('should collapse multiple spaces', () {
        final result = InputSanitizer.sanitizeName('John    Doe');
        expect(result, 'John Doe');
      });

      test('should trim whitespace', () {
        final result = InputSanitizer.sanitizeName('  John Doe  ');
        expect(result, 'John Doe');
      });
    });

    group('sanitizePhone', () {
      test('should remove non-digit characters except +', () {
        final result = InputSanitizer.sanitizePhone('(081) 234-567-890');
        expect(result, '+6281234567890');
      });

      test('should add +62 prefix to numbers starting with 0', () {
        final result = InputSanitizer.sanitizePhone('081234567890');
        expect(result, '+6281234567890');
      });

      test('should add + prefix to numbers starting with 62', () {
        final result = InputSanitizer.sanitizePhone('6281234567890');
        expect(result, '+6281234567890');
      });

      test('should keep + prefix for international numbers', () {
        final result = InputSanitizer.sanitizePhone('+6281234567890');
        expect(result, '+6281234567890');
      });
    });

    group('sanitizeDescription', () {
      test('should strip HTML from description', () {
        final result = InputSanitizer.sanitizeDescription('<p>Test</p>');
        expect(result, 'Test');
      });

      test('should truncate long descriptions', () {
        final longText = 'A' * 600;
        final result = InputSanitizer.sanitizeDescription(longText);
        expect(result.length, 500);
      });

      test('should not truncate short descriptions', () {
        final result = InputSanitizer.sanitizeDescription('Short text');
        expect(result, 'Short text');
      });
    });

    group('sanitizeAmount', () {
      test('should remove non-numeric characters', () {
        final result = InputSanitizer.sanitizeAmount('Rp 100,000');
        expect(result, '100000');
      });

      test('should keep decimal point', () {
        final result = InputSanitizer.sanitizeAmount('100.50');
        expect(result, '100.50');
      });
    });

    group('decodeHtmlEntities', () {
      test('should decode HTML entities back to characters', () {
        final result = InputSanitizer.decodeHtmlEntities(
          '&lt;script&gt;&quot;test&quot;&lt;/script&gt;',
        );
        expect(result, '<script>"test"</script>');
      });

      test('should decode ampersand last', () {
        final result = InputSanitizer.decodeHtmlEntities('Tom &amp; Jerry');
        expect(result, 'Tom & Jerry');
      });
    });
  });
}
