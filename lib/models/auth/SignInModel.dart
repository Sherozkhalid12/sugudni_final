/// email : "test1@gmail.com"
/// password : "123456"

class SignInModel {
  SignInModel({
      String? email, 
      String? password,}){
    _email = email;
    _password = password;
}

  SignInModel.fromJson(dynamic json) {
    _email = json['email'];
    _password = json['password'];
  }
  String? _email;
  String? _password;
SignInModel copyWith({  String? email,
  String? password,
}) => SignInModel(  email: email ?? _email,
  password: password ?? _password,
);
  String? get email => _email;
  String? get password => _password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['password'] = _password;
    return map;
  }

}