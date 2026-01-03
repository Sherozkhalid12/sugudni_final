import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sugudeni/utils/global-functions.dart';
import 'package:sugudeni/api/api-endpoints.dart';
import 'package:sugudeni/api/network/api-client.dart';
import 'package:sugudeni/utils/sharePreference/save-user-token.dart';

/// Top-level function to handle background messages
/// Must be a top-level function, not a class method
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  customPrint('Handling background message: ${message.messageId}');
  customPrint('Background message data: ${message.data}');
  customPrint('Background message notification: ${message.notification?.title}');
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  Function(RemoteMessage)? onMessageTap;
  // Store recent messages for local notification tap handling
  final Map<int, RemoteMessage> _storedMessages = {};

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      customPrint('User granted permission: ${settings.authorizationStatus}');

      // Initialize local notifications for Android
      await _initializeLocalNotifications();

      // Set up background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a terminated state via notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Get FCM token
      await getFCMToken();

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        _fcmToken = newToken;
        customPrint('FCM Token refreshed: $newToken');
        // Send updated token to backend
        await _sendTokenToBackend(newToken);
      });

    } catch (e) {
      customPrint('Error initializing Firebase Messaging: $e');
    }
  }

  /// Initialize local notifications for Android
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        customPrint('Local notification tapped: ${response.payload}');
        customPrint('Notification ID: ${response.id}');
        
        // Try to get stored message by notification ID
        if (_storedMessages.containsKey(response.id)) {
          final message = _storedMessages[response.id];
          if (message != null) {
            customPrint('Found stored message for notification ID: ${response.id}');
            handleForegroundNotificationTap(message);
            // Remove from stored messages after handling
            _storedMessages.remove(response.id);
          }
        } else {
          // Try to parse payload as JSON to get notification data
          if (response.payload != null && response.payload!.isNotEmpty) {
            try {
              final data = jsonDecode(response.payload!);
              if (data is Map) {
                customPrint('Parsed notification payload: $data');
                // Try to create a RemoteMessage from the payload
                // This is a fallback if stored message is not available
                if (onMessageTap != null) {
                  // We'll need to handle this in the callback
                  customPrint('Payload data available, but need RemoteMessage object');
                }
              }
            } catch (e) {
              customPrint('Error parsing notification payload: $e');
            }
          }
        }
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    customPrint('Received foreground message: ${message.messageId}');
    customPrint('Message data: ${message.data}');
    customPrint('Message notification: ${message.notification?.title}');

    // Show local notification when app is in foreground
    if (message.notification != null) {
      await _showLocalNotification(message);
      
      // Store the message for when user taps the notification
      // We'll handle the tap in the local notification response handler
      // by checking the stored message or using onMessageTap
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notificationId = message.hashCode;
    
    // Store the message for tap handling
    _storedMessages[notificationId] = message;
    
    // Clean up old stored messages (keep only last 10)
    if (_storedMessages.length > 10) {
      final oldestKey = _storedMessages.keys.first;
      _storedMessages.remove(oldestKey);
    }
    
    await _localNotifications.show(
      notificationId,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
      payload: jsonEncode(message.data), // Store data as JSON string
    );
  }

  /// Handle notification tap when app is opened from background/terminated state
  void _handleMessageOpenedApp(RemoteMessage message) {
    customPrint('Notification opened app: ${message.messageId}');
    customPrint('Message data: ${message.data}');
    customPrint('Notification title: ${message.notification?.title}');
    
    // Call the callback if set
    if (onMessageTap != null) {
      onMessageTap!(message);
    }
  }
  
  /// Handle foreground notification tap (when app is in foreground)
  void handleForegroundNotificationTap(RemoteMessage message) {
    customPrint('Foreground notification tapped: ${message.messageId}');
    customPrint('Message data: ${message.data}');
    customPrint('Notification title: ${message.notification?.title}');
    
    // Call the callback if set
    if (onMessageTap != null) {
      onMessageTap!(message);
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      customPrint('FCM Token: $_fcmToken');
      return _fcmToken;
    } catch (e) {
      customPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Get current FCM token (cached)
  String? get currentToken => _fcmToken;

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      customPrint('Subscribed to topic: $topic');
    } catch (e) {
      customPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      customPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      customPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      customPrint('FCM Token deleted');
    } catch (e) {
      customPrint('Error deleting FCM token: $e');
    }
  }

  /// Send FCM token to backend
  Future<void> _sendTokenToBackend(String fcmToken) async {
    try {
      // Check if user is authenticated - need both token and userId
      final sessionToken = await getSessionTaken();
      final userId = await getUserId();
      
      if (sessionToken.isEmpty || sessionToken.trim().isEmpty) {
        customPrint('Cannot send FCM token: User not authenticated (no session token)');
        return;
      }

      // Also check userId exists - backend needs this to find the user
      if (userId.isEmpty || userId.trim().isEmpty) {
        customPrint('Cannot send FCM token: User ID not found. User may not be fully logged in.');
        return;
      }

      // Get headers with auth token
      final headers = await ApiClient.bearerHeader;
      customPrint('FCM Token Update (on refresh) - Auth Token in header: ${headers['token']?.substring(0, 20) ?? 'null'}...');
      customPrint('FCM Token Update (on refresh) - Authorization header: ${headers['Authorization']?.substring(0, 30) ?? 'null'}...');

      final body = {'fcmtoken': fcmToken};
      final response = await ApiClient.patchRequest(
        ApiEndpoints.setFcmToken,
        body,
        headers: headers,
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          customPrint('FCM token update timed out');
          throw TimeoutException('Request timed out');
        },
      );

      final responseBody = jsonDecode(response.body);
      customPrint("FCM Token Update Response (on refresh): $responseBody");
      customPrint("FCM Token Update Status Code: ${response.statusCode}");
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        customPrint('FCM token updated successfully on backend');
      } else if (response.statusCode == 400) {
        // 400 Bad Request - likely means token is invalid or user not found
        final error = responseBody['error'] ?? responseBody['message'] ?? 'Bad Request';
        customPrint('Failed to update FCM token: $error (Status: 400)');
        customPrint('This usually means the session token is invalid or expired. Token will be sent again after next login.');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Unauthorized/Forbidden - user needs to login again
        customPrint('FCM token update failed: User authentication expired (Status: ${response.statusCode})');
      } else {
        final error = responseBody['error'] ?? responseBody['message'] ?? 'Unknown error';
        customPrint('Failed to update FCM token on backend: $error (Status: ${response.statusCode})');
      }
    } catch (e) {
      customPrint('Error sending FCM token to backend: $e');
      // Don't throw - this is not critical
    }
  }
}

