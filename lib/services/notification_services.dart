import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  Future<void> sendLocalNotification({
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'lost_back_channel',
      'Lost & Back Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details =
    NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      title,
      body,
      details,
    );
  }
}
