class OrangeMoneyResponse {
  final String message;
  final Session sessions;

  OrangeMoneyResponse({
    required this.message,
    required this.sessions,
  });

  factory OrangeMoneyResponse.fromJson(Map<String, dynamic> json) {
    return OrangeMoneyResponse(
      message: json['message'] ?? '',
      sessions: Session.fromJson(json['session']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'session': sessions.toJson(),
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
      id: json['message'] ?? '',
      url: json['payment_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': id,
      'payment_url': url,
    };
  }
}
