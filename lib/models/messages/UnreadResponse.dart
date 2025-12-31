class UnreadResponse {
  final String message;

  UnreadResponse({required this.message});

  factory UnreadResponse.fromJson(Map<String, dynamic> json) {
    return UnreadResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
