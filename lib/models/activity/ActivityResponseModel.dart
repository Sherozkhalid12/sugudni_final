class ActivityResponseModel {
  final List<Activity> activities;
  final String? message;

  ActivityResponseModel({
    required this.activities,
    this.message,
  });

  factory ActivityResponseModel.fromJson(Map<String, dynamic> json) {
    return ActivityResponseModel(
      activities: json['activities'] != null
          ? (json['activities'] as List<dynamic>)
              .map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((e) => e.toJson()).toList(),
      'message': message,
    };
  }
}

class Activity {
  final String id;
  final String? title;
  final String? description;
  final String? type;
  final String? userId;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? metadata;

  Activity({
    required this.id,
    this.title,
    this.description,
    this.type,
    this.userId,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'],
      description: json['description'] ?? json['message'],
      type: json['type'],
      userId: json['userId'] ?? json['userid'],
      isRead: json['isRead'] ?? json['isread'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : json['createdat'] != null
              ? DateTime.tryParse(json['createdat'].toString())
              : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : json['updatedat'] != null
              ? DateTime.tryParse(json['updatedat'].toString())
              : null,
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'type': type,
      'userId': userId,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata,
    };
  }
}

