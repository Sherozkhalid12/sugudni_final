// class SuccessfullVerifySignInOtpModel {
//   final bool success;
//   final String role;
//   final User user;
//   final String token;
//
//   SuccessfullVerifySignInOtpModel({
//     required this.success,
//     required this.role,
//     required this.user,
//     required this.token,
//   });
//
//   factory SuccessfullVerifySignInOtpModel.fromJson(Map<String, dynamic> json) {
//     return SuccessfullVerifySignInOtpModel(
//       success: json['Success'] ?? false,
//       role: json['role'] ?? '',
//       user: User.fromJson(json['user'] ?? {}),
//       token: json['token'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Success': success,
//       'role': role,
//       'user': user.toJson(),
//       'token': token,
//     };
//   }
// }
class SuccessfullVerifySignInOtpModel {
  final bool success;
  final String role;
  final User user;
  final String token;
  final String message; // Added to match the API response

  SuccessfullVerifySignInOtpModel({
    required this.success,
    required this.role,
    required this.user,
    required this.token,
    required this.message,
  });

  factory SuccessfullVerifySignInOtpModel.fromJson(Map<String, dynamic> json) {
    return SuccessfullVerifySignInOtpModel(
      success: json['Success'] ?? false,
      role: json['role'] ?? '',
      user: User.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
      message: json['message'] ?? '', // Default to empty string if not present
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Success': success,
      'role': role,
      'user': user.toJson(),
      'token': token,
      'message': message,
    };
  }
}
class User {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role;
  final bool isActive;
  final bool verified;
  final bool blocked;
  final bool emailVerified;
  final bool phoneVerified;
  final String profilePic;
  final List<dynamic> wishlist;
  final List<dynamic> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String walletId;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.isActive,
    required this.verified,
    required this.blocked,
    required this.emailVerified,
    required this.phoneVerified,
    required this.profilePic,
    required this.wishlist,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.walletId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      verified: json['verified'] ?? false,
      blocked: json['blocked'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      profilePic: json['profilePic'] ?? '',
      wishlist: json['wishlist'] ?? [],
      addresses: json['addresses'] ?? [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
      v: json['__v'] ?? 0,
      walletId: json['walletid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'isActive': isActive,
      'verified': verified,
      'blocked': blocked,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'profilePic': profilePic,
      'wishlist': wishlist,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'walletid': walletId,
    };
  }
}
