class VerifySignInOtpModel {
  final String? phone;
  final String otp;
  final String? email;

  VerifySignInOtpModel({
    this.phone,
    required this.otp,
    this.email,
  });

  factory VerifySignInOtpModel.fromJson(Map<String, dynamic> json) {
    return VerifySignInOtpModel(
      phone: json['phone'],
      otp: json['otp'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'otp': otp,
    };
    if (phone != null && phone!.isNotEmpty) {
      map['phone'] = phone;
    }
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    return map;
  }
}
