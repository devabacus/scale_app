import 'package:firebase_auth/firebase_auth.dart' show User;

abstract class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();
}
