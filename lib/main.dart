import 'package:e_info_mobile/src/services/applink_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';

import 'src/common/app.dart';
import 'src/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: Platform.isAndroid
        ? const FirebaseOptions(
      apiKey: "AIzaSyBoD2nhQsz1QOPqMzVAn-bRpvEqu5SneVk",
      appId: "1:438009665395:android:be58e8a62b570eca58d706",
      messagingSenderId: "438009665395",
      projectId: "einfo-e95ba",
      storageBucket: "einfo-e95ba.firebasestorage.app",
    )
        : const FirebaseOptions(
      apiKey: "AIzaSyBbq4mIpA94Lj5z66m0ZXSFwMHSxm_QJ8U",
      appId: "1:438009665395:ios:42ae9ad25e613bb358d706",
      messagingSenderId: "438009665395",
      projectId: "einfo-e95ba",
      storageBucket: "einfo-e95ba.firebasestorage.app",
      iosBundleId: 'com.einfo.site',
    ),
  );

  // ✅ Request iOS notification permissions
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // ✅ Initialize your notification service
  await NotificationService().init();

  // ✅ Background message handler (Android + iOS)
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Debugging for Android WebView
  if (Platform.isAndroid) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  final appLinkService = AppLinkService();
  await appLinkService.init();

  runApp(const Application());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔙 Handling a background message: ${message.messageId}');
}
