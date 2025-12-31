class SpecificOrderResponse {
  final String message;
  final Order order;

  SpecificOrderResponse({required this.message, required this.order});

  factory SpecificOrderResponse.fromJson(Map<String, dynamic> json) {
    return SpecificOrderResponse(
      message: json['message'],
      order: Order.fromJson(json['order']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'order': order.toJson(),
    };
  }
}

class Order {
  final String id;
  final String userId;
  final String paymentMethod;
  final bool isPaid;
  final bool isDelivered;
  final List<dynamic> cartItems;
  final int v;

  Order({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.isPaid,
    required this.isDelivered,
    required this.cartItems,
    required this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['userId'],
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      isDelivered: json['isDelivered'],
      cartItems: List<dynamic>.from(json['cartItems']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'isDelivered': isDelivered,
      'cartItems': cartItems,
      '__v': v,
    };
  }
}
