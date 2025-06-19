import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utility/color_tools.dart';

mixin AppTheme {
  ThemeColor get clr => ThemeColor.instance;
  ThemeSize get size => ThemeSize.instance;
}

class ThemeColor {
  ThemeColor._();
  static ThemeColor? _instance;
  static ThemeColor get instance => _instance ?? (_instance = ThemeColor._());

  Color get appPrimaryColor => HexColor("F1841B");
  Color get backgroundColor => HexColor("FFFEFE");

  ///Solid Color
  Color get whiteColor => HexColor("FFFFFF");
  Color get whiteShadeColor => HexColor("FFFCFA");
  Color get blackColor => HexColor("000000");
  Color get primaryBlackColor => HexColor("1E1E1E");
  Color get grayColor => HexColor("FAFAFA");
  Color get strokeColor => HexColor("EAEAEA");
  Color get imageStroke => HexColor("FFCE9F");
  Color get imageStrokePurple => HexColor("4C31AE");

  Color get textColorGrayBold => HexColor("A6A6A6");
  Color get textColorBlack => HexColor("121212");
  Color get textColorBlack1 => HexColor("353739");
  Color get textColorBlack3 => HexColor("2B2A28");
  Color get textColorBlack4 => HexColor("232323");
  Color get textColorGray => HexColor("B8B8B8");
  Color get textColorGray2 => HexColor("D9D9D9");
  Color get textColorGray3 => HexColor("5E5E5E");
  Color get textColorGray4 => HexColor("969696");
  Color get textColorGray5 => HexColor("63676B");
  Color get inactiveTextColor => HexColor("939196");

  Color get indicatorColorGray => HexColor("DDDDEA");
  Color get dividerColorGray => HexColor("E8E8E8");

  Color get appBarStrokeColor => HexColor("BCB9EE");

  Color get buttonColor => HexColor("221E59");

  Color get iconColorGray => HexColor("797979");
  Color get termsColor => HexColor("6F6AC3");

  Color get inactiveBottomBarColor => HexColor("9DA0A7");
  Color get borderColor => HexColor("EDE9E9");
  Color get shadowColor => HexColor("636363");
  Color get appBarShadowColor => HexColor("2D2D2D");
  Color get borderColorGreen => HexColor("14AE5C");
  Color get progressBackground => HexColor("EDEBF0");
  Color get progressGrad1 => HexColor("6EC03C");
  Color get progressGrad2 => HexColor("FFFEFF");
  Color get progressGrayText => HexColor("747678");
  Color get progressPlaceHolderBg => HexColor("FFF2E5");
  Color get progressMenuText => HexColor("5C5C5C");
  Color get lessonRecordMenuBorderColor => HexColor("FFBA78");
  Color get lessonRecordMenuBg => HexColor("FEF0D6");
  Color get tabTextInactiveColor => HexColor("6B7280");
  Color get completionGray => HexColor("8D8D8D");
  Color get progressIndicatorBg => HexColor("DFDFDF");
}

class ThemeSize {
  ThemeSize._();
  static ThemeSize? _instance;
  static ThemeSize get instance => _instance ?? (_instance = ThemeSize._());
  double get textXXXLarge => 44.sp;
  double get textXXLarge => 36.sp;
  double get text32Large => 32.sp;
  double get textX28Large => 28.sp;
  double get textXLarge => 26.sp;
  double get text24Large => 24.sp;
  double get textLarge => 22.sp;
  double get textXMedium => 20.sp;
  double get textMedium => 18.sp;
  double get textSmall => 16.sp;
  double get textXSmall => 14.sp;
  double get textXXSmall => 12.sp;
  double get textXXXSmall => 10.sp;

  double get s1 => 1.w;
  double get s2 => 2.w;
  double get s4 => 4.w;
  double get s6 => 6.w;
  double get s8 => 8.w;
  double get s10 => 10.w;
  double get s12 => 12.w;
  double get s16 => 16.w;
  double get s18 => 18.w;
  double get s20 => 20.w;
  double get s24 => 24.w;
  double get s28 => 28.w;
  double get s26 => 26.w;
  double get s32 => 32.w;
  double get s40 => 40.w;
  double get s42 => 42.w;
  double get s48 => 48.w;
  double get s56 => 56.w;
  double get s64 => 64.w;
}

extension DoubleExtension on double {
  Widget get kHeight => SizedBox(height: toDouble());

  Widget get kWidth => SizedBox(width: toDouble());
}

