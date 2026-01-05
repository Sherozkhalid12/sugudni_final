class ActivityResponseModel {
  final int? page;
  final String? message;
  final List<Activity> activities;

  ActivityResponseModel({
    this.page,
    this.message,
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
    }

    return ActivityResponseModel(
      page: json['page'] as int?,
      message: json['message'] as String?,
      activities: activitiesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'message': message,
      'activities': activities.map((activity) => activity.toJson()).toList(),
    };
  }
}

// User model for activity userid
class ActivityUser {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? profilePic;

  ActivityUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.profilePic,
  });

  factory ActivityUser.fromJson(Map<String, dynamic> json) {
    return ActivityUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      profilePic: json['profilePic'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profilePic': profilePic,
    };
  }
}

class Activity {
  final String id;
  final ActivityUser? userid;
  final ActivityUser? otheruserid;
  final String? text;
  final String? title;
  final bool read;
  final String? activityType;
  final Map<String, dynamic>? activityData;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Activity({
    required this.id,
    this.userid,
    this.otheruserid,
    this.text,
    this.title,
    required this.read,
    this.activityType,
    this.activityData,
    this.createdAt,
    this.updatedAt,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['_id'] ?? '',
      userid: json['userid'] != null ? ActivityUser.fromJson(json['userid']) : null,
      otheruserid: json['otheruserid'] != null ? ActivityUser.fromJson(json['otheruserid']) : null,
      text: json['text'] as String?,
      title: json['title'] as String?,
      read: json['read'] ?? false,
      activityType: json['activityType'] as String?,
      activityData: json['activityData'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userid?.toJson(),
      'otheruserid': otheruserid?.toJson(),
      'text': text,
      'title': title,
      'read': read,
      'activityType': activityType,
      'activityData': activityData,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}




