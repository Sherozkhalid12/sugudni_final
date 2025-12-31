class GoogleLoginModel {
  final String name;
  final String picUrl;
  final String email;
  final String role;

  GoogleLoginModel({
    required this.name,
    required this.picUrl,
    required this.email,
    required this.role,
  });

  factory GoogleLoginModel.fromJson(Map<String, dynamic> json) {
    return GoogleLoginModel(
      name: json['name'],
      picUrl: json['picUrl'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "picUrl": picUrl,
      "email": email,
      "role": role,
    };
  }
}
