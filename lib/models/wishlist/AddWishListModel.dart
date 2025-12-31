class AddToWishlistModel {
  final String productId;

  AddToWishlistModel({required this.productId});

  AddToWishlistModel copyWith({String? productId}) {
    return AddToWishlistModel(
      productId: productId ?? this.productId,
    );
  }

  factory AddToWishlistModel.fromJson(Map<String, dynamic> json) {
    return AddToWishlistModel(
      productId: json['productId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
    };
  }
}
