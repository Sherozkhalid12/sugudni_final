class CategoryListResponse {
  final int page;
  final String message;
  final List<Category> getAllCategories;

  CategoryListResponse({
    required this.page,
    required this.message,
    required this.getAllCategories,
  });

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) {
    return CategoryListResponse(
      page: json['PAGE_NUMBER'] ?? 1,
      message: json['message'] ?? '',
      getAllCategories: (json['categories'] as List?)
          ?.map((e) => Category.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PAGE_NUMBER': page,
      'message': message,
      'categories': getAllCategories.map((e) => e.toJson()).toList(),
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
