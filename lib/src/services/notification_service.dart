import 'dart:typed_data';
import 'package:e_info_mobile/src/common/routes/app_route.dart';
import 'package:e_info_mobile/src/common/routes/app_route_args.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

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
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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
      print('📲 Message Body: ${message.notification?.body}');
      print('📦 Data: ${message.data}');

      showNotification(message);

      // Optional: Navigate directly in foreground
      final url = message.data['web_url'];
      if (url != null && url.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRoute.navigatorKey.currentState?.pushNamed(
            AppRoute.landingScreen,
            arguments: LandingScreenArgs(url: url),
          );
        });
      }
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
    });

    // Optional: print device token
    _messaging.getToken().then((token) {
      print('📱 FCM Token: $token');
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    final imageUrl = message.data['user_image'];
    AndroidNotificationDetails androidDetails;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          final imageBytes = response.bodyBytes;
          final bigPictureBitmap = ByteArrayAndroidBitmap(imageBytes);

          final bigPictureStyle = BigPictureStyleInformation(
            bigPictureBitmap,
            largeIcon: bigPictureBitmap,
            contentTitle: message.notification?.title ?? '',
            summaryText: message.notification?.body ?? '',
            htmlFormatContent: true,
            htmlFormatTitle: true,
          );

          androidDetails = AndroidNotificationDetails(
            'default_channel',
            'Default Notifications',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: bigPictureStyle,
            largeIcon: bigPictureBitmap,
          );
        } else {
          androidDetails = _defaultNotificationDetails();
        }
      } catch (e) {
        print("❌ Error loading image: $e");
        androidDetails = _defaultNotificationDetails();
      }
    } else {
      androidDetails = _defaultNotificationDetails();
    }

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
    );
  }

  AndroidNotificationDetails _defaultNotificationDetails() {
    return const AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
  }
}
