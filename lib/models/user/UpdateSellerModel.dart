class UpdateSellerModel {
  final String name;
  final String? email; // Optional - only send if changed
  final String? phone; // Optional - only send if changed
  final String? password; // Optional field

  UpdateSellerModel({
    required this.name,
    this.email, // Optional parameter
    this.phone, // Optional parameter
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
    final data = <String, dynamic>{
      'name': name,
    };

    // Only add email if it's provided and not empty
    if (email != null && email!.isNotEmpty) {
      data['email'] = email!;
    }
    
    // Only add phone if it's provided and not empty
    if (phone != null && phone!.isNotEmpty) {
      data['phone'] = phone!;
    }

    // Only add password to JSON if it is not null or empty
    if (password != null && password!.isNotEmpty) {
      data['password'] = password!;
    }

    return data;
  }
}
