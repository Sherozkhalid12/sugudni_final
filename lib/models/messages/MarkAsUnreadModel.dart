class MarkAsUnreadModel {
  final String userid;
  final String otherUserid;

  MarkAsUnreadModel({required this.userid, required this.otherUserid});

  factory MarkAsUnreadModel.fromJson(Map<String, dynamic> json) {
    return MarkAsUnreadModel(
      userid: json['userid'] as String,
      otherUserid: json['otherUserid'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'otherUserid': otherUserid,
    };
  }
}
