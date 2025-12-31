class FailedDeliveryModel {
  final String failureReason;

  FailedDeliveryModel({required this.failureReason});

  factory FailedDeliveryModel.fromJson(Map<String, dynamic> json) {
    return FailedDeliveryModel(
      failureReason: json['failureReason'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'failureReason': failureReason,
    };
  }
}
