/// success : true
/// message : "verification otp sent to your email"

class SignUpSuccess {
  SignUpSuccess({
      bool? success, 
      String? message,}){
    _success = success;
    _message = message;
}

  SignUpSuccess.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
  }
  bool? _success;
  String? _message;
SignUpSuccess copyWith({  bool? success,
  String? message,
}) => SignUpSuccess(  success: success ?? _success,
  message: message ?? _message,
);
  bool? get success => _success;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    return map;
  }

}