import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_theme.dart';

class EmptyWidget extends StatelessWidget with AppTheme {
  final String message;
  final IconData icon;
  const EmptyWidget(
      {super.key, required this.message, this.icon = Icons.weekend_outlined});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1.sw,
      height: double.maxFinite,
      child: Padding(
        padding: EdgeInsets.all(size.s24),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: size.s64 * 1.3,
                color: clr.textColorBlack.withOpacity(.26),
              ),
              SizedBox(
                height: size.s8,
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: size.textMedium,
                  color: clr.textColorBlack.withOpacity(.1),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: size.s32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
