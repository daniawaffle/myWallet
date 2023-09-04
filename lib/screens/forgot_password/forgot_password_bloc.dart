import 'package:expenses_app/extentions.dart';
import 'package:flutter/cupertino.dart';
import '../../services/firebase_auth.dart';

class ForgotPasswordBloc {
  bool isPasswordVisable = false;
  final formkey = GlobalKey<FormState>();
  final FirebaseAuthService authService = FirebaseAuthService();
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter E-mail';
    } else if (!value.isValidEmail()) {
      return 'Enter a valid email format';
    } else {
      return null;
    }
  }

  void handleForgotPassword(String email) async {
    try {
      await authService.resetPassword(email);
    } catch (e) {
      rethrow;
    }
  }
}
