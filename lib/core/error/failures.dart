/// Error handling untuk DormFlow Mobile
///
/// File ini berisi class Failure yang digunakan untuk menangani error
/// dengan cara yang type-safe menggunakan Either pattern dari dartz.
library;

import 'package:equatable/equatable.dart';

/// Base class untuk semua Failure di aplikasi.
///
/// Extends [Equatable] untuk memudahkan perbandingan dalam testing.
abstract class Failure extends Equatable {

  const Failure(this.message, [this.code]);
  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Failure yang terjadi saat komunikasi dengan server/Firebase.
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan server']);
}

/// Failure terkait autentikasi pengguna.
class AuthFailure extends Failure {
  const AuthFailure(super.message);

  /// Factory untuk membuat AuthFailure dari Firebase error code.
  factory AuthFailure.fromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return const AuthFailure('Email tidak terdaftar');
      case 'wrong-password':
        return const AuthFailure('Password salah');
      case 'invalid-email':
        return const AuthFailure('Format email tidak valid');
      case 'user-disabled':
        return const AuthFailure('Akun telah dinonaktifkan');
      case 'email-already-in-use':
        return const AuthFailure('Email sudah digunakan');
      case 'weak-password':
        return const AuthFailure('Password terlalu lemah');
      case 'operation-not-allowed':
        return const AuthFailure('Operasi tidak diizinkan');
      case 'too-many-requests':
        return const AuthFailure('Terlalu banyak percobaan, coba lagi nanti');
      case 'requires-recent-login':
        return const AuthFailure('Silakan login ulang untuk melanjutkan');
      default:
        return AuthFailure('Kesalahan autentikasi: $code');
    }
  }
}

/// Failure terkait koneksi jaringan.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Tidak ada koneksi internet']);
}

/// Failure terkait cache/local storage.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal mengakses data lokal']);
}

/// Failure terkait validasi input.
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure terkait data tidak ditemukan.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Data tidak ditemukan']);
}

/// Failure untuk operasi yang tidak diizinkan.
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Anda tidak memiliki izin untuk melakukan ini']);
}
