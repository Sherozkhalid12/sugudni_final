class CheckOutResponse {
  final String message;
  final Session sessions;

  CheckOutResponse({
    required this.message,
    required this.sessions,
  });

  factory CheckOutResponse.fromJson(Map<String, dynamic> json) {
    return CheckOutResponse(
      message: json['message'] ?? '',
      sessions: Session.fromJson(json['sessions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'sessions': sessions.toJson(),
    };
  }
}

class Session {
  final String id;
  final String url;

  Session({
    required this.id,
    required this.url,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
