class CashOrderResponseModel {
  final String message;
  final Order? order;

  CashOrderResponseModel({required this.message, this.order});

  factory CashOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CashOrderResponseModel(
      message: json['message'] ?? 'No message',
      order: json.containsKey('order') ? Order.fromJson(json['order']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'order': order?.toJson(),
    };
  }
}

class Order {
  final String userId;
  final String paymentMethod;
  final bool isPaid;
  final bool isDelivered;
  final String id;
  final List<dynamic> cartItems;
  final int v;

  Order({
    required this.userId,
    required this.paymentMethod,
    required this.isPaid,
    required this.isDelivered,
    required this.id,
    required this.cartItems,
    required this.v,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      userId: json['userId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Unknown',
      isPaid: json['isPaid'] ?? false,
      isDelivered: json['isDelivered'] ?? false,
      id: json['_id'] ?? '',
      cartItems: json['cartItems'] != null ? List<dynamic>.from(json['cartItems']) : [],
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'isDelivered': isDelivered,
      '_id': id,
      'cartItems': cartItems,
      '__v': v,
    };
  }
}
