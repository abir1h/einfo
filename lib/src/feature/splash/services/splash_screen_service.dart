import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../common/config/app.dart';
import '../../../common/routes/app_route.dart';
import '../../../common/routes/app_route_args.dart';

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
      }else{
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
  void _fetchUserSession() async {
    ///Delayed for 2 seconds
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
      }else{
        _view.navigateToLandingScreen();
      }
    }else{
      _view.navigateToLandingScreen();
    }

    ///Navigate to logical page
    // App.getCurrentSession().then((session) async {
    //   if (session.token.isEmpty) {
    //     ///Navigate to login screens
    //     App.getOnboardUser().then((value) {
    //       if (!value) {
    //         _view.navigateToOnBoardingScreen();
    //       } else {
    //         _view.navigateToLandingScreen();
    //       }
    //     });
    //   } else {
    //     ///Navigate to landing page
    //     _view.navigateToLandingScreen();
    //   }
    // });
  }
}
