class CategoryUpdateResponse {
  final String message;
  final Category updateCategory;

  CategoryUpdateResponse({
    required this.message,
    required this.updateCategory,
  });

  factory CategoryUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CategoryUpdateResponse(
      message: json['message'] ?? '',
      updateCategory: Category.fromJson(json['updateCategory']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'updateCategory': updateCategory.toJson(),
    };
  }
}

class Category {
  final String id;
  final String name;
  final String slug;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['Image'] ?? '',
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
      'Image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
