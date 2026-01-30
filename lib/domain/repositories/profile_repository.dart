/// Profile Repository Interface
library;

import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/user_model.dart';

/// Interface repository untuk profile user.
abstract class ProfileRepository {
  /// Mendapatkan profile user yang sedang login.
  Future<Either<Failure, UserModel>> getUserProfile();

  /// Stream profile user (untuk real-time updates).
  Stream<Either<Failure, UserModel>> getUserProfileStream();

  /// Mengupdate profile user.
  Future<Either<Failure, UserModel>> updateProfile({
    required String name,
    required String phone,
    required String address,
  });

  /// Mengupdate foto profile.
  ///
  /// Note: Memerlukan Firebase Storage (Blaze plan)
  Future<Either<Failure, String>> updateProfilePhoto(String localPath);

  /// Menghapus foto profile.
  Future<Either<Failure, void>> deleteProfilePhoto();
}
