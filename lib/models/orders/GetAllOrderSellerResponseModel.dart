import 'dart:convert';

import 'package:sugudeni/models/user/common-user-model.dart';

import '../address-model/AddressesModel.dart';
import '../products/SimpleProductModel.dart';

class GetAllOrderSellerResponse {
  final String message;
  final int count;
  final int pagenumber;
  final List<Order>? orders;

  GetAllOrderSellerResponse({required this.message, this.orders,required this.count,required this.pagenumber});

  factory GetAllOrderSellerResponse.fromJson(Map<String, dynamic> json) {
    return GetAllOrderSellerResponse(
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      pagenumber: json['PAGE_NUMBER'] ?? 1,
      orders: json['orders'] != null
          ? List<Order>.from(json['orders'].map((x) => Order.fromJson(x)))
          : null,
    );
  }
}

// class Order {
//   final String id;
//   final String userId;
//   final List<CartItem> cartItem;
//   final String paymentMethod;
//   final bool isPaid;
//   final Tracking tracking;
//
//   Order({
//     required this.id,
//     required this.userId,
//     required this.cartItem,
//     required this.paymentMethod,
//     required this.isPaid,
//     required this.tracking,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       id: json['_id'] ?? '',
//       userId: json['userId'] ?? '',
//       cartItem: json['cartItem'] != null
//           ? List<CartItem>.from(json['cartItem'].map((x) => CartItem.fromJson(x)))
//           : [],
//       paymentMethod: json['paymentMethod'] ?? '',
//       isPaid: json['isPaid'] ?? false,
//       tracking: Tracking.fromJson(json['tracking'] ?? {}),
//     );
//   }
// }
class Order {
  final String id;
  final String orderId;
  final CommonUserModel? userId;
  final String sellerId;
  final String? driverId;
  final bool driverPicked;
  final List<CartItem> cartItem;
  final String trackingStatus;
  final AddressesModel shippingAddress;
  final String trackingId;
  final DateTime? deliveredAt;
  final bool isDelivered;
  final String failureReason;
  final DateTime? estimatedArrival;
  final String currentLocation;
  final String currentLocationLatLong;
  final double amount;
  final String paymentMethod;
  final bool isPaid;
  final double totalPrice;
  final double totalPriceAfterDiscount;
  final int itemsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.orderId,
    this.userId,
    required this.sellerId,
    this.driverId,
    required this.driverPicked,
    required this.cartItem,
    required this.trackingStatus,
    required this.shippingAddress,
    required this.trackingId,
    this.deliveredAt,
    required this.isDelivered,
    required this.failureReason,
    this.estimatedArrival,
    required this.currentLocation,
    required this.currentLocationLatLong,
    required this.amount,
    required this.paymentMethod,
    required this.isPaid,
    required this.totalPrice,
    required this.totalPriceAfterDiscount,
    required this.itemsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      orderId: json['orderId'] ?? '',
      userId: json['userId'] != null ? CommonUserModel.fromJson(json['userId']) : null, // Handle optional violation
      sellerId: json['sellerId'] ?? '',
      driverId: json['driverId'],
      driverPicked: json['driverPicked'] ?? false,
      cartItem: json['cartItem'] != null
          ? List<CartItem>.from(json['cartItem'].map((x) => CartItem.fromJson(x)))
          : [],
      trackingStatus: json['trackingStatus'] ?? '',
      shippingAddress: AddressesModel.fromJson(json['shippingAddress'] ?? {}),
      trackingId: json['trackingId'] ?? '',
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt']) : null,
      isDelivered: json['isDelivered'] ?? false,
      failureReason: json['failureReason'] ?? '',
      estimatedArrival: json['estimatedArrival'] != null ? DateTime.parse(json['estimatedArrival']) : null,
      currentLocation: json['currentLocation'] ?? '',
      currentLocationLatLong: json['currentLocationLatLong'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? '',
      isPaid: json['isPaid'] ?? false,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      totalPriceAfterDiscount: (json['totalPriceAfterDiscount'] ?? 0).toDouble(),
      itemsCount: json['itemsCount'] ?? 0,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     '_id': id,
  //     'orderId': orderId,
  //     'userId': userId,
  //     'sellerId': sellerId,
  //     'driverId': driverId,
  //     'driverPicked': driverPicked,
  //     'cartItem': cartItem.map((x) => x.toJson()).toList(),
  //     'trackingStatus': trackingStatus,
  //     'shippingAddress': shippingAddress.toJson(),
  //     'trackingId': trackingId,
  //     'deliveredAt': deliveredAt?.toIso8601String(),
  //     'isDelivered': isDelivered,
  //     'failureReason': failureReason,
  //     'estimatedArrival': estimatedArrival?.toIso8601String(),
  //     'currentLocation': currentLocation,
  //     'currentLocationLatLong': currentLocationLatLong,
  //     'amount': amount,
  //     'paymentMethod': paymentMethod,
  //     'isPaid': isPaid,
  //     'totalPrice': totalPrice,
  //     'totalPriceAfterDiscount': totalPriceAfterDiscount,
  //     'itemsCount': itemsCount,
  //     'createdAt': createdAt.toIso8601String(),
  //     'updatedAt': updatedAt.toIso8601String(),
  //   };
  // }
}

// class CartItem {
//   final String sellerId;
//   final Product? product;
//   final int quantity;
//   final double price;
//   final double totalProductDiscount;
//   final String trackingId;
//   final String deliveredAt;
//   final String status;
//   final bool isDelivered;
//   final String failureReason;
//   final String id;
//
//   CartItem({
//     required this.sellerId,
//     this.product,
//     required this.quantity,
//     required this.price,
//     required this.totalProductDiscount,
//     required this.trackingId,
//     required this.deliveredAt,
//     required this.status,
//     required this.isDelivered,
//     required this.failureReason,
//     required this.id,
//   });
//
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       sellerId: json['sellerId'] ?? '',
//       product: json['productId'] != null ? Product.fromJson(json['productId']) : null,
//       quantity: json['quantity'] ?? 0,
//       price: (json['price'] ?? 0).toDouble(),
//       totalProductDiscount: (json['totalProductDiscount'] ?? 0).toDouble(),
//       trackingId: json['trackingId'] ?? '',
//       deliveredAt: json['deliveredAt'] ?? 'N/a',
//       status: json['status'] ?? '',
//       isDelivered: json['isDelivered'] ?? false,
//       failureReason: json['failureReason'] ?? '',
//       id: json['_id'] ?? '',
//     );
//   }
// }
class CartItem {
  final String sellerId;
  final Product? product;
  final int quantity;
  final double price;
  final double totalProductDiscount;
  final double priceAfterDiscount;
  final String id;

  CartItem({
    required this.sellerId,
    this.product,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.priceAfterDiscount,
    required this.id,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      sellerId: json['productId']?['sellerid']?['_id'] ?? '',
      product: json['productId'] != null ? Product.fromJson(json['productId']) : null,
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      totalProductDiscount: (json['totalProductDiscount'] ?? 0).toDouble(),
      priceAfterDiscount: (json['priceAfterDiscount'] ?? 0).toDouble(),
      id: json['_id'] ?? '',
    );
  }
}

class Tracking {
  final String trackingId;
  final String deliveredAt;
  final String status;
  final bool isDelivered;
  final String failureReason;

  Tracking({
    required this.trackingId,
    required this.deliveredAt,
    required this.status,
    required this.isDelivered,
    required this.failureReason,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      trackingId: json['trackingId'] ?? '',
      deliveredAt: json['deliveredAt'] ?? '',
      status: json['status'] ?? '',
      isDelivered: json['isDelivered'] ?? false,
      failureReason: json['failureReason'] ?? '',
    );
  }
}
