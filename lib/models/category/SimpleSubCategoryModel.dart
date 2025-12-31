class SimpleSubCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String category;
  final String createdAt;
  final String updatedAt;
  final int v;

  SimpleSubCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SimpleSubCategoryModel.fromJson(dynamic json) {
    if (json is String) {
      // Only ID is provided, rest is default
      return SimpleSubCategoryModel(
        id: json,
        name: '',
        slug: '',
        category: '',
        createdAt: '',
        updatedAt: '',
        v: 0,
      );
    } else if (json is Map<String, dynamic>) {
      return SimpleSubCategoryModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        category: json['category'] ?? '',
        createdAt: json['createdAt'] ?? '',
        updatedAt: json['updatedAt'] ?? '',
        v: json['__v'] ?? 0,
      );
    } else {
      // Fallback if data is neither Map nor String
      return SimpleSubCategoryModel(
        id: '',
        name: '',
        slug: '',
        category: '',
        createdAt: '',
        updatedAt: '',
        v: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
