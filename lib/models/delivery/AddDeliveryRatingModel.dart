class AddDeliveryRatingModel {
  final String ratingDescription;
  final int rating;

  AddDeliveryRatingModel({
    required this.ratingDescription,
    required this.rating,
  });

  // Convert JSON to Model
  factory AddDeliveryRatingModel.fromJson(Map<String, dynamic> json) {
    return AddDeliveryRatingModel(
      ratingDescription: json['ratingDescription'] ?? '',
      rating: json['rating'] ?? 0,
    );
  }

  // Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'ratingDescription': ratingDescription,
      'rating': rating,
    };
  }
}
