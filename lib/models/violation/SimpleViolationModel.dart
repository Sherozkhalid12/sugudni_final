class ViolationModel {
  final String id;
  final String description;
  final DateTime violationDate;

  ViolationModel({
    required this.id,
    required this.description,
    required this.violationDate,
  });

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json['_id'] ?? json['id'] ?? '',
      description: json['description'] ?? '',
      violationDate: DateTime.tryParse(json['violation_date'] ?? '') ?? DateTime(1970, 1, 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "id": id,
      "description": description,
      "violation_date": violationDate.toIso8601String(),
    };
  }
}
