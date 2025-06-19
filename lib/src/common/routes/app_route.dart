import 'package:flutter/material.dart';

import '../../feature/landing/screens/landing_screen.dart';
import '../../feature/splash/screens/splash_screen.dart';

class AppRoute {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static const String splashScreen = "splashScreen";
  static const String landingScreen = "landingScreen";
}

mixin RouteGenerator {
  static Route<dynamic> generate(RouteSettings setting) {
    return FadeInOutRouteBuilder(
      builder: (context) {
        switch (setting.name) {
          case AppRoute.splashScreen:
            return const SplashScreen();
          case AppRoute.landingScreen:
            return const LandingScreen();

          default:
            return const SplashScreen();
        }
      },
    );
  }
}

///This defines the animation of routing one page to another
class FadeInOutRouteBuilder extends PageRouteBuilder {
  final WidgetBuilder builder;

  FadeInOutRouteBuilder({required this.builder})
    : super(
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return builder(context);
            },
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: const Interval(0.50, 1.00, curve: Curves.linear),
                  ),
                ),
                child: child,
              );
            },
      );
}
