class AddToCartModel {
  final String productId;
  final String sellerId;
  final int quantity;
  final double price;
  final double totalProductDiscount;

  AddToCartModel({
    required this.sellerId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(
      sellerId: json['sellerId'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      totalProductDiscount: (json['totalProductDiscount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'totalProductDiscount': totalProductDiscount,
    };
  }
}
