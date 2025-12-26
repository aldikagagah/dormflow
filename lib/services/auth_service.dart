import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // ✅ For debugPrint

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔐 LOGIN
  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      debugPrint('Login error: $e'); // ✅ Use debugPrint
      return null;
    }
  }

  // 🆕 REGISTER
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      debugPrint('Signup error: $e'); // ✅ Use debugPrint
      return null;
    }
  }

  // 🚪 LOGOUT
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
