/// Auth Repository Implementation
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

/// Implementasi AuthRepository menggunakan Firebase.
class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl({
    required fb.FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;
  final fb.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (credential.user == null) {
        return const Left(AuthFailure('Login gagal'));
      }

      // Ambil data tambahan dari Firestore jika ada
      final userDoc = await _firestore
          .collection(FirestoreCollections.users)
          .doc(credential.user!.uid)
          .get();

      final userData = userDoc.exists ? userDoc.data() : null;
      final user = UserModel.fromFirebaseUser(credential.user!, userData);

      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code}');
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      debugPrint('Login error: $e');
      return Left(ServerFailure('Terjadi kesalahan: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );

      if (credential.user == null) {
        return const Left(AuthFailure('Registrasi gagal'));
      }

      // Buat document user di Firestore
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(credential.user!.uid)
          .set({
        'email': credential.user!.email,
        'name': '',
        'role': 'Admin',
        'createdAt': FieldValue.serverTimestamp(),
      });

      final user = UserModel.fromFirebaseUser(credential.user!);
      return Right(user);
    } on fb.FirebaseAuthException catch (e) {
      debugPrint('Signup error: ${e.code}');
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      debugPrint('Signup error: $e');
      return Left(ServerFailure('Terjadi kesalahan: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      debugPrint('Logout error: $e');
      return Left(ServerFailure('Gagal logout: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email.trim().toLowerCase(),
      );
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      return Left(ServerFailure('Gagal mengirim email reset: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return const Left(AuthFailure('User tidak login'));
      }

      // Re-authenticate
      final credential = fb.EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
      return const Right(null);
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return const Left(AuthFailure('Password lama salah'));
      }
      return Left(AuthFailure.fromCode(e.code));
    } catch (e) {
      return Left(ServerFailure('Gagal update password: $e'));
    }
  }
}
