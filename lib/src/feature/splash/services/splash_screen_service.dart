import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../common/config/app.dart';
import '../../../common/routes/app_route.dart';
import '../../../common/routes/app_route_args.dart';
import '../../../services/applink_service.dart';

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
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    String? notificationUrl;

    if (initialMessage != null) {
      notificationUrl = initialMessage.data['web_url'];
    }

    // ✅ 2. Determine final URL: notification > globalDeepLinkUri
    final Uri? finalUri = notificationUrl?.isNotEmpty == true
        ? Uri.tryParse(notificationUrl!)
        : globalDeepLinkUri;

    if (finalUri != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRoute.navigatorKey.currentState?.pushNamed(
          AppRoute.landingScreen,
          arguments: LandingScreenArgs(url: finalUri.toString()),
        );
      });
    } else {
      // ✅ No notification or deep link → navigate normally
      _view.navigateToLandingScreen();
    }
  }
}
