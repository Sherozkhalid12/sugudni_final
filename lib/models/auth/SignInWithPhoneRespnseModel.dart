class SignInWithPhoneResponseModel {
  final bool success;
  final String message;

  SignInWithPhoneResponseModel({
    required this.success,
    required this.message,
  });

  factory SignInWithPhoneResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInWithPhoneResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
