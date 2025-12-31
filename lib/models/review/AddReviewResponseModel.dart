class AddReviewResponseModel {
  final String message;
  final AddReview addReview;

  AddReviewResponseModel({
    required this.message,
    required this.addReview,
  });

  factory AddReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return AddReviewResponseModel(
      message: json['message'] ?? '',
      addReview: AddReview.fromJson(json['addReview'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'addReview': addReview.toJson(),
    };
  }
}

class AddReview {
  final String sellerId;
  final String text;
  final String productId;
  final String userId;
  final int rate;
  final String id;
  final String createdAt;
  final String updatedAt;

  AddReview({
    required this.sellerId,
    required this.text,
    required this.productId,
    required this.userId,
    required this.rate,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AddReview.fromJson(Map<String, dynamic> json) {
    return AddReview(
      sellerId: json['sellerId'] ?? '',
      text: json['text'] ?? '',
      productId: json['productId'] ?? '',
      userId: json['userId'] ?? '',
      rate: json['rate'] ?? 0,
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'text': text,
      'productId': productId,
      'userId': userId,
      'rate': rate,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
