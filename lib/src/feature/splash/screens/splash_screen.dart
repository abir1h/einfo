import 'package:flutter/material.dart';

import '../../../common/constants/common_imports.dart';
import '../../../common/routes/app_route.dart';
import '../../../common/widgets/custom_toasty.dart';
import '../services/splash_screen_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with AppTheme, SplashScreenService {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clr.whiteColor,
      body:Center(child: Text('E- Info',style: TextStyle( fontWeight: FontWeight.bold,fontSize: size.s32,),),)
    );
  }

  @override
  void showWarning(String message) {
    Toasty.of(context).showWarning(message);
  }

  @override
  void navigateToUserSelectionScreen() {
    Navigator.of(context).pushNamed(AppRoute.landingScreen);
  }

  @override
  void navigateToLandingScreen() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoute.landingScreen, (x) => false);  }
}
