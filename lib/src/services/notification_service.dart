// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:e_info_mobile/src/common/routes/app_route.dart';
// import 'package:e_info_mobile/src/common/routes/app_route_args.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:http/http.dart' as http;
//
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//
// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//
//   NotificationService._internal();
//
//   final FirebaseMessaging _messaging = FirebaseMessaging.instance;
//   final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//     // Android settings
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // iOS settings
//     final iosSettings = DarwinInitializationSettings(
//       requestSoundPermission: true,
//       requestBadgePermission: true,
//       requestAlertPermission: true,
//     );
//
//     // Combine initialization settings
//     final initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
//
//     // Handle notification tap from background/terminated
//     await _flutterLocalNotificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (NotificationResponse response) {
//         final payload = response.payload;
//         if (payload != null && payload.isNotEmpty) {
//           print("🔔 Notification tapped with payload: $payload");
//           print("🔔 Notification tapped with payload:${response.data}");
//
//
//
//           markNotificationAsSeen(userId: response.data['user_id'], sourceId: response.data['source_id'],type: response.data['type'],);
//           AppRoute.navigatorKey.currentState?.pushNamed(
//             AppRoute.landingScreen,
//             arguments: LandingScreenArgs(url: payload),
//           );
//         }
//       },
//     );
//
//     // Request notification permission (iOS)
//     await _messaging.requestPermission();
//
//     // Initialize FCM handlers
//     initializeFCM();
//   }
//   Future<void> markNotificationAsSeen({
//     required String userId,
//     required String sourceId,
//     required String type,
//   }) async {
//     final apiUrl = Uri.parse('https://einfo.site/api/update-seen/');
//
//     try {
//       final response = await http.post(
//         apiUrl,
//         headers: {
//           HttpHeaders.contentTypeHeader: 'application/json',
//         },
//         body: jsonEncode({
//           "user_id": userId,
//           "source_id": sourceId,
//           "type": type,
//           "seen": true,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         print("✅ Notification marked as seen");
//       } else {
//         print("❌ Failed to mark notification as seen: ${response.statusCode}");
//         print("🧾 Response body: ${response.body}");
//       }
//     } catch (e) {
//       print("❌ Error sending seen request: $e");
//     }
//   }
//   void initializeFCM() {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('📩 Foreground Message: ${message.notification?.title}');
//       print('📲 Message Body: ${message.notification?.body}');
//       print('📦 Data: ${message.data}');
//
//       showNotification(message);
//
//       // Optional immediate foreground navigation
//       final url = message.data['web_url'];
//       if (url != null && url.isNotEmpty) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           AppRoute.navigatorKey.currentState?.pushNamed(
//             AppRoute.landingScreen,
//             arguments: LandingScreenArgs(url: url),
//           );
//         });
//       }
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('📲 App opened from notification: ${message.notification?.title}');
//       final url = message.data['web_url'];
//       if (url != null && url.isNotEmpty) {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           AppRoute.navigatorKey.currentState?.pushNamed(
//             AppRoute.landingScreen,
//             arguments: LandingScreenArgs(url: url),
//           );
//         });
//       }
//     });
//
//     if (Platform.isAndroid) {
//       _messaging.getToken().then((token) {
//         print('📱 FCM Token: $token');
//       });
//     }
//
//     if (Platform.isIOS) {
//       FirebaseMessaging.instance.getAPNSToken().then((apnsToken) {
//         print('🍎 APNs Token: $apnsToken');
//       });
//     }
//   }
//
//   Future<void> showNotification(RemoteMessage message) async {
//     final imageUrl = message.data['user_image'];
//     final payload = message.data['web_url'];
//     AndroidNotificationDetails androidDetails;
//
//     if (imageUrl != null && imageUrl.isNotEmpty) {
//       try {
//         final response = await http.get(Uri.parse(imageUrl));
//         if (response.statusCode == 200) {
//           final imageBytes = response.bodyBytes;
//           final bigPictureBitmap = ByteArrayAndroidBitmap(imageBytes);
//
//           final bigPictureStyle = BigPictureStyleInformation(
//             bigPictureBitmap,
//             largeIcon: bigPictureBitmap,
//             contentTitle: message.notification?.title ?? '',
//             summaryText: message.notification?.body ?? '',
//             htmlFormatContent: true,
//             htmlFormatTitle: true,
//           );
//
//           androidDetails = AndroidNotificationDetails(
//             'default_channel',
//             'Default Notifications',
//             importance: Importance.max,
//             priority: Priority.high,
//             styleInformation: bigPictureStyle,
//             largeIcon: bigPictureBitmap,
//           );
//         } else {
//           androidDetails = _defaultNotificationDetails();
//         }
//       } catch (e) {
//         print("❌ Error loading image: $e");
//         androidDetails = _defaultNotificationDetails();
//       }
//     } else {
//       androidDetails = _defaultNotificationDetails();
//     }
//
//     final notificationDetails = NotificationDetails(android: androidDetails);
//
//     final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);
//     print("🔔 Showing notification with ID: $notificationId and payload: $payload");
//
//     await _flutterLocalNotificationsPlugin.show(
//       notificationId,
//       message.notification?.title ?? 'No Title',
//       message.notification?.body ?? 'No Body',
//       notificationDetails,
//       payload: payload, // ✅ Needed for tap navigation
//     );
//   }
//
//   AndroidNotificationDetails _defaultNotificationDetails() {
//     return const AndroidNotificationDetails(
//       'default_channel',
//       'Default Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:e_info_mobile/src/common/routes/app_route.dart';
import 'package:e_info_mobile/src/common/routes/app_route_args.dart';
import 'package:e_info_mobile/src/feature/landing/gateways/landing_gateway.dart';
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
    const androidSettings = AndroidInitializationSettings('icon_notification');

    final iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          try {
            final data = jsonDecode(payload);
            final userId = data['user_id']?.toString() ?? '';
            final sourceId = data['source_id']?.toString() ?? '';
            final type = data['type']?.toString() ?? '';
            final url = data['web_url']?.toString() ?? '';

            print("🔔 Notification tapped with: userId=$userId, sourceId=$sourceId, type=$type");

            SendTokenGateway.markNotificationAsSeen(userId: userId, sourceId: sourceId, type: type);

            if (url.isNotEmpty) {
              AppRoute.navigatorKey.currentState?.pushNamed(
                AppRoute.landingScreen,
                arguments: LandingScreenArgs(url: url),
              );
            }
          } catch (e) {
            print("❌ Error parsing payload or calling seen: $e");
          }
        }
      },
    );

    await _messaging.requestPermission();

    initializeFCM();
  }

  void initializeFCM() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📩 Foreground Message: ${message.notification?.title}');
      print('📲 Message Body: ${message.notification?.body}');
      print('📦 Data: ${message.data}');

      showNotification(message);

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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 App opened from notification: ${message.notification?.title}');
      final url = message.data['web_url'];

      final userId = message.data['user_id']?.toString() ?? '';
      final sourceId = message.data['source_id']?.toString() ?? '';
      final type = message.data['type']?.toString() ?? '';

      print("🔔 Notification tapped with: userId=$userId, sourceId=$sourceId, type=$type");

      SendTokenGateway.markNotificationAsSeen(userId: userId, sourceId: sourceId, type: type);
      if (url != null && url.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRoute.navigatorKey.currentState?.pushNamed(
            AppRoute.landingScreen,
            arguments: LandingScreenArgs(url: url),
          );
        });
      }
    });

    if (Platform.isAndroid) {
      _messaging.getToken().then((token) {
        print('📱 FCM Token: $token');
      });
    }

    if (Platform.isIOS) {
      FirebaseMessaging.instance.getAPNSToken().then((apnsToken) {
        print('🍎 APNs Token: $apnsToken');
      });
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    final imageUrl = message.data['user_image'];
    final payload = jsonEncode(message.data); // ✅ full data payload
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
    final notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    print("🔔 Showing notification with ID: $notificationId and payload: $payload");

    await _flutterLocalNotificationsPlugin.show(
      notificationId,
      message.notification?.title ?? 'No Title',
      message.notification?.body ?? 'No Body',
      notificationDetails,
      payload: payload,
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
