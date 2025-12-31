class SubCategoryAddedResponse {
  final String message;
  final SubCategory addSubcategory;

  SubCategoryAddedResponse({
    required this.message,
    required this.addSubcategory,
  });

  factory SubCategoryAddedResponse.fromJson(Map<String, dynamic> json) {
    return SubCategoryAddedResponse(
      message: json['message'] ?? '',
      addSubcategory: SubCategory.fromJson(json['addSubcategory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'addSubcategory': addSubcategory.toJson(),
    };
  }
}

class SubCategory {
  final String id;
  final String name;
  final String slug;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  SubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
