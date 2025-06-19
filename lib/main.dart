import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'src/common/app.dart';
import 'src/services/notification_service.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? FirebaseOptions(
            apiKey: "AIzaSyBoD2nhQsz1QOPqMzVAn-bRpvEqu5SneVk",
            appId: "1:438009665395:android:be58e8a62b570eca58d706",
            messagingSenderId: "438009665395",
            projectId: "einfo-e95ba",
            storageBucket: "einfo-e95ba.firebasestorage.app",
          )
        : FirebaseOptions(
            apiKey: "AIzaSyBbq4mIpA94Lj5z66m0ZXSFwMHSxm_QJ8U",
            appId: "1:438009665395:ios:42ae9ad25e613bb358d706",
            messagingSenderId: "438009665395",
            projectId: "einfo-e95ba",
            storageBucket: "einfo-e95ba.firebasestorage.app",
            iosBundleId: 'com.einfo.site',
          ),
  );

  // Initialize everything from the service
  await NotificationService().init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const Application());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔙 Handling a background message: ${message.messageId}');
  // Optional: save to local db, schedule notification, etc.
}
