import 'package:sugudeni/models/category/SimpleCategoryModel.dart';

class CategoryAddedResponse {
  final String message;
  final SimpleCategoryModel? addCategory;

  CategoryAddedResponse({
    required this.message,
    this.addCategory,
  });

  factory CategoryAddedResponse.fromJson(Map<String, dynamic> json) {
    return CategoryAddedResponse(
      message: json['message'] ?? '',
      addCategory: json['addcategory'] != null ? SimpleCategoryModel.fromJson(json['addcategory']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'addcategory': addCategory?.toJson(),
    };
  }
}

