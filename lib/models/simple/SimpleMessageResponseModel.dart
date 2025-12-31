class SimpleMessageResponseModel {
  final String message;

  SimpleMessageResponseModel({required this.message});

  factory SimpleMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SimpleMessageResponseModel(
      message: json['message'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
