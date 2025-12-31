class ReviewModel {
  final String id;
  final String sellerId;
  final String text;
  final String productId;
  final UserModel user;
  final int rate;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewModel({
    required this.id,
    required this.sellerId,
    required this.text,
    required this.productId,
    required this.user,
    required this.rate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      text: json['text'] ?? '',
      productId: json['productId'] ?? '',
      user: json['userId'] != null && json['userId'] is Map<String, dynamic>
          ? UserModel.fromJson(json['userId'])
          : UserModel(name: ''), // Default UserModel if null
      rate: json['rate'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970),
    );
  }
}
class UserModel {
  final String name;

  UserModel({required this.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
    );
  }
}
