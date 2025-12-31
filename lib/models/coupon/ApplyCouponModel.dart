class Coupon {
  final String code;
  final String? productId;

  Coupon({
    required this.code,
    this.productId,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] as String,
      productId: (json['productId'] as String?)?.isEmpty ?? true
          ? ''
          : json['productId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      if (productId != null && productId!.isNotEmpty) 'productId': productId,
    };
  }
}
