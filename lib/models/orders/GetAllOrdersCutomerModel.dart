import '../products/SimpleProductModel.dart';

class GetCustomerAllOrderResponseModel {
  final String message;
  final List<Order> orders;

  GetCustomerAllOrderResponseModel({
    required this.message,
    required this.orders,
  });

  factory GetCustomerAllOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerAllOrderResponseModel(
      message: json['message'],
      orders: (json['orders'] as List).map((e) => Order.fromJson(e)).toList(),
    );
  }
}

// class Order {
//   final String id;
//   final String userId;
//   final List<CartItem> cartItem;
//   final String paymentMethod;
//   final bool isPaid;
//
//   Order({
//     required this.id,
//     required this.userId,
//     required this.cartItem,
//     required this.paymentMethod,
//     required this.isPaid,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['_id'],
//       userId: json['userId'],
//       cartItem: (json['cartItem'] as List).map((e) => CartItem.fromJson(e)).toList(),
//       paymentMethod: json['paymentMethod'],
//       isPaid: json['isPaid'],
//     );
//   }
// }
class Order {
  final String id;
  final String userId;
  final String paymentMethod;
  final bool isPaid;
  final String status;
  final double totalPrice;
  final double totalPriceAfterDiscount;
  final int itemsCount;
  final List<CartItem> cartItem;

  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.paymentMethod,
    required this.isPaid,
    required this.status,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.itemsCount,
    required this.createdAt,
    required this.updatedAt,required this.cartItem,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      isPaid: json['isPaid'] ?? false,
      status: json['status'] ?? '',
      cartItem: (json['cartItem'] as List).map((e) => CartItem.fromJson(e)).toList(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalPriceAfterDiscount: (json['totalPriceAfterDiscount'] ?? 0).toDouble(),
      itemsCount: json['itemsCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'paymentMethod': paymentMethod,
      'isPaid': isPaid,
      'status': status,
      'totalPrice': totalPrice,
      'totalPriceAfterDiscount': totalPriceAfterDiscount,
      'itemsCount': itemsCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

// class CartItem {
//   final Product productId;
//   final int quantity;
//   final double price;
//   final double totalProductDiscount;
//   final String trackingId;
//   final String status;
//   final bool isDelivered;
//   final String failureReason;
//
//   CartItem({
//     required this.productId,
//     required this.quantity,
//     required this.price,
//     required this.totalProductDiscount,
//     required this.trackingId,
//     required this.status,
//     required this.isDelivered,
//     required this.failureReason,
//   });
//
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       productId: Product.fromJson(json['productId']),
//       quantity: json['quantity'],
//       price: (json['price'] as num).toDouble(),
//       totalProductDiscount: (json['totalProductDiscount'] as num).toDouble(),
//       trackingId: json['trackingId'] ?? '',
//       status: json['status'],
//       isDelivered: json['isDelivered'],
//       failureReason: json['failureReason'] ?? '',
//     );
//   }
// }
class CartItem {
  final String sellerId;
  final Product productId;
  final int quantity;
  final double price;
  final double totalProductDiscount;
  final double priceAfterDiscount;
  final String trackingId;
  final String status;
  final bool isDelivered;
  final String failureReason;
  final DateTime? deliveredAt;
  final DateTime? estimatedArrival;
  final String currentLocation;
  final String currentLocationLatLong;
  final String id;

  CartItem({
    required this.sellerId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.priceAfterDiscount,
    required this.trackingId,
    required this.status,
    required this.isDelivered,
    required this.failureReason,
    this.deliveredAt,
    this.estimatedArrival,
    required this.currentLocation,
    required this.currentLocationLatLong,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      sellerId: json['sellerId'] ?? '',
      productId: Product.fromJson(json['productId']),
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      totalProductDiscount: (json['totalProductDiscount'] ?? 0).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] ?? 0).toDouble(),
      trackingId: json['trackingId'] ?? '',
      status: json['status'] ?? '',
      isDelivered: json['isDelivered'] ?? false,
      failureReason: json['failureReason'] ?? '',
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      estimatedArrival: json['estimatedArrival'] != null ? DateTime.parse(json['estimatedArrival']) : null,
      currentLocation: json['currentLocation'] ?? '',
      currentLocationLatLong: json['currentLocationLatLong'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'productId': productId.toJson(),
      'quantity': quantity,
      'price': price,
      'totalProductDiscount': totalProductDiscount,
      'priceAfterDiscount': priceAfterDiscount,
      'trackingId': trackingId,
      'status': status,
      'isDelivered': isDelivered,
      'failureReason': failureReason,
      'deliveredAt': deliveredAt?.toIso8601String(),
      'estimatedArrival': estimatedArrival?.toIso8601String(),
      'currentLocation': currentLocation,
      'currentLocationLatLong': currentLocationLatLong,
      '_id': id,
    };
  }
}

