import 'dart:async';
import 'package:expenses_app/extentions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../models/user.dart';
import '../../services/firebase_auth.dart';

class SignupBloc {
  bool isPasswordVisable = false;
  final formkey = GlobalKey<FormState>();
  final StreamController<bool> passStreamController = StreamController<bool>();
  final FirebaseAuthService authService = FirebaseAuthService();

  // String? validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Please Enter Password';
  //   } else {
  //     return null;
  //   }
  // }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter E-mail';
    } else if (!value.isValidEmail()) {
      return 'Enter a valid email format';
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 6) {
      return 'Password must be at least 6 characters long';
    } else {
      return null; // Password is valid
    }
  }

  String? validatePasswordsMatch(String? value1, String? value2) {
    if (value1 != value2) {
      return 'Password does not match';
    } else {
      return null; // Strings match
    }
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      final appUser = AppUser(
        email: email.trim(),
        password: password,
      );
      return await authService.registerWithEmailAndPassword(appUser);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        message: e.message,
        code: e.code,
      );
    } on PlatformException catch (signUpError) {
      throw PlatformException(
          code: signUpError.code, message: signUpError.message);
    } catch (e) {
      rethrow;
    }
  }
}
