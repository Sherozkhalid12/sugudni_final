/// message : "Sign Up Successfull"
/// _id : "67bd96edb021a551f943db3d"
/// token : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InRlc3R1c2VyMi5lbWFpbCIsIm5hbWUiOiJ0ZXN0dXNlcjEiLCJpZCI6IjY3YmQ5NmVkYjAyMWE1NTFmOTQzZGIzZCIsInJvbGUiOiJzZWxsZXIiLCJpYXQiOjE3NDA0ODA4MzZ9.foWoH9Kcvqecr8FxDTGyQQ9FHp8tKjt7xQeQjtP_SnA"

class SuccessfulVerifyOtpResponse {
  SuccessfulVerifyOtpResponse({
      String? message, 
      String? id, 
      String? token,}){
    _message = message;
    _id = id;
    _token = token;
}

  SuccessfulVerifyOtpResponse.fromJson(dynamic json) {
    _message = json['message'];
    _id = json['_id'];
    _token = json['token'];
  }
  String? _message;
  String? _id;
  String? _token;
SuccessfulVerifyOtpResponse copyWith({  String? message,
  String? id,
  String? token,
}) => SuccessfulVerifyOtpResponse(  message: message ?? _message,
  id: id ?? _id,
  token: token ?? _token,
);
  String? get message => _message;
  String? get id => _id;
  String? get token => _token;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['message'] = _message;
    map['_id'] = _id;
    map['token'] = _token;
    return map;
  }

}