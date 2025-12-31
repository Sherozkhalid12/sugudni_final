class TwitterLoginModel {
  final String name;
  final String picUrl;
  final String twitterId;
  final String role;

  TwitterLoginModel({
    required this.name,
    required this.picUrl,
    required this.twitterId,
    required this.role,
  });

  factory TwitterLoginModel.fromJson(Map<String, dynamic> json) {
    return TwitterLoginModel(
      name: json['name'],
      picUrl: json['picUrl'],
      twitterId: json['twitterId'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "picUrl": picUrl,
      "twitterId": twitterId,
      "role": role,
    };
  }
}
