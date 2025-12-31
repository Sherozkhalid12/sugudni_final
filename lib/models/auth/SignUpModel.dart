/// name : "testuser1"
/// email : "testuser2.email"
/// password : "password"
/// role : "seller"

class SignUpModel {
  SignUpModel({
    String? name,
    String? email,
    String? phone,
    String? otpChannel,
    String? password,
    String? role,
  }) {
    _name = name;
    _email = email;
    _password = password;
    _phone = phone;
    _otpChannel = otpChannel;
    _role = role;
  }

  SignUpModel.fromJson(dynamic json) {
    _name = json['name'];
    _email = json['email'];
    _phone = json['phone'];
    _otpChannel = json['otpChannel'];
    _password = json['password'];
    _role = json['role'];
  }

  String? _name;
  String? _email;
  String? _phone;
  String? _otpChannel;
  String? _password;
  String? _role;

  SignUpModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? otpChannel,
    String? password,
    String? role,
  }) =>
      SignUpModel(
        name: name ?? _name,
        email: email ?? _email,
        phone: phone ?? _phone,
        otpChannel: otpChannel ?? _otpChannel,
        password: password ?? _password,
        role: role ?? _role,
      );

  String? get name => _name;
  String? get email => _email;
  String? get phone => _phone;
  String? get otpChannel => _otpChannel;
  String? get password => _password;
  String? get role => _role;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    if (_email != null) map['email'] = _email; // Include email only if not null
    if (_phone != null) map['phone'] = _phone; // Include phone only if not null
    map['otpChannel'] = _otpChannel; // Only for phone sign-up
    map['password'] = _password;
    map['role'] = _role;
    return map;
  }
}