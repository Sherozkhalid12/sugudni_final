import 'package:sugudeni/models/category/SimpleSubCategoryModel.dart';

class SubCategoryListResponse {
  final String message;
  final List<SimpleSubCategoryModel> getAllSubCategories;

  SubCategoryListResponse({
    required this.message,
    required this.getAllSubCategories,
  });

  factory SubCategoryListResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryListResponse(
      message: json['message'] ?? '',
      getAllSubCategories: (json['subCategories'] as List<dynamic>?)
          ?.map((e) => SimpleSubCategoryModel.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'subCategories':
      getAllSubCategories.map((e) => e.toJson()).toList(),
    };
  }
}

