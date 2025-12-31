class UpdateSellerModel {
  final String name;
  final String email;
  final String phone;
  final String? password; // Optional field

  UpdateSellerModel({
    required this.name,
    required this.email,
    required this.phone,
    this.password, // Optional parameter
  });

  factory UpdateSellerModel.fromJson(Map<String, dynamic> json) {
    return UpdateSellerModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'], // Can be null
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'email': email,
      'phone': phone,
    };

    // Only add password to JSON if it is not null or empty
    if (password != null && password!.isNotEmpty) {
      data['password'] = password!;
    }

    return data;
  }
}
