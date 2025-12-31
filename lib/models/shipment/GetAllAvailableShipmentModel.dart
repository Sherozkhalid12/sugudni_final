import 'package:sugudeni/models/address-model/AddressesModel.dart';
import 'package:sugudeni/models/products/SimpleProductModel.dart';
import 'package:sugudeni/models/user/CustomerModel.dart';

import '../orders/GetAllOrderResponseModel.dart';

class GetAllShipmentResponse {
  final String message;
  final int count;
  final int pageNumber;
  final List<ShipmentModel> shipments;

  GetAllShipmentResponse({
    required this.message,
    required this.count,
    required this.pageNumber,
    required this.shipments,
  });

  factory GetAllShipmentResponse.fromJson(Map<String, dynamic> json) {
    return GetAllShipmentResponse(
      message: json['message'],
      count: json['count'],
      pageNumber: json['PAGE_NUMBER'],
      shipments: (json['shipments'] as List)
          .map((e) => ShipmentModel.fromJson(e))
          .toList(),
    );
  }
}

class ShipmentModel {
  final String id;
  final String orderId;
 // final CustomerModel user;
  final String sellerId;
  final String? driverId;
  final bool driverPicked;
  final List<CartModelOfAvailableShipping> cartItems;
  final String trackingStatus;
  final AddressesModel? shippingAddress;
  final String trackingId;
  final bool isDelivered;
  final String failureReason;
  final String? estimatedArrival;
  final String currentLocation;
  final String currentLocationLatLong;
  final double amount;
  final String paymentMethod;
  final bool isPaid;
  final double totalPrice;
  final double totalPriceAfterDiscount;
  final int itemsCount;
  final String createdAt;
  final String updatedAt;
  final AddressesModel pickupAddress;

  ShipmentModel({
    required this.id,
    required this.orderId,
   // required this.user,
    required this.sellerId,
     this.driverId,
    required this.driverPicked,
    required this.cartItems,
    required this.trackingStatus,
     this.shippingAddress,
    required this.trackingId,
    required this.isDelivered,
    required this.failureReason,
    required this.estimatedArrival,

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
    required this.pickupAddress,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['_id'],
      orderId: json['orderId'],
    //  user: CustomerModel.fromJson(json['userId']),
      sellerId: json['sellerId'],
      driverId: json['driverId'] ?? '',
      driverPicked: json['driverPicked'],
      cartItems: (json['cartItem'] as List)
          .map((e) => CartModelOfAvailableShipping.fromJson(e))
          .toList(),
      trackingStatus: json['trackingStatus'],
      shippingAddress: json['shippingAddress'] != null
          ? AddressesModel.fromJson(json['shippingAddress'])
          : null, // Handle missing key
    //  shippingAddress: AddressesModel.fromJson(json['shippingAddress']),
      trackingId: json['trackingId'],
      isDelivered: json['isDelivered'],
      failureReason: json['failureReason'],
      estimatedArrival: json['estimatedArrival'] ??'',
      currentLocation: json['currentLocation'],
      currentLocationLatLong: json['currentLocationLatLong'],
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'],
      isPaid: json['isPaid'],
      totalPrice: (json['totalPrice'] as num).toDouble(),
      totalPriceAfterDiscount:
      (json['totalPriceAfterDiscount'] as num).toDouble(),
      itemsCount: json['itemsCount'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      pickupAddress: AddressesModel.fromJson(json['pickupAddress']),
    );
  }

}

class CartModelOfAvailableShipping {
  final String id;
  final Product product;
  final int quantity;
  final double price;
  final double totalProductDiscount;
  final double priceAfterDiscount;

  CartModelOfAvailableShipping({
    required this.id,
    required this.product,
    required this.quantity,
    required this.price,
    required this.totalProductDiscount,
    required this.priceAfterDiscount,
  });

  factory CartModelOfAvailableShipping.fromJson(Map<String, dynamic> json) {
    return CartModelOfAvailableShipping(
      id: json['_id'] ?? '',
      product: Product.fromJson(json['productId'] ?? {}), // Use ProductModel
      quantity: json['quantity'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      totalProductDiscount: (json['totalProductDiscount'] as num?)?.toDouble() ?? 0.0,
      priceAfterDiscount: (json['priceAfterDiscount'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productId': product.toJson(), // Convert ProductModel back to JSON
      'quantity': quantity,
      'price': price,
      'totalProductDiscount': totalProductDiscount,
      'priceAfterDiscount': priceAfterDiscount,
    };
  }
}
