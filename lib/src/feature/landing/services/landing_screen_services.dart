import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../common/config/app.dart';
import '../../../common/network/api_service.dart';

abstract class _ViewModel {
  void showSuccess(String message);
  void showWarning(String message);
}

mixin LandingScreenService<T extends StatefulWidget> on State<T>
    implements _ViewModel {
  late _ViewModel _view;
  StreamSubscription? _subscription;

  int currentPageIndex = 0;

  ///Service configurations
  @override
  void initState() {
    _subscription = Server.instance.onUnauthorizedRequest.listen(
      _onUnauthorizedRequest,
    );
    _view = this;
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  ///Public Fields
  final PageController pageController = PageController();

  ///On Tab selection changed
  void onTabSelected(int newIndex, int oldIndex) {
    ///Jump to +- one page of selected
    if ((math.max<int>(newIndex, oldIndex) - math.min<int>(newIndex, oldIndex) >
        1)) {
      if (newIndex > oldIndex) {
        pageController.jumpToPage(newIndex - 1);
      } else if (newIndex < oldIndex) {
        pageController.jumpToPage(newIndex + 1);
      }
    }

    ///Animate to page
    pageController.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 170),
      curve: Curves.easeOutCubic,
    );

    setState(() {
      currentPageIndex = newIndex;
    });
  }

  void _onUnauthorizedRequest(String message) async {
    if (!App.currentSession.isEmpty && mounted) {
      _view.showWarning(message);
      App.logOut().whenComplete(() {
        //  _view.navigateToAuthenticationScreen();
      });
    }
  }
}
