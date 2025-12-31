import 'SimpleCartItemModel.dart';

class GetCartResponse {
  final String message;
  final Cart cart;

  GetCartResponse({
    required this.message,
    required this.cart,
  });

  factory GetCartResponse.fromJson(Map<String, dynamic> json) {
    return GetCartResponse(
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
  final List<CartItemModel> cartItem;
  final double totalPrice;
  final double totalPriceAfterDiscount;
  final double discount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Cart({
    required this.id,
    required this.userId,
    required this.cartItem,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse double and handle NaN
    double safeDouble(dynamic value, {double defaultValue = 0.0}) {
      if (value == null) return defaultValue;
      final parsed = (value as num).toDouble();
      return parsed.isNaN || parsed.isInfinite ? defaultValue : parsed;
    }
    
    return Cart(
      id: json['_id'] as String,
      userId: json['userId'] as String,
      cartItem: (json['cartItem'] as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      totalPrice: safeDouble(json['totalPrice']),
      totalPriceAfterDiscount: safeDouble(json['totalPriceAfterDiscount']),
      discount: safeDouble(json['discount']), // Handle NaN gracefully
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
      'discount': discount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}


