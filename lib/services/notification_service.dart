import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService._internal() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    final initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'pomodoro_channel',
        'Pomodoro Notifications',
        channelDescription: 'Notifications for Pomodoro timer',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}
