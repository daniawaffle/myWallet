import 'package:expenses_app/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> registerWithEmailAndPassword(AppUser appUser) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: appUser.email, password: appUser.password);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(AppUser appUser) async {
    // return await _auth.signInWithEmailAndPassword(
    //     email: appUser.email, password: appUser.password);
    try {
      return await _auth.signInWithEmailAndPassword(
          email: appUser.email, password: appUser.password);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        message: e.message,
        code: e.code,
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
