class LoginCredentials {
  final String email;
  final String password;

  LoginCredentials({required this.email, required this.password});

  bool get isValide => email.isNotEmpty && password.isNotEmpty;
}
