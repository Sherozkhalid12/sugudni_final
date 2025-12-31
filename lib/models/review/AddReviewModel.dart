class AddReviewModel {
  final String text;
  final String productId;
  final int rate;

  AddReviewModel({
    required this.text,
    required this.productId,
    required this.rate,
  });

  factory AddReviewModel.fromJson(Map<String, dynamic> json) {
    return AddReviewModel(
      text: json['text'] ?? '',
      productId: json['productId'] ?? '',
      rate: json['rate'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'productId': productId,
      'rate': rate,
    };
  }
}
