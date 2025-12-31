
import 'SimpleProductModel.dart';

class SellerProductListResponse {
  final int page;
  final String message;
  final List<Product> getAllProducts;

  SellerProductListResponse({
    required this.page,
    required this.message,
    required this.getAllProducts,
  });

  factory SellerProductListResponse.fromJson(Map<String, dynamic> json) {
    return SellerProductListResponse(
      page: json['page'],
      message: json['message'],
      getAllProducts: (json['getAllProducts'] as List)
          .map((product) => Product.fromJson(product))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'message': message,
      'getAllProducts': getAllProducts.map((product) => product.toJson()).toList(),
    };
  }
}

