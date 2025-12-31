class DriverToggleResponse {
  final String message;
  final bool driverOnline;

  DriverToggleResponse({
    required this.message,
    required this.driverOnline,
  });

  factory DriverToggleResponse.fromJson(Map<String, dynamic> json) {
    return DriverToggleResponse(
      message: json['message'],
      driverOnline: json['driverOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'driverOnline': driverOnline,
    };
  }
}
