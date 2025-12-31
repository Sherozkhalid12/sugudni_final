
import 'SellerModel.dart';

class SellerDataResponse {
  final String message;
  final SellerUser? user;

  SellerDataResponse({required this.message, this.user});

  factory SellerDataResponse.fromJson(Map<String, dynamic> json) {
    return SellerDataResponse(
      message: json['message'] ?? 'No message',
      user: json.containsKey('user') ? SellerUser.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'user': user?.toJson(),
    };
  }
}

