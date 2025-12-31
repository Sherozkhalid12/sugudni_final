class ProductStatusChangeModel {
  final String productId;
  final String status;

  ProductStatusChangeModel({
    required this.productId,
    required this.status,
  });

  factory ProductStatusChangeModel.fromJson(Map<String, dynamic> json) {
    return ProductStatusChangeModel(
      productId: json['productid'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productid': productId,
      'status': status,
    };
  }
}
