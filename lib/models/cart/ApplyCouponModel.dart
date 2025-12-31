class ApplyCouponModel {
  final String code;

  ApplyCouponModel({required this.code});

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) {
    return ApplyCouponModel(
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
    };
  }
}
