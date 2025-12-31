import 'package:sugudeni/models/products/SimpleProductModel.dart';

class GetAllWishlistResponseModel {
  final String message;
  final List<Product> getAllUserWishList;

  GetAllWishlistResponseModel({
    required this.message,
    required this.getAllUserWishList,
  });

  GetAllWishlistResponseModel copyWith({
    String? message,
    List<Product>? getAllUserWishList,
  }) {
    return GetAllWishlistResponseModel(
      message: message ?? this.message,
      getAllUserWishList: getAllUserWishList ?? this.getAllUserWishList,
    );
  }

  factory GetAllWishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllWishlistResponseModel(
      message: json['message'] ?? '',
      getAllUserWishList: json['getAllUserWishList'] != null
          ? List<Product>.from(
          json['getAllUserWishList'].map((x) => Product.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'getAllUserWishList': getAllUserWishList.map((x) => x.toJson()).toList(),
    };
  }
}

// class WishlistItem {
//   final String id;
//   final String sellerId;
//   final String title;
//   final String imgCover;
//   final String weight;
//   final String color;
//   final String size;
//   final List<String> images;
//   final String description;
//   final int price;
//   final int priceAfterDiscount;
//   final int quantity;
//   final int sold;
//   final String category;
//   final String subcategory;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//   final int saleDiscount;
//   final bool featured;
//   final double ratingAvg;
//   final int ratingCount;
//   final List<dynamic> reviews;
//
//   WishlistItem({
//     required this.id,
//     required this.sellerId,
//     required this.title,
//     required this.imgCover,
//     required this.weight,
//     required this.color,
//     required this.size,
//     required this.images,
//     required this.description,
//     required this.price,
//     required this.priceAfterDiscount,
//     required this.quantity,
//     required this.sold,
//     required this.category,
//     required this.subcategory,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//     required this.saleDiscount,
//     required this.featured,
//     required this.ratingAvg,
//     required this.ratingCount,
//     required this.reviews,
//   });
//
//   WishlistItem copyWith({
//     String? id,
//     String? sellerId,
//     String? title,
//     String? imgCover,
//     String? weight,
//     String? color,
//     String? size,
//     List<String>? images,
//     String? description,
//     int? price,
//     int? priceAfterDiscount,
//     int? quantity,
//     int? sold,
//     String? category,
//     String? subcategory,
//     String? status,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? v,
//     int? saleDiscount,
//     bool? featured,
//     double? ratingAvg,
//     int? ratingCount,
//     List<dynamic>? reviews,
//   }) {
//     return WishlistItem(
//       id: id ?? this.id,
//       sellerId: sellerId ?? this.sellerId,
//       title: title ?? this.title,
//       imgCover: imgCover ?? this.imgCover,
//       weight: weight ?? this.weight,
//       color: color ?? this.color,
//       size: size ?? this.size,
//       images: images ?? this.images,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
//       quantity: quantity ?? this.quantity,
//       sold: sold ?? this.sold,
//       category: category ?? this.category,
//       subcategory: subcategory ?? this.subcategory,
//       status: status ?? this.status,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       v: v ?? this.v,
//       saleDiscount: saleDiscount ?? this.saleDiscount,
//       featured: featured ?? this.featured,
//       ratingAvg: ratingAvg ?? this.ratingAvg,
//       ratingCount: ratingCount ?? this.ratingCount,
//       reviews: reviews ?? this.reviews,
//     );
//   }
//
//   factory WishlistItem.fromJson(Map<String, dynamic> json) {
//     return WishlistItem(
//       id: json['_id'] ?? '',
//       sellerId: json['sellerid'] ?? '',
//       title: json['title'] ?? '',
//       imgCover: json['imgCover'] ?? '',
//       weight: json['weight'] ?? '',
//       color: json['color'] ?? '',
//       size: json['size'] ?? '',
//       images: json['images'] != null ? List<String>.from(json['images']) : [],
//       description: json['descripton'] ?? '', // Typo maintained
//       price: json['price'] ?? 0,
//       priceAfterDiscount: json['priceAfterDiscount'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       sold: json['sold'] ?? 0,
//       category: json['category'] ?? '',
//       subcategory: json['subcategory'] ?? '',
//       status: json['status'] ?? '',
//       createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
//       updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
//       v: json['__v'] ?? 0,
//       saleDiscount: json['saleDiscount'] ?? 0,
//       featured: json['featured'] ?? false,
//       ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
//       ratingCount: json['ratingCount'] ?? 0,
//       reviews: json['reviews'] != null ? List<dynamic>.from(json['reviews']) : [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'sellerid': sellerId,
//       'title': title,
//       'imgCover': imgCover,
//       'weight': weight,
//       'color': color,
//       'size': size,
//       'images': images,
//       'descripton': description, // Keep typo to match JSON
//       'price': price,
//       'priceAfterDiscount': priceAfterDiscount,
//       'quantity': quantity,
//       'sold': sold,
//       'category': category,
//       'subcategory': subcategory,
//       'status': status,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//       'saleDiscount': saleDiscount,
//       'featured': featured,
//       'ratingAvg': ratingAvg,
//       'ratingCount': ratingCount,
//       'reviews': reviews,
//     };
//   }
// }
