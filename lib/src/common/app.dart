import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/constants/common_imports.dart';
import '../common/routes/app_route.dart';



class Application extends StatelessWidget with AppTheme {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return ScreenUtilInit(
        designSize: const Size(1024, 768),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'BB Tutor',
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch()
                    .copyWith(primary: clr.appPrimaryColor),
                scaffoldBackgroundColor: clr.backgroundColor,
                dividerColor: Colors.transparent,
                fontFamily: StringData.fontFamilyRoboto,
                canvasColor: Colors.transparent),
            navigatorKey: AppRoute.navigatorKey,
            onGenerateRoute: RouteGenerator.generate,
          );
        });
  }
}
