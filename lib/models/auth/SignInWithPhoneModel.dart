class SignInWithPhoneModel {
  final String phone;
  final String? email;
  final String? password;

  SignInWithPhoneModel({
    required this.phone,
    this.email,
    this.password,
  });

  factory SignInWithPhoneModel.fromJson(Map<String, dynamic> json) {
    return SignInWithPhoneModel(
      phone: json['phone'] ?? '',
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      if (email != null) 'email': email,
      if (password != null) 'password': password,
    };
  }
}
