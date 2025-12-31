
import '../address-model/AddressesModel.dart';

class SellerUser {
  final String id;
  final String appleId;
  final String twitterId;
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
  final List<AddressesModel> pickups;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final String walletId;

  SellerUser({
    required this.id,
    required this.appleId,
    required this.twitterId,
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
    required this.pickups,
    this.createdAt,
    this.updatedAt,
    required this.v,
    required this.walletId,
  });

  factory SellerUser.fromJson(Map<String, dynamic> json) {
    return SellerUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      appleId: json['appleId'] ?? 'N/A',
      twitterId: json['twitterId'] ?? 'N/A',
      phone: json['phone'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      role: json['role'] ?? 'N/A',
      isActive: json['isActive'] ?? false,
      verified: json['verified'] ?? false,
      blocked: json['blocked'] ?? false,
      emailVerified: json['emailVerified'] ?? false,
      phoneVerified: json['phoneVerified'] ?? false,
      profilePic: json['profilePic'] ?? '',
      wishlist: json['wishlist'] != null ? List<dynamic>.from(json['wishlist']) : [],
      addresses: json['addresses'] != null ? List<dynamic>.from(json['addresses']) : [],
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      v: json['__v'] ?? 0,
      walletId: json['walletid'] ?? '',
      pickups: json['pickups'] != null
          ? List<AddressesModel>.from(
          json['pickups'].map((x) => AddressesModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'appleId': appleId,
      'twitterId': twitterId,
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
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      '__v': v,
      'walletid': walletId,
    };
  }
}
