class Registermodel {
  final String shopName;
  final String email;
  final String phone;
  final String password;

  Registermodel({
    required this.shopName,
    required this.password,
    required this.email,
    required this.phone,
  });

  bool get isValid =>
      shopName.isNotEmpty &&
      email.isNotEmpty &&
      phone.isNotEmpty &&
      password.isNotEmpty;
  Registermodel copyWith({
    String? name,
    String? pass,
    String? phon,
    String? email,
  }) {
    return Registermodel(
      shopName: name ?? this.shopName,
      password: pass ?? this.password,
      email: email ?? this.email,
      phone: phon ?? this.phone,
    );
  }
}
