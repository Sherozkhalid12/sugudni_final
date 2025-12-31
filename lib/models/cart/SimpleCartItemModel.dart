import '../products/SimpleProductModel.dart';

class CartItemModel {
  final Product productId;
  final int quantity;
  final double price;
  final double totalProductDiscount;
  final double priceAfterDiscount;
  final String id;

  CartItemModel({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.priceAfterDiscount,
    required this.id,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      productId: Product.fromJson(json['productId']),
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      totalProductDiscount: (json['totalProductDiscount'] as num).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] as num).toDouble(),
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId.toJson(),
      'quantity': quantity,
      'price': price,
      'totalProductDiscount': totalProductDiscount,
      'priceAfterDiscount': priceAfterDiscount,
      '_id': id,
    };
  }
}
