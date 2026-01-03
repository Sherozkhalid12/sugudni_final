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

  int get unreadCount => _notifications.where((n) => !(n.isRead ?? true)).length;

  Future<void> loadNotifications(BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ActivityRepository.getAllActivities(context);
      _notifications = response.activities;
      _hasUnreadNotifications = _notifications.any((n) => !(n.isRead ?? true));
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
        type: _notifications[index].type,
        title: _notifications[index].title,
        description: _notifications[index].description,
        message: _notifications[index].message,
        isRead: true,
        createdAt: _notifications[index].createdAt,
        updatedAt: _notifications[index].updatedAt,
        data: _notifications[index].data,
      );
      _updateUnreadStatus();
      notifyListeners();
    }
  }

  void markAllAsRead() {
    _notifications = _notifications.map((n) => Activity(
      id: n.id,
      type: n.type,
      title: n.title,
      description: n.description,
      message: n.message,
      isRead: true,
      createdAt: n.createdAt,
      updatedAt: n.updatedAt,
      data: n.data,
    )).toList();
    _hasUnreadNotifications = false;
    notifyListeners();
  }

  void _updateUnreadStatus() {
    _hasUnreadNotifications = _notifications.any((n) => !(n.isRead ?? true));
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
