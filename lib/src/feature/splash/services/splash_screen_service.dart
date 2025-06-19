import 'dart:async';
import 'package:flutter/material.dart';

import '../../../common/config/app.dart';

abstract class _ViewModel {
  void showWarning(String message);
  void navigateToLandingScreen();
}

mixin SplashScreenService<T extends StatefulWidget> on State<T>
implements _ViewModel {
  late _ViewModel _view;

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
    await Future.delayed(const Duration(seconds: 2));
    _view.navigateToLandingScreen();

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
