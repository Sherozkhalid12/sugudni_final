class ActivityResponseModel {
  final List<Activity> activities;

  ActivityResponseModel({
    required this.activities,
  });

  factory ActivityResponseModel.fromJson(Map<String, dynamic> json) {
    List<Activity> activitiesList = [];
    
    if (json['activities'] != null) {
      if (json['activities'] is List) {
        activitiesList = (json['activities'] as List)
            .map((item) => Activity.fromJson(item))
            .toList();
      }
    } else if (json['getAllActivities'] != null) {
      if (json['getAllActivities'] is List) {
        activitiesList = (json['getAllActivities'] as List)
            .map((item) => Activity.fromJson(item))
            .toList();
      }
    }
    
    return ActivityResponseModel(activities: activitiesList);
  }

  Map<String, dynamic> toJson() {
    return {
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
}

class Activity {
  final String id;
  final String? type;
  final String? title;
  final String? description;
  final String? message;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? data;

  Activity({
    required this.id,
    this.type,
    this.title,
    this.description,
    this.message,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.data,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? json['id'] ?? '',
      type: json['type'],
      title: json['title'],
      description: json['description'],
      message: json['message'],
      isRead: json['isRead'] ?? json['is_read'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : (json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : (json['updated_at'] != null
              ? DateTime.tryParse(json['updated_at'].toString())
              : null),
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'type': type,
      'title': title,
      'description': description,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'data': data,
    };
  }
}

