/// Unit tests untuk Failures
library;
import 'package:dormflow_mobile/core/error/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failures', () {
    group('ServerFailure', () {
      test('should have default message', () {
        const failure = ServerFailure();
        expect(failure.message, 'Terjadi kesalahan server');
      });

      test('should accept custom message', () {
        const failure = ServerFailure('Custom error');
        expect(failure.message, 'Custom error');
      });

      test('should be equatable', () {
        const failure1 = ServerFailure('Error');
        const failure2 = ServerFailure('Error');
        expect(failure1, equals(failure2));
      });
    });

    group('AuthFailure', () {
      test('should store message', () {
        const failure = AuthFailure('Login failed');
        expect(failure.message, 'Login failed');
      });

      test('should create from user-not-found code', () {
        final failure = AuthFailure.fromCode('user-not-found');
        expect(failure.message, 'Email tidak terdaftar');
      });

      test('should create from wrong-password code', () {
        final failure = AuthFailure.fromCode('wrong-password');
        expect(failure.message, 'Password salah');
      });

      test('should create from invalid-email code', () {
        final failure = AuthFailure.fromCode('invalid-email');
        expect(failure.message, 'Format email tidak valid');
      });

      test('should create from user-disabled code', () {
        final failure = AuthFailure.fromCode('user-disabled');
        expect(failure.message, 'Akun telah dinonaktifkan');
      });

      test('should create from email-already-in-use code', () {
        final failure = AuthFailure.fromCode('email-already-in-use');
        expect(failure.message, 'Email sudah digunakan');
      });

      test('should create from weak-password code', () {
        final failure = AuthFailure.fromCode('weak-password');
        expect(failure.message, 'Password terlalu lemah');
      });

      test('should create from too-many-requests code', () {
        final failure = AuthFailure.fromCode('too-many-requests');
        expect(failure.message, contains('Terlalu banyak percobaan'));
      });

      test('should create from unknown code', () {
        final failure = AuthFailure.fromCode('unknown-error');
        expect(failure.message, contains('unknown-error'));
      });
    });

    group('NetworkFailure', () {
      test('should have default message', () {
        const failure = NetworkFailure();
        expect(failure.message, 'Tidak ada koneksi internet');
      });
    });

    group('CacheFailure', () {
      test('should have default message', () {
        const failure = CacheFailure();
        expect(failure.message, 'Gagal mengakses data lokal');
      });
    });

    group('ValidationFailure', () {
      test('should store message', () {
        const failure = ValidationFailure('Invalid input');
        expect(failure.message, 'Invalid input');
      });
    });

    group('NotFoundFailure', () {
      test('should have default message', () {
        const failure = NotFoundFailure();
        expect(failure.message, 'Data tidak ditemukan');
      });
    });

    group('PermissionFailure', () {
      test('should have default message', () {
        const failure = PermissionFailure();
        expect(failure.message, contains('tidak memiliki izin'));
      });
    });

    group('Equatable', () {
      test('failures with same message should be equal', () {
        const failure1 = AuthFailure('Test');
        const failure2 = AuthFailure('Test');
        expect(failure1, equals(failure2));
        expect(failure1.props, equals(failure2.props));
      });

      test('failures with different message should not be equal', () {
        const failure1 = AuthFailure('Test1');
        const failure2 = AuthFailure('Test2');
        expect(failure1, isNot(equals(failure2)));
      });
    });
  });
}
