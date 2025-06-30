import 'package:e_info_mobile/src/common/routes/app_route.dart';
import 'package:e_info_mobile/src/common/routes/app_route_args.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Local notifications setup
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettings = InitializationSettings(android: androidSettings);

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Firebase messaging permissions
    await _messaging.requestPermission();

    // Firebase foreground & background handlers
    initializeFCM();
  }

  void initializeFCM() {
    // Foreground message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground Message: ${message.notification?.title}');
      print('📲 App opened from notification: ${message.notification?.body}');
      print('📲 App opened from notification: ${message.data}');


      showNotification(message);
    });

    // When tapped while app is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 App opened from notification: ${message.notification?.title}');
      final url = message.data['web_url'];
      if (url != null && url.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRoute.navigatorKey.currentState?.pushNamed(
            AppRoute.landingScreen,
            arguments: LandingScreenArgs(url: url),
          );
        });
      }

      // You can navigate using Navigator.pushNamed() here if needed
    });

    // Optional: print device token
    _messaging.getToken().then((token) {
      print('📱 FCM Token: $token');
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }
}
