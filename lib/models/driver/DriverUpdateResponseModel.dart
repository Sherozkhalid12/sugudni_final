class DriverUpdateResponseModel {
  final String message;
  final UpdateUser updateUser;

  DriverUpdateResponseModel({
    required this.message,
    required this.updateUser,
  });

  factory DriverUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverUpdateResponseModel(
      message: json['message'] ?? '',
      updateUser: UpdateUser.fromJson(json['updateUser']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'updateUser': updateUser.toJson(),
    };
  }
}

class UpdateUser {
  final String id;
  final String name;
  final String email;
  final String password;
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
  final DateTime drivingSince;
  final DateTime dob;
  final List<dynamic> wishlist;
  final List<dynamic> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String walletId;
  final String firstname;
  final String lastname;
  final String phone;

  UpdateUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
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
    required this.drivingSince,
    required this.dob,
    required this.wishlist,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.walletId,
    required this.firstname,
    required this.lastname,
    required this.phone,
  });

  factory UpdateUser.fromJson(Map<String, dynamic> json) {
    return UpdateUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
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
      drivingSince: DateTime.parse(json['drivingSince']),
      dob: DateTime.parse(json['dob']),
      wishlist: json['wishlist'] ?? [],
      addresses: json['addresses'] ?? [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
      walletId: json['walletid'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
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
      'drivingSince': drivingSince.toIso8601String(),
      'dob': dob.toIso8601String(),
      'wishlist': wishlist,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      'walletid': walletId,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
    };
  }
}
