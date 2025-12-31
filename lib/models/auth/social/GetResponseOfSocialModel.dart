
class ResponseOfSocialMediaModel {
  final bool success;
  final String role;
  final String token;
  final UserModel user;

  ResponseOfSocialMediaModel({
    required this.success,
    required this.role,
    required this.token,
    required this.user,

  });

  factory ResponseOfSocialMediaModel.fromJson(Map<String, dynamic> json) {
    return ResponseOfSocialMediaModel(
      success: json['success'],
      role: json['role'],
      token: json['token'],
      user: UserModel.fromJson(json['user']),

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "role": role,
      "token": token,
      "user": user.toJson(),

    };
  }
}

class UserModel {
  final String id;


  UserModel({
    required this.id,

  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,

    };
  }
}