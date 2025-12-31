/// email : "testuser1.email"
/// phone : "+33123456789"
/// otp : "1234"

class VerifySignUpOtpModel {
  VerifySignUpOtpModel({
    String? email,
    String? phone,
    String? otp,
  }) {
    _email = email;
    _phone = phone;
    _otp = otp;
  }

  VerifySignUpOtpModel.fromJson(dynamic json) {
    _email = json['email'];
    _phone = json['phone'];
    _otp = json['otp'];
  }

  String? _email;
  String? _phone;
  String? _otp;

  VerifySignUpOtpModel copyWith({
    String? email,
    String? phone,
    String? otp,
  }) => VerifySignUpOtpModel(
    email: email ?? _email,
    phone: phone ?? _phone,
    otp: otp ?? _otp,
  );

  String? get email => _email;
  String? get phone => _phone;
  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_email != null) {
      map['email'] = _email;
    }
    if (_phone != null) {
      map['phone'] = _phone;
    }
    map['otp'] = _otp;
    return map;
  }
}