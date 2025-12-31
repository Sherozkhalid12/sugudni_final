class RemoveFromWishlistResponseModel {
  final String message;
  final List<String> removeFromWishList;

  RemoveFromWishlistResponseModel({
    required this.message,
    required this.removeFromWishList,
  });

  RemoveFromWishlistResponseModel copyWith({
    String? message,
    List<String>? removeFromWishList,
  }) {
    return RemoveFromWishlistResponseModel(
      message: message ?? this.message,
      removeFromWishList: removeFromWishList ?? this.removeFromWishList,
    );
  }

  factory RemoveFromWishlistResponseModel.fromJson(Map<String, dynamic> json) {
    return RemoveFromWishlistResponseModel(
      message: json['message'] ?? '',
      removeFromWishList: json['removeFromWishList'] != null
          ? List<String>.from(json['removeFromWishList'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'removeFromWishList': removeFromWishList,
    };
  }
}
