class NameModel {
  final String name;
  // final String slug;
  // final String category;

  NameModel({
    required this.name,
    // required this.slug,
    // required this.category,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      name: json['name'] ?? '',
      // slug: json['slug'] ?? '',
      // category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      // 'slug': slug,
      // 'category': category,
    };
  }
}
