class UpdateCartQuantityResponse {
  final String message;
  final Cart cart;

  UpdateCartQuantityResponse({
    required this.message,
    required this.cart,
  });

  factory UpdateCartQuantityResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartQuantityResponse(
      message: json['message'] as String,
      cart: Cart.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'cart': cart.toJson(),
    };
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> cartItem;
  final double totalPrice;
  final double totalPriceAfterDiscount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Cart({
    required this.id,
    required this.userId,
    required this.cartItem,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      cartItem: (json['cartItem'] as List)
          .map((e) => CartItem.fromJson(e))
          .toList(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalPriceAfterDiscount: (json['totalPriceAfterDiscount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'cartItem': cartItem.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'totalPriceAfterDiscount': totalPriceAfterDiscount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
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
