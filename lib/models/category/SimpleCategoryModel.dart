class SimpleCategoryModel {
  final String id;
  final String name;
  final String slug;
  final String image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  SimpleCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SimpleCategoryModel.fromJson(dynamic json) {
    if (json is String) {
      // Only ID string is provided, rest is default/dummy
      return SimpleCategoryModel(
        id: json,
        name: '',
        slug: '',
        image: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );
    } else if (json is Map<String, dynamic>) {
      return SimpleCategoryModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        image: json['Image'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : DateTime.now(),
        v: json['__v'] ?? 0,
      );
    } else {
      // Fallback in case of unexpected data
      return SimpleCategoryModel(
        id: '',
        name: '',
        slug: '',
        image: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );
    }
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
