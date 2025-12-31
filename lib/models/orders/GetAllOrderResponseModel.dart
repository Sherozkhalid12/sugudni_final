import 'dart:convert';

import '../products/SimpleProductModel.dart';

class GetAllOrderResponse {
  final String message;
  final Order orders;

  GetAllOrderResponse({required this.message, required this.orders});

  factory GetAllOrderResponse.fromJson(Map<String, dynamic> json) {
    return GetAllOrderResponse(
      message: json['message'],
      orders: Order.fromJson(json['orders']),
    );
  }
}

class Order {
  final String id;
  final String userId;
  final List<CartItem> cartItem;
  final String paymentMethod;
  final bool isPaid;
  final List<Tracking> tracking;

  Order({
    required this.id,
    required this.userId,
    required this.cartItem,
    required this.paymentMethod,
    required this.isPaid,
    required this.tracking,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      userId: json['userId'],
      cartItem: (json['cartItem'] as List)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      tracking: (json['tracking'] as List)
          .map((item) => Tracking.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
  final String sellerId;
  final Product? product;
  final int quantity;
  final int price;
  final int totalProductDiscount;
  final String trackingId;
  final String status;
  final bool isDelivered;
  final String failureReason;
  final String id;

  CartItem({
    required this.sellerId,
    this.product,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.trackingId,
    required this.status,
    required this.isDelivered,
    required this.failureReason,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      sellerId: json['sellerId'],
      product:
      json['productId'] != null ? Product.fromJson(json['productId']) : null,
      quantity: json['quantity'],
      price: json['price'] ?? 0,
      totalProductDiscount: json['totalProductDiscount'] ?? 0,
      trackingId: json['trackingId'] ?? '',
      status: json['status'],
      isDelivered: json['isDelivered'],
      failureReason: json['failureReason'] ?? '',
      id: json['_id'],
    );
  }
}


class Tracking {
  final String sellerId;
  final String trackingId;
  final String? deliveredAt;
  final String status;
  final bool isDelivered;
  final String failureReason;
  final String id;

  Tracking({
    required this.sellerId,
    required this.trackingId,
    this.deliveredAt,
    required this.status,
    required this.isDelivered,
    required this.failureReason,
    required this.id,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      sellerId: json['sellerId'],
      trackingId: json['trackingId'],
      deliveredAt: json['deliveredAt'],
      status: json['status'],
      isDelivered: json['isDelivered'],
      failureReason: json['failureReason'],
      id: json['_id'],
    );
  }
}
