class AppUser {
  String email;
  String password;

  AppUser({required this.email, required this.password});

  // bool isValidCredentials() {
  //   return isEmailValid() && isPasswordValid();
  // }

  // bool authenticate(String inputEmail, String inputPassword) {
  //   return email == inputEmail && password == inputPassword;
  // }
}
