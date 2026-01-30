import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  /// Fetches the current user's profile data (Auth + Firestore).
  Future<Map<String, dynamic>> getUserProfile() async {
    final user = currentUser;
    if (user == null) return {};

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.exists ? doc.data() as Map<String, dynamic> : <String, dynamic>{};

      String name = user.displayName ?? '';
      if (name.isEmpty) {
        name = (data['name'] as String?) ?? 'Admin';
      }

      return {
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'photoUrl': (data['photoUrl'] as String?) ?? user.photoURL,
        'phone': (data['phone'] as String?) ?? '',
        'address': (data['address'] as String?) ?? '',
        'role': (data['role'] as String?) ?? 'Admin',
        'createdAt': (user.metadata.creationTime)?.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      return {};
    }
  }

  /// Updates profile information.
  Future<String> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    final user = currentUser;
    if (user == null) return 'User not logged in';

    try {
      // Update Firebase Auth Display Name
      await user.updateDisplayName(name);

      // Update Firestore Data
      await _db.collection('users').doc(user.uid).set({
        'name': name,
        'phone': phone,
        'address': address,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return 'success';
    } catch (e) {
      return 'error: $e';
    }
  }

  /// Changes the user's password.
  Future<String> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final user = currentUser;
    if (user == null) return 'User not logged in';

    try {
      // Re-authenticate user
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(cred);

      // Update Password
      await user.updatePassword(newPassword);
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') return 'Password lama salah';
      return 'error: ${e.message}';
    } catch (e) {
      return 'error: $e';
    }
  }
}
