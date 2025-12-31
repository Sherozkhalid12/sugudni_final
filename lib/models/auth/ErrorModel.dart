/// error : "Email not found"

class ErrorModel {
  ErrorModel({
      String? error,}){
    _error = error;
}

  ErrorModel.fromJson(dynamic json) {
    _error = json['error'];
  }
  String? _error;
ErrorModel copyWith({  String? error,
}) => ErrorModel(  error: error ?? _error,
);
  String? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    return map;
  }

}