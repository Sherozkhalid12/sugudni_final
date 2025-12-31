import 'package:sugudeni/models/user/CustomerModel.dart';

import 'SellerModel.dart';

class CustomerDataResponse {
  final String message;
  final CustomerModel? user;

  CustomerDataResponse({required this.message, this.user});

  factory CustomerDataResponse.fromJson(Map<String, dynamic> json) {
    return CustomerDataResponse(
      message: json['message'] ?? 'No message',
      user: json.containsKey('user') ? CustomerModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
    };
  }
}