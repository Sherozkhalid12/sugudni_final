class GetDriverDataResponse {
  final String message;
  final DriverUser user;

  GetDriverDataResponse({required this.message, required this.user});

  factory GetDriverDataResponse.fromJson(Map<String, dynamic> json) {
    return GetDriverDataResponse(
      message: json['message'] ?? '',
      user: DriverUser.fromJson((json['user'] ?? {}) as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user.toJson(),
    };
  }
}

class DriverUser {
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
  final String walletId;
  final String firstname;
  final String lastname;
  final String phone;
  final String driverStatus;
  final String rejectionReason;
  final bool driverOnline;

  DriverUser({
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
    required this.walletId,
    required this.firstname,
    required this.lastname,
    required this.phone,
    required this.driverStatus,
    required this.rejectionReason,
    required this.driverOnline,
  });

  factory DriverUser.fromJson(Map<String, dynamic> json) {
    return DriverUser(
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
      drivingSince: json['drivingSince'] != null ? DateTime.parse(json['drivingSince']) : null,
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      wishlist: List<dynamic>.from(json['wishlist'] ?? []),
      addresses: List<dynamic>.from(json['addresses'] ?? []),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      walletId: json['walletid'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      phone: json['phone'] ?? '',
      driverStatus: json['driverStatus'] ?? 'pending',
      rejectionReason: json['rejectionReason'] ?? '',
      driverOnline: json['driverOnline'] ?? false,
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
      'walletid': walletId,
      'firstname': firstname,
      'lastname': lastname,
      'phone': phone,
      'driverStatus': driverStatus,
      'rejectionReason': rejectionReason,
      'driverOnline': driverOnline,
    };
  }
}
