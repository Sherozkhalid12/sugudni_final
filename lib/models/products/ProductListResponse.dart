import 'SimpleProductModel.dart';

class ProductListResponse {
  final int page;
  final String message;
  final List<Product> getAllProducts;

  ProductListResponse({
    required this.page,
    required this.message,
    required this.getAllProducts,
  });

  factory ProductListResponse.fromJson(Map<String, dynamic> json) {
    return ProductListResponse(
      page: json['page'] ?? 0,
      message: json['message'] ?? '',
      getAllProducts: (json['getAllProducts'] as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'message': message,
      'getAllProducts': getAllProducts.map((e) => e.toJson()).toList(),
    };
  }
}

// class Product {
//   final double ratingAvg;
//   final int ratingCount;
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
//   final List<dynamic> reviews;
//
//   Product({
//     required this.ratingAvg,
//     required this.ratingCount,
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
//     required this.reviews,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       ratingAvg: (json['ratingAvg'] as num).toDouble(),
//       ratingCount: json['ratingCount'],
//       id: json['_id'],
//       sellerId: json['sellerid'],
//       title: json['title'],
//       imgCover: json['imgCover'],
//       weight: json['weight'],
//       color: json['color'],
//       size: json['size'],
//       images: List<String>.from(json['images']),
//       description: json['descripton'], // Note: "descripton" has a typo in JSON
//       price: json['price'],
//       priceAfterDiscount: json['priceAfterDiscount'],
//       quantity: json['quantity'],
//       sold: json['sold'],
//       category: json['category'],
//       subcategory: json['subcategory'],
//       status: json['status'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       v: json['__v'],
//       reviews: List<dynamic>.from(json['reviews']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'ratingAvg': ratingAvg,
//       'ratingCount': ratingCount,
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
//       'reviews': reviews,
//     };
//   }
// }
