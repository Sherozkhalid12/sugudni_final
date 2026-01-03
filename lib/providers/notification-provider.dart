import 'package:flutter/material.dart';
import 'package:sugudeni/models/activity/ActivityResponseModel.dart';
import 'package:sugudeni/repositories/activity/activity-repository.dart';

class NotificationProvider extends ChangeNotifier {
  List<Activity> _notifications = [];
  bool _isLoading = false;
  bool _hasUnreadNotifications = false;
  String? _error;

  List<Activity> get notifications => _notifications;
  bool get isLoading => _isLoading;
  bool get hasUnreadNotifications => _hasUnreadNotifications;
  String? get error => _error;

  int get unreadCount => _notifications.where((n) => !n.read).length;

  Future<void> loadNotifications(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ActivityRepository.getAllActivities(context);
      _notifications = response.activities;
      _hasUnreadNotifications = _notifications.any((n) => !n.read);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = Activity(
        id: _notifications[index].id,
        userid: _notifications[index].userid,
        otheruserid: _notifications[index].otheruserid,
        text: _notifications[index].text,
        title: _notifications[index].title,
        read: true,
        activityType: _notifications[index].activityType,
        activityData: _notifications[index].activityData,
        createdAt: _notifications[index].createdAt,
        updatedAt: _notifications[index].updatedAt,
      );
      _updateUnreadStatus();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => Activity(
      id: n.id,
      userid: n.userid,
      otheruserid: n.otheruserid,
      text: n.text,
      title: n.title,
      read: true,
      activityType: n.activityType,
      activityData: n.activityData,
      createdAt: n.createdAt,
      updatedAt: n.updatedAt,
    )).toList();
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  void _updateUnreadStatus() {
    _hasUnreadNotifications = _notifications.any((n) => !n.read);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
