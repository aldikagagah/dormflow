/// User Model untuk DormFlow Mobile
///
/// Model immutable menggunakan Freezed untuk data pengguna.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Model data pengguna.
///
/// Immutable class yang merepresentasikan data user dari Firebase Auth
/// dan Firestore.
@freezed
class UserModel with _$UserModel {

  const factory UserModel({
    /// Unique identifier dari Firebase Auth
    required String uid,

    /// Email pengguna
    required String email,

    /// Nama lengkap pengguna
    @Default('') String name,

    /// URL foto profil (nullable)
    String? photoUrl,

    /// Nomor telepon
    @Default('') String phone,

    /// Alamat
    @Default('') String address,

    /// Role pengguna (Admin, Member, etc.)
    @Default('Admin') String role,

    /// Waktu pembuatan akun
    DateTime? createdAt,

    /// Waktu update terakhir
    DateTime? updatedAt,
  }) = _UserModel;
  const UserModel._();

  /// Factory untuk membuat UserModel dari JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Factory untuk membuat UserModel dari Firebase User + Firestore data.
  factory UserModel.fromFirebaseUser(
    fb.User firebaseUser, [
    Map<String, dynamic>? firestoreData,
  ]) {
    final data = firestoreData ?? {};

    String name = firebaseUser.displayName ?? '';
    if (name.isEmpty) {
      name = data['name'] as String? ?? 'User';
    }

    return UserModel(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: name,
      photoUrl: data['photoUrl'] as String? ?? firebaseUser.photoURL,
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      role: data['role'] as String? ?? 'Admin',
      createdAt: firebaseUser.metadata.creationTime,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Factory untuk membuat UserModel dari Firestore DocumentSnapshot.
  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      uid: doc.id,
      email: data['email'] as String? ?? '',
      name: data['name'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String? ?? '',
      address: data['address'] as String? ?? '',
      role: data['role'] as String? ?? 'Admin',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  /// Konversi ke Map untuk disimpan ke Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'phone': phone,
      'address': address,
      'role': role,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Cek apakah user sudah memiliki profile lengkap.
  bool get hasCompleteProfile => name.isNotEmpty && phone.isNotEmpty;

  /// Mendapatkan initial untuk avatar fallback.
  String get initials {
    if (name.isEmpty) return email.isNotEmpty ? email[0].toUpperCase() : '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}
