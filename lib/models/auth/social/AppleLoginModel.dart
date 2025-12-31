class AppleLoginModel {
  final String firstname;
  final String lastname;
  final String name;
  final String email;
  final String appleId;
  final String role;

  AppleLoginModel({
    required this.firstname,
    required this.lastname,
    required this.name,
    required this.email,
    required this.appleId,
    required this.role,
  });

  factory AppleLoginModel.fromJson(Map<String, dynamic> json) {
    return AppleLoginModel(
      firstname: json['firstname'],
      lastname: json['lastname'],
      name: json['name'],
      email: json['email'],
      appleId: json['appleId'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstname": firstname,
      "lastname": lastname,
      "name": name,
      "email": email,
      "appleId": appleId,
      "role": role,
    };
  }
}
