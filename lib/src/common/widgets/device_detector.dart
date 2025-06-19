import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DeviceDetector extends StatefulWidget {
  final Widget Function(BuildContext context, bool isTable, Size screenSize) builder;
  const DeviceDetector({Key? key,required this.builder}) : super(key: key);

  @override
  _DeviceDetectorState createState() => _DeviceDetectorState();
}

class _DeviceDetectorState extends State<DeviceDetector> {
  @override
  Widget build(BuildContext context) {
    bool isTablet = false;
    // final double devicePixelRatio = ui.window.devicePixelRatio;
    final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    final ui.Size size = ui.window.physicalSize;
    // final double width = size.width;
    // final double height = size.height;
    ///This implement logic changes for some samsung mobile phone
    /// Old logic are comment out
    if(data.size.shortestSide < 600 ){
      isTablet=false;
    }else{
      isTablet=true;
    }
    // if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
    //   isTablet = true;
    // }
    // else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
    //   isTablet = true;
    // }
    // else {
    //   isTablet = false;
    // }
    return widget.builder(context, isTablet, size);
  }
}
