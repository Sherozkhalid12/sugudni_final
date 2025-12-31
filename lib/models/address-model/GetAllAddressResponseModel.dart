import 'AddressesModel.dart';

class GetAllAdressModelResponse {
  final String message;
  final List<AddressesModel> getAllAddresses;

  GetAllAdressModelResponse({
    required this.message,
    required this.getAllAddresses,
  });

  factory GetAllAdressModelResponse.fromJson(Map<String, dynamic> json) {
    return GetAllAdressModelResponse(
      message: json['message'] ?? 'No message',
      getAllAddresses: json['getAllAddresses'] != null
          ? List<AddressesModel>.from(
          json['getAllAddresses'].map((x) => AddressesModel.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'getAllAddresses': getAllAddresses.map((x) => x.toJson()).toList(),
    };
  }
}
