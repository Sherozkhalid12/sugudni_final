class AddToCartResponse {
  final String message;
  final CartResult result;

  AddToCartResponse({
    required this.message,
    required this.result,
  });

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) {
    return AddToCartResponse(
      message: json['message'] as String,
      result: CartResult.fromJson(json['result']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'result': result.toJson(),
    };
  }
}

class CartResult {
  final String userId;
  final List<CartItem> cartItem;
  final String id;
  final double totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartResult({
    required this.userId,
    required this.cartItem,
    required this.id,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartResult.fromJson(Map<String, dynamic> json) {
    return CartResult(
      userId: json['userId'] as String,
      cartItem: (json['cartItem'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      id: json['_id'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'cartItem': cartItem.map((item) => item.toJson()).toList(),
      '_id': id,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CartItem {
  final String productId;
  final int quantity;
  final double price;
  final double totalProductDiscount;
  final String id;

  CartItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
      totalProductDiscount: (json['totalProductDiscount'] as num).toDouble(),
      id: json['_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'totalProductDiscount': totalProductDiscount,
      '_id': id,
    };
  }
}
