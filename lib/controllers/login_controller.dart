class LoginController {
  bool validateLogin(String email, String password) {
    return email.isNotEmpty && password.length >= 6;
  }
}
