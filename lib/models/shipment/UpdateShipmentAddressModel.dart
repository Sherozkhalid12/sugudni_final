class UpdateShipmentModel {
  final String estimatedArrival;
  final String currentLocation;
  final String currentLocationLatLong;

  UpdateShipmentModel({
    required this.estimatedArrival,
    required this.currentLocation,
    required this.currentLocationLatLong,
  });

  factory UpdateShipmentModel.fromJson(Map<String, dynamic> json) {
    return UpdateShipmentModel(
      estimatedArrival: json['estimatedArrival'],
      currentLocation: json['currentLocation'],
      currentLocationLatLong: json['currentLocationLatLong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'estimatedArrival': estimatedArrival,
      'currentLocation': currentLocation,
      'currentLocationLatLong': currentLocationLatLong,
    };
  }
}
