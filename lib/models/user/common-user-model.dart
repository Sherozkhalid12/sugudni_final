class CommonUserModel {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CommonUserModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CommonUserModel.fromJson(dynamic json) {
    if (json is String) {
      /// Only ID string is provided, rest is default/dummy
      return CommonUserModel(
        id: json,
        name: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        v: 0,
      );
    } else if (json is Map<String, dynamic>) {
      return CommonUserModel(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
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
      return CommonUserModel(
        id: '',
        name: '',
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

      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
