import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../common/config/app.dart';
import '../../../common/routes/app_route.dart';
import '../../../common/routes/app_route_args.dart';
import '../../../services/applink_service.dart';
import '../../landing/gateways/landing_gateway.dart';

abstract class _ViewModel {
  void showWarning(String message);
  void navigateToLandingScreen();
}

mixin SplashScreenService<T extends StatefulWidget> on State<T>
    implements _ViewModel {
  late _ViewModel _view;
  void checkInitialMessage() async {
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      final url = initialMessage.data['web_url'];
      if (url != null && url.isNotEmpty) {
        // Delay navigation to after widgets are ready
        print(url);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRoute.navigatorKey.currentState?.pushNamed(
            AppRoute.landingScreen,
            arguments: LandingScreenArgs(url: url),
          );
        });
      } else {
        _view.navigateToLandingScreen();
      }
    }
  }

  ///Service configurations
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fetchUserSession();
    });
    _view = this;
  }

  @override
  void dispose() {
    super.dispose();
  }

  ///Fetch users from local database
  // void _fetchUserSession() async {
  //   ///Delayed for 2 seconds
  //   final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  //
  //   if (initialMessage != null) {
  //     final url = initialMessage.data['web_url'];
  //     if (url != null && url.isNotEmpty) {
  //       WidgetsBinding.instance.addPostFrameCallback((_) {
  //         AppRoute.navigatorKey.currentState?.pushNamed(
  //           AppRoute.landingScreen,
  //           arguments: LandingScreenArgs(url: url),
  //         );
  //       });
  //     } else {
  //       _view.navigateToLandingScreen();
  //     }
  //   } else {
  //     _view.navigateToLandingScreen();
  //   }
  // }
  void _fetchUserSession() async {
    // ✅ 1. Check Firebase notification for initial message
    try {
      // 1. Check if app was launched from terminated state via a notification tap
      final RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

      String? notificationUrl;

      if (initialMessage != null && initialMessage.data.isNotEmpty) {
        notificationUrl = initialMessage.data['web_url'];
        print('🚀 App launched from notification with URL: $notificationUrl');
      }

      final userId = initialMessage!.data['user_id']?.toString() ?? '';
      final sourceId = initialMessage.data['source_id']?.toString() ?? '';
      final type = initialMessage.data['type']?.toString() ?? '';

      print("🔔 Notification tapped with: userId=$userId, sourceId=$sourceId, type=$type");

      SendTokenGateway.markNotificationAsSeen(userId: userId, sourceId: sourceId, type: type);
      // 2. Choose URL from notification first, otherwise globalDeepLinkUri (could be null)
      final Uri? finalUri = (notificationUrl?.isNotEmpty == true)
          ? Uri.tryParse(notificationUrl!)
          : globalDeepLinkUri;

      // 3. Navigate accordingly on next frame
      if (finalUri != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AppRoute.navigatorKey.currentState?.pushNamed(
            AppRoute.landingScreen,
            arguments: LandingScreenArgs(url: finalUri.toString()),
          );
        });
      } else {
        // No notification or deep link → normal navigation
        _view.navigateToLandingScreen();
      }
    } catch (e, stack) {
      print('❌ Error in _fetchUserSession: $e\n$stack');
      _view.navigateToLandingScreen(); // fallback navigation
    }
  }
}
