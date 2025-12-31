import 'SimpleProductModel.dart';

class SpecificProductResponse {
  final String message;
  final Product? getSpecificProduct;

  SpecificProductResponse({
    required this.message,
    this.getSpecificProduct,
  });

  factory SpecificProductResponse.fromJson(Map<String, dynamic> json) {
    return SpecificProductResponse(
      message: json['message'] ?? '',
      getSpecificProduct: json['product'] != null
          ? Product.fromJson(json['product'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'getSpecificProduct': getSpecificProduct?.toJson(),
    };
  }
}

// class Product {
//   final String id;
//   final String title;
//   final String imgCover;
//   final List<String> images;
//   final String description;
//   final int price;
//   final int priceAfterDiscount;
//   final int quantity;
//   final int sold;
//   final String category;
//   final String subcategory;
//   final String brand;
//   final double ratingAvg;
//   final int ratingCount;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//
//   Product({
//     required this.id,
//     required this.title,
//     required this.imgCover,
//     required this.images,
//     required this.description,
//     required this.price,
//     required this.priceAfterDiscount,
//     required this.quantity,
//     required this.sold,
//     required this.category,
//     required this.subcategory,
//     required this.brand,
//     required this.ratingAvg,
//     required this.ratingCount,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.v,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['_id'] ?? '',
//       title: json['title'] ?? '',
//       imgCover: json['imgCover'] ?? '',
//       images: List<String>.from(json['images'] ?? []),
//       description: json['descripton'] ?? '',
//       price: json['price'] ?? 0,
//       priceAfterDiscount: json['priceAfterDiscount'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       sold: json['sold'] ?? 0,
//       category: json['category'] ?? '',
//       subcategory: json['subcategory'] ?? '',
//       brand: json['brand'] ?? '',
//       ratingAvg: (json['ratingAvg'] ?? 0).toDouble(),
//       ratingCount: json['ratingCount'] ?? 0,
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//       v: json['__v'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'title': title,
//       'imgCover': imgCover,
//       'images': images,
//       'descripton': description,
//       'price': price,
//       'priceAfterDiscount': priceAfterDiscount,
//       'quantity': quantity,
//       'sold': sold,
//       'category': category,
//       'subcategory': subcategory,
//       'brand': brand,
//       'ratingAvg': ratingAvg,
//       'ratingCount': ratingCount,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//     };
//   }
// }
