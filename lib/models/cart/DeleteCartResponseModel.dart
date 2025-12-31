class DeleteCartResponseModel {
  final String message;
  // final Cart cart;

  DeleteCartResponseModel({
    required this.message,
 //   required this.cart
  });

  factory DeleteCartResponseModel.fromJson(Map<String, dynamic> json) {
    return DeleteCartResponseModel(
      message: json['message'],
     // cart: Cart.fromJson(json['cart']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
   //   'cart': cart.toJson(),
    };
  }
}

class Cart {
  final String id;
  final String userId;
  final List<CartItem> cartItem;
  final int totalPrice;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Cart({
    required this.id,
    required this.userId,
    required this.cartItem,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      id: json['_id'],
      userId: json['userId'],
      cartItem: (json['cartItem'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      totalPrice: json['totalPrice'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'cartItem': cartItem.map((item) => item.toJson()).toList(),
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class CartItem {
  final String productId;
  final int quantity;
  final int price;
  final int totalProductDiscount;
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
      productId: json['productId'],
      quantity: json['quantity'],
      price: json['price'],
      totalProductDiscount: json['totalProductDiscount'],
      id: json['_id'],
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
