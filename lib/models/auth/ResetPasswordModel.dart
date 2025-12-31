class ResetPasswordModel {
  final String? phone;
  final String? otpChannel;
  final String? email;
  final String? otp;
  final String? password;

  ResetPasswordModel({
    this.phone,
    this.otpChannel,
    this.email,
    this.otp,
    this.password,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      phone: json['phone'] ?? '',
      otpChannel: json['otpChannel'] ?? '',
      otp: json['otp'] ?? '',
      password: json['password'] ?? '',
      email: json['email'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      if (phone != null) 'phone': phone,
      if (otpChannel != null) 'otpChannel': otpChannel,
      if (email != null) 'email': email,
      if (otp != null) 'otp': otp,
      if (password != null) 'password': password,
    };
  }
}
