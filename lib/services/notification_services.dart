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






// import 'dart:math';
//
// import 'package:app_settings/app_settings.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationServices {
//
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//   void requestNotificationPermission()async {
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: true,
//       badge: true,
//       carPlay: true,
//       criticalAlert: true,
//       provisional: true,
//       sound: true,
//     );
//     if(settings.authorizationStatus == AuthorizationStatus.authorized){
//       print('user give permission');
//     }else if (settings.authorizationStatus == AuthorizationStatus.provisional){
//       print('user give provisional permission');
//     }else{
//       AppSettings.openAppSettings();
//       print('permission denied');
//     }
//
//
//     Future<String> getDeviceToken() async{
//       String? token = await messaging.getToken();
//       return token!;
//     }
//   }
//
//   void initLocalNotification()async{
//     var androidInitilizationSettings = AndroidInitializationSettings('lb');
//     var IosInitilizationSettings = DarwinInitializationSettings();
//
//     var initializationSettings = InitializationSettings(
//         android: androidInitilizationSettings,
//         iOS: IosInitilizationSettings
//     );
//     await _flutterLocalNotificationsPlugin.initialize(
//         settings: initializationSettings,
//         onDidReceiveNotificationResponse: (payload){
//
//         }
//     );
//   }
//
//   void FirebaseInitial(message) {
//     FirebaseMessaging.onMessage.listen((message){
//       print(message.notification!.title.toString());
//       print(message.notification!.body.toString());
//       showNotification(message);
//     });
//   }
//
//   Future<void> showNotification(RemoteMessage message)async{
//     AndroidNotificationChannel Channel = AndroidNotificationChannel(
//         Random.secure().nextInt(1000).toString(),
//         'high_importance_channel',
//         importance: Importance.max
//     );
//     AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       Channel.id.toString(),
//       Channel.name.toString(),
//       channelDescription: 'your channel description',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//     // Future.delayed(Duration.zero,
//     //   _flutterLocalNotificationsPlugin.show(
//     //       id: 0,
//     //     title: message.notification!.title.toString(),
//     //     body: message.notification!.body.toString(),
//     //     notificationDetails: ,
//     //   )
//     // )
//   }
//
//   Future<String> getDeviceToken()async{
//     String? token = await messaging.getToken();
//     return token!;
//   }
//   void isTokenRefresh()async{
//     messaging.onTokenRefresh.listen((event){
//       event.toString();
//       print('refresh');
//     });
//   }
// }