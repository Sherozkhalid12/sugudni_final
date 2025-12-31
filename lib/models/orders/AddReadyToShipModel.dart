class ReadyToShipModel {
  final String pickupAddress;

  ReadyToShipModel({required this.pickupAddress});

  factory ReadyToShipModel.fromJson(Map<String, dynamic> json) {
    return ReadyToShipModel(
      pickupAddress: json['pickupAddress'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupAddress': pickupAddress,
    };
  }
}
