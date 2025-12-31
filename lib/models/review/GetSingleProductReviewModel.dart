import '../products/SimpleProductModel.dart';

class GetReviewsOfSingleProduct {
  final int page;
  final String message;
  final List<Review> getAllReviews;

  GetReviewsOfSingleProduct({
    required this.page,
    required this.message,
    required this.getAllReviews,
  });

  factory GetReviewsOfSingleProduct.fromJson(Map<String, dynamic> json) {
    return GetReviewsOfSingleProduct(
      page: json['page'],
      message: json['message'],
      getAllReviews: (json['getAllReviews'] as List)
          .map((e) => Review.fromJson(e))
          .toList(),
    );
  }
}

class Review {
  final String id;
  final Seller sellerId;
  final String text;
  final Product productId;
  final User userId;
  final int rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Review({
    required this.id,
    required this.sellerId,
    required this.text,
    required this.productId,
    required this.userId,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['_id'],
      sellerId: Seller.fromJson(json['sellerId']),
      text: json['text'],
      productId: Product.fromJson(json['productId']),
      userId: User.fromJson(json['userId']),
      rate: json['rate'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class Seller {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String profilePic;

  Seller({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.profilePic,
  });

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      profilePic: json['profilePic'],
    );
  }
}

class User {
  final String name;

  User({required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(name: json['name']);
  }
}
