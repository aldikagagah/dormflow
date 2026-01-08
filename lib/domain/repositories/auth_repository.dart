/// Auth Repository Interface
///
/// Abstraksi untuk operasi autentikasi.
/// Implementasi bisa menggunakan Firebase, atau mock untuk testing.
library;

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/user_model.dart';

/// Interface repository untuk autentikasi.
abstract class AuthRepository {
  /// Login dengan email dan password.
  ///
  /// Returns [Either] dengan:
  /// - [Left] berisi [Failure] jika gagal
  /// - [Right] berisi [UserModel] jika sukses
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  });

  /// Registrasi user baru.
  ///
  /// Returns [Either] dengan:
  /// - [Left] berisi [Failure] jika gagal
  /// - [Right] berisi [UserModel] jika sukses
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
  });

  /// Logout user yang sedang login.
  Future<Either<Failure, void>> signOut();

  /// Mendapatkan user yang sedang login.
  ///
  /// Returns null jika tidak ada user yang login.
  UserModel? get currentUser;

  /// Stream perubahan status autentikasi.
  Stream<UserModel?> get authStateChanges;

  /// Reset password via email.
  Future<Either<Failure, void>> resetPassword(String email);

  /// Update password user yang sedang login.
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  });
}
