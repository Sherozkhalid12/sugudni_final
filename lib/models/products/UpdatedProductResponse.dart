import 'package:sugudeni/models/products/SimpleProductModel.dart';

class UpdatedProductResponse {
  final String message;

  UpdatedProductResponse({
    required this.message,
  });

  factory UpdatedProductResponse.fromJson(Map<String, dynamic> json) {
    return UpdatedProductResponse(
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}

// class UpdatedProduct {
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
//   final String status;
//
//   UpdatedProduct({
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
//     required this.status,
//   });
//
//   factory UpdatedProduct.fromJson(Map<String, dynamic> json) {
//     return UpdatedProduct(
//       id: json['_id'] as String,
//       title: json['title'] as String,
//       imgCover: json['imgCover'] as String,
//       weight: json['weight'] as String,
//       color: json['color'] as String,
//       size: json['size'] as String,
//       images: List<String>.from(json['images']),
//       description: json['descripton'] as String, // Keep typo if needed
//       price: json['price'] as int,
//       priceAfterDiscount: json['priceAfterDiscount'] as int,
//       quantity: json['quantity'] as int,
//       sold: json['sold'] as int,
//       category: json['category'] as String,
//       subcategory: json['subcategory'] as String,
//       createdAt: DateTime.parse(json['createdAt']), // Parsing DateTime
//       updatedAt: DateTime.parse(json['updatedAt']), // Parsing DateTime
//       v: json['__v'] as int,
//       status: json['status'] as String,
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
//       'descripton': description, // Ensure typo consistency
//       'price': price,
//       'priceAfterDiscount': priceAfterDiscount,
//       'quantity': quantity,
//       'sold': sold,
//       'category': category,
//       'subcategory': subcategory,
//       'createdAt': createdAt.toIso8601String(), // Converting back to string
//       'updatedAt': updatedAt.toIso8601String(), // Converting back to string
//       '__v': v,
//       'status': status,
//     };
//   }
// }
