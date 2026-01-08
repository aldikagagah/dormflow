/// Profile Repository Implementation
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_model.dart';

/// Implementasi ProfileRepository menggunakan Firebase.
class ProfileRepositoryImpl implements ProfileRepository {

  ProfileRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  fb.User? get _currentUser => _firebaseAuth.currentUser;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(FirestoreCollections.users).doc(uid);

  @override
  Future<Either<Failure, UserModel>> getUserProfile() async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      final doc = await _userDoc(user.uid).get();
      final data = doc.exists ? doc.data() : null;

      return Right(UserModel.fromFirebaseUser(user, data));
    } catch (e) {
      debugPrint('Get profile error: $e');
      return Left(ServerFailure('Gagal mengambil profile: $e'));
    }
  }

  @override
  Stream<Either<Failure, UserModel>> getUserProfileStream() {
    final user = _currentUser;
    if (user == null) {
      return Stream.value(const Left(AuthFailure('User tidak login')));
    }

    return _userDoc(user.uid).snapshots().map((doc) {
      try {
        final data = doc.exists ? doc.data() : null;
        return Right(UserModel.fromFirebaseUser(user, data));
      } catch (e) {
        return Left(ServerFailure('Gagal memproses data: $e'));
      }
    });
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      // Update Firebase Auth display name
      await user.updateDisplayName(name);

      // Update Firestore data
      await _userDoc(user.uid).set({
        'name': name,
        'phone': phone,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Reload user untuk mendapatkan data terbaru
      await user.reload();

      final doc = await _userDoc(user.uid).get();
      return Right(UserModel.fromFirebaseUser(
        _firebaseAuth.currentUser!,
        doc.data(),
      ));
    } catch (e) {
      debugPrint('Update profile error: $e');
      return Left(ServerFailure('Gagal update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> updateProfilePhoto(String localPath) async {
    // Firebase Storage memerlukan Blaze plan
    // Untuk saat ini, return failure
    return const Left(PermissionFailure(
      'Fitur upload foto memerlukan Firebase Storage (Blaze plan)',
    ));
  }

  @override
  Future<Either<Failure, void>> deleteProfilePhoto() async {
    try {
      final user = _currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      await user.updatePhotoURL(null);
      await _userDoc(user.uid).update({
        'photoUrl': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (e) {
      debugPrint('Delete photo error: $e');
      return Left(ServerFailure('Gagal hapus foto: $e'));
    }
  }
}
