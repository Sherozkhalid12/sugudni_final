class SignInResponseModel {
  final bool success;
  final User user;
  final String role;
  final String token;

  SignInResponseModel({
    required this.success,
    required this.user,
    required this.role,
    required this.token,
  });

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      success: json['success'] ?? false,
      user: User.fromJson(json['user']),
      role: json['role'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'user': user.toJson(),
      'token': token,
      'role': role,
    };
  }
}

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool isActive;
  final bool verified;
  final bool blocked;
  final bool emailVerified;
  final bool phoneVerified;
  final String profilePic;
  final String licenseNumber;
  final String bikeRegistrationNumber;
  final String licenseFront;
  final String licenseBack;
  final DateTime? drivingSince;
  final DateTime? dob;
  final List<dynamic> wishlist;
  final List<dynamic> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String walletId;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.isActive,
    required this.verified,
    required this.blocked,
    required this.emailVerified,
    required this.phoneVerified,
    required this.profilePic,
    required this.licenseNumber,
    required this.bikeRegistrationNumber,
    required this.licenseFront,
    required this.licenseBack,
    this.drivingSince,
    this.dob,
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
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      isActive: json['isActive'] ?? false,
      verified: json['verified'] ?? false,
      blocked: json['blocked'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      profilePic: json['profilePic'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      bikeRegistrationNumber: json['bikeRegistrationNumber'] ?? '',
      licenseFront: json['licenseFront'] ?? '',
      licenseBack: json['licenseBack'] ?? '',
      drivingSince: json['drivingSince'] != null ? DateTime.tryParse(json['drivingSince']) : null,
      dob: json['dob'] != null ? DateTime.tryParse(json['dob']) : null,
      wishlist: json['wishlist'] ?? [],
      addresses: json['addresses'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      walletId: json['walletid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'isActive': isActive,
      'verified': verified,
      'blocked': blocked,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'profilePic': profilePic,
      'licenseNumber': licenseNumber,
      'bikeRegistrationNumber': bikeRegistrationNumber,
      'licenseFront': licenseFront,
      'licenseBack': licenseBack,
      'drivingSince': drivingSince?.toIso8601String(),
      'dob': dob?.toIso8601String(),
      'wishlist': wishlist,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'walletid': walletId,
    };
  }
}
