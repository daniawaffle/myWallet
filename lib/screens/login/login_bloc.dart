import 'dart:async';

class LoginBloc {
  bool isPasswordVisable = false;
  final StreamController<bool> passStreamController = StreamController<bool>();

  void togglePasswordVisibility() {
    isPasswordVisable = !isPasswordVisable;
    passStreamController.sink.add(isPasswordVisable);
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter Password';
    } else {
      return null;
    }
  }
}
