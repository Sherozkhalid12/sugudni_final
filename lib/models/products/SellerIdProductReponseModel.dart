class SellerIdProductResponseModel {
  final String id;
  final String firstname;
  final String lastname;
  final List<dynamic> adminPrivileges;
  final String appleId;
  final String twitterId;
  final List<dynamic> fcmToken;
  final String driverStatus;
  final String rejectionReason;
  final List<dynamic> pickups;
  final String name;
  final String phone;
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
  final DateTime? drivingSince;
  final DateTime? dob;
  final List<dynamic> wishlist;
  final List<dynamic> addresses;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String walletId;

  SellerIdProductResponseModel({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.adminPrivileges,
    required this.appleId,
    required this.twitterId,
    required this.fcmToken,
    required this.driverStatus,
    required this.rejectionReason,
    required this.pickups,
    required this.name,
    required this.phone,
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
    this.drivingSince,
    this.dob,
    required this.wishlist,
    required this.addresses,
    required this.createdAt,
    required this.updatedAt,
    required this.walletId,
  });

  factory SellerIdProductResponseModel.fromJson(Map<String, dynamic> json) {
    return SellerIdProductResponseModel(
      id: json['_id'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      adminPrivileges: json['adminPrivillages'] ?? [],
      appleId: json['appleId'] ?? '',
      twitterId: json['twitterId'] ?? '',
      fcmToken: json['fcmtoken'] ?? [],
      driverStatus: json['driverStatus'] ?? 'pending',
      rejectionReason: json['rejectionReason'] ?? '',
      pickups: json['pickups'] ?? [],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'seller',
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
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      walletId: json['walletid'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstname': firstname,
      'lastname': lastname,
      'adminPrivillages': adminPrivileges,
      'appleId': appleId,
      'twitterId': twitterId,
      'fcmtoken': fcmToken,
      'driverStatus': driverStatus,
      'rejectionReason': rejectionReason,
      'pickups': pickups,
      'name': name,
      'phone': phone,
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
      'drivingSince': drivingSince?.toIso8601String(),
      'dob': dob?.toIso8601String(),
      'wishlist': wishlist,
      'addresses': addresses,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'walletid': walletId,
    };
  }
}
