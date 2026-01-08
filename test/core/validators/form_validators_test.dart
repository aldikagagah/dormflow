/// Unit tests untuk FormValidators
library;
import 'package:dormflow_mobile/core/validators/form_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormValidators', () {
    group('email', () {
      test('should return error when email is null', () {
        final result = FormValidators.email(null);
        expect(result, 'Email wajib diisi');
      });

      test('should return error when email is empty', () {
        final result = FormValidators.email('');
        expect(result, 'Email wajib diisi');
      });

      test('should return error when email is only whitespace', () {
        final result = FormValidators.email('   ');
        expect(result, 'Email wajib diisi');
      });

      test('should return error for invalid email format', () {
        final invalidEmails = [
          'invalid',
          'invalid@',
          '@invalid.com',
          'invalid@.com',
          'invalid@com',
          'invalid email@test.com',
        ];

        for (final email in invalidEmails) {
          final result = FormValidators.email(email);
          expect(result, 'Format email tidak valid', reason: 'Failed for: $email');
        }
      });

      test('should return null for valid email', () {
        final validEmails = [
          'test@example.com',
          'user.name@domain.co.id',
          'user+tag@gmail.com',
          'TEST@EXAMPLE.COM',
        ];

        for (final email in validEmails) {
          final result = FormValidators.email(email);
          expect(result, isNull, reason: 'Failed for: $email');
        }
      });
    });

    group('password', () {
      test('should return error when password is null', () {
        final result = FormValidators.password(null);
        expect(result, 'Password wajib diisi');
      });

      test('should return error when password is empty', () {
        final result = FormValidators.password('');
        expect(result, 'Password wajib diisi');
      });

      test('should return error when password is too short', () {
        final result = FormValidators.password('Abc123');
        expect(result, contains('minimal 8 karakter'));
      });

      test('should return error when password has no uppercase', () {
        final result = FormValidators.password('password123');
        expect(result, contains('huruf besar'));
      });

      test('should return error when password has no lowercase', () {
        final result = FormValidators.password('PASSWORD123');
        expect(result, contains('huruf kecil'));
      });

      test('should return error when password has no number', () {
        final result = FormValidators.password('PasswordAbc');
        expect(result, contains('angka'));
      });

      test('should return null for valid password', () {
        final validPasswords = [
          'Password1',
          'MySecure123',
          'Test@Pass1',
        ];

        for (final password in validPasswords) {
          final result = FormValidators.password(password);
          expect(result, isNull, reason: 'Failed for: $password');
        }
      });
    });

    group('passwordSimple', () {
      test('should return error when password is too short', () {
        final result = FormValidators.passwordSimple('12345');
        expect(result, contains('minimal 6 karakter'));
      });

      test('should return null for valid simple password', () {
        final result = FormValidators.passwordSimple('123456');
        expect(result, isNull);
      });
    });

    group('confirmPassword', () {
      test('should return error when passwords do not match', () {
        final result = FormValidators.confirmPassword('password1', 'password2');
        expect(result, 'Password tidak cocok');
      });

      test('should return null when passwords match', () {
        final result = FormValidators.confirmPassword('password', 'password');
        expect(result, isNull);
      });
    });

    group('required', () {
      test('should return error with field name when empty', () {
        final result = FormValidators.required('', 'Nama');
        expect(result, 'Nama wajib diisi');
      });

      test('should return error with default field name when empty', () {
        final result = FormValidators.required('');
        expect(result, 'Field wajib diisi');
      });

      test('should return null when value is provided', () {
        final result = FormValidators.required('value');
        expect(result, isNull);
      });
    });

    group('name', () {
      test('should return error when name is empty', () {
        final result = FormValidators.name('');
        expect(result, 'Nama wajib diisi');
      });

      test('should return error when name is too short', () {
        final result = FormValidators.name('A');
        expect(result, contains('minimal 2 karakter'));
      });

      test('should return null for valid name', () {
        final validNames = [
          'John',
          'John Doe',
          "O'Brien",
          'Mary-Jane',
        ];

        for (final name in validNames) {
          final result = FormValidators.name(name);
          expect(result, isNull, reason: 'Failed for: $name');
        }
      });
    });

    group('phone', () {
      test('should return null for empty phone (optional)', () {
        final result = FormValidators.phone('');
        expect(result, isNull);
      });

      test('should return null for null phone (optional)', () {
        final result = FormValidators.phone(null);
        expect(result, isNull);
      });

      test('should return error for invalid phone format', () {
        final invalidPhones = [
          '12345',
          'abcdefgh',
          '071234567890', // starts with 07, not 08
        ];

        for (final phone in invalidPhones) {
          final result = FormValidators.phone(phone);
          expect(result, isNotNull, reason: 'Should fail for: $phone');
        }
      });

      test('should return null for valid Indonesian phone numbers', () {
        final validPhones = [
          '081234567890',
          '08123456789',
          '+6281234567890',
          '6281234567890',
        ];

        for (final phone in validPhones) {
          final result = FormValidators.phone(phone);
          expect(result, isNull, reason: 'Failed for: $phone');
        }
      });
    });

    group('amount', () {
      test('should return error when amount is empty', () {
        final result = FormValidators.amount('');
        expect(result, 'Jumlah wajib diisi');
      });

      test('should return error when amount is zero', () {
        final result = FormValidators.amount('0');
        expect(result, contains('lebih dari 0'));
      });

      test('should return error when amount is negative', () {
        final result = FormValidators.amount('-100');
        expect(result, contains('lebih dari 0'));
      });

      test('should return null for valid amount', () {
        final validAmounts = [
          '100',
          '1000.50',
          '10,000',
          'Rp 50000',
        ];

        for (final amount in validAmounts) {
          final result = FormValidators.amount(amount);
          expect(result, isNull, reason: 'Failed for: $amount');
        }
      });
    });

    group('description', () {
      test('should return null for empty description when not required', () {
        final result = FormValidators.description('');
        expect(result, isNull);
      });

      test('should return error for empty description when required', () {
        final result = FormValidators.description('', required: true);
        expect(result, 'Deskripsi wajib diisi');
      });

      test('should return null for valid description', () {
        final result = FormValidators.description('This is a valid description');
        expect(result, isNull);
      });
    });
  });
}
