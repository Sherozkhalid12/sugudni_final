
import 'package:sugudeni/models/address-model/AddressesModel.dart';

class AddedAddressResponseModel {
  final String message;
  final AddressesModel addAddress;

  AddedAddressResponseModel({
    required this.message,
    required this.addAddress,
  });

  factory AddedAddressResponseModel.fromJson(Map<String, dynamic> json) {
    return AddedAddressResponseModel(
      message: json['message'] ?? 'Unknown',
      addAddress: AddressesModel.fromJson(json['addAddress'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'addAddress': addAddress.toJson(),
    };
  }
}
