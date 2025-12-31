class AddToWishlistResponse {
  final String message;
  final List<String> addToWishList;

  AddToWishlistResponse({
    required this.message,
    required this.addToWishList,
  });

  AddToWishlistResponse copyWith({
    String? message,
    List<String>? addToWishList,
  }) {
    return AddToWishlistResponse(
      message: message ?? this.message,
      addToWishList: addToWishList ?? this.addToWishList,
    );
  }

  factory AddToWishlistResponse.fromJson(Map<String, dynamic> json) {
    return AddToWishlistResponse(
      message: json['message'] ?? '',
      addToWishList: json['addToWishList'] != null
          ? List<String>.from(json['addToWishList'])
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'addToWishList': addToWishList,
    };
  }
}
