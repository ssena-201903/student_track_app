import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  // Oturum açma
  Future<User?> signIn({required String email, required String password}) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Oturum kapatma
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Oturum değişikliklerini dinleme
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});