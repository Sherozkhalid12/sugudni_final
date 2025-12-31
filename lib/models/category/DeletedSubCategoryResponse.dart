class DeleteSubCategoryResponse {
  final String message;
  final DeletedSubCategory subcategory;

  DeleteSubCategoryResponse({
    required this.message,
    required this.subcategory,
  });

  factory DeleteSubCategoryResponse.fromJson(Map<String, dynamic> json) {
    return DeleteSubCategoryResponse(
      message: json['message'] as String,
      subcategory: DeletedSubCategory.fromJson(json['subcategory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'subcategory': subcategory.toJson(),
    };
  }
}

class DeletedSubCategory {
  final String id;
  final String name;
  final String slug;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  DeletedSubCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory DeletedSubCategory.fromJson(Map<String, dynamic> json) {
    return DeletedSubCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      category: json['category'] as String,
      createdAt: DateTime.parse(json['createdAt']), // Parsing DateTime
      updatedAt: DateTime.parse(json['updatedAt']), // Parsing DateTime
      v: json['__v'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'createdAt': createdAt.toIso8601String(), // Converting back to string
      'updatedAt': updatedAt.toIso8601String(), // Converting back to string
      '__v': v,
    };
  }
}
