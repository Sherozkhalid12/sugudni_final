import 'SimpleProductModel.dart';

class DeleteProductResponse {
  final String message;

  DeleteProductResponse({
    required this.message,
  });

  factory DeleteProductResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProductResponse(
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

// class Product {
//   final String id;
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
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int v;
//
//   Product({
//     required this.id,
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
//       weight: json['weight'] ?? '',
//       color: json['color'] ?? '',
//       size: json['size'] ?? '',
//       images: List<String>.from(json['images'] ?? []),
//       description: json['descripton'] ?? '', // Fixed typo
//       price: json['price'] ?? 0,
//       priceAfterDiscount: json['priceAfterDiscount'] ?? 0,
//       quantity: json['quantity'] ?? 0,
//       sold: json['sold'] ?? 0,
//       category: json['category'] ?? '',
//       subcategory: json['subcategory'] ?? '',
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
//       'weight': weight,
//       'color': color,
//       'size': size,
//       'images': images,
//       'descripton': description, // Keeping the same typo as in JSON
//       'price': price,
//       'priceAfterDiscount': priceAfterDiscount,
//       'quantity': quantity,
//       'sold': sold,
//       'category': category,
//       'subcategory': subcategory,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//       '__v': v,
//     };
//   }
// }
