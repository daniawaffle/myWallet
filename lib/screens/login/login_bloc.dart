import 'dart:async';
import 'package:expenses_app/extentions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../../models/user.dart';
import '../../services/firebase_auth.dart';

class LoginBloc {
  bool isPasswordVisable = false;
  final formkey = GlobalKey<FormState>();
  final StreamController<bool> passStreamController = StreamController<bool>();
  final FirebaseAuthService authService = FirebaseAuthService();
  AppUser? appUser;

  void togglePasswordVisibility() {
    isPasswordVisable = !isPasswordVisable;
    passStreamController.sink.add(isPasswordVisable);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter E-mail';
    } else if (!value.isValidEmail()) {
      return 'Enter a valid email format';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    } else {
      return null;
    }
  }

  Future<void> loginToFirebase(String email, String password) async {
    if (formkey.currentState!.validate()) {
      appUser = AppUser(
        email: email.trim(),
        password: password,
      );

      try {
        await authService.signInWithEmailAndPassword(appUser!);
      } on FirebaseAuthException catch (e) {
        throw FirebaseAuthException(
          message: e.message,
          code: e.code,
        );
      }
    }
  }
}
