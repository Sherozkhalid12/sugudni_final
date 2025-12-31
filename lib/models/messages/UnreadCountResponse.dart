class UnreadCountResponse {
  final int count;

  UnreadCountResponse({required this.count});

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
    };
  }
}
