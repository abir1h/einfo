class ImageAssets {
  const ImageAssets._();

  //:::::::::::::::::: IMAGE SETS ::::::::::::::::::
  static String get logo => 'logo'.svg;
  static String get logoVertical => 'logo_vertical'.svg;
  static String get logoHorizontal => 'logo_horizontal'.svg;
  static String get splashBg => 'splashBG'.svg;
  static String get student => 'student'.svg;
  static String get tutor => 'tutor'.svg;
  static String get superAdmin => 'super_admin'.svg;
  static String get schoolAdmin => 'school_admin'.svg;
  static String get home => 'home'.svg;
  static String get homeFilled => 'home_filled'.svg;
  static String get person => 'home'.svg;
  static String get personFilled => 'home_filled'.svg;
  static String get category => 'home'.svg;
  static String get categoryFilled => 'home_filled'.svg;
  static String get cart => 'home'.svg;
  static String get cartFilled => 'home_filled'.svg;
  static String get sliderImage => 'slider_image'.png;
  static String get checkCircle => 'checkCircle'.svg;
  static String get cal => 'cal'.svg;
  static String get clock => 'clock'.svg;
  static String get not => 'not'.svg;
  static String get search => 'search'.svg;
  static String get profile => 'profile'.svg;
  static String get profileFilled => 'profile_filled'.svg;
  static String get progress => 'progress'.svg;
  static String get progressFilled => 'progressFilled'.svg;
  static String get learn => 'learn'.svg;
  static String get learnFilled => 'learnFilled'.svg;
  static String get courseCard => 'courseCard'.png;
  static String get progres => 'progres'.png;
  static String get courseProgress => 'course_progress'.svg;
  static String get mock => 'mock'.svg;
  static String get records => 'records'.svg;
  static String get studyHours => 'study_hours'.svg;
  static String get logoApp => 'logoIc'.png;
}

extension on String {
  String get png => 'assets/images/$this.png';
  String get jpg => 'assets/images/$this.jpg';
  String get svg => 'assets/images/$this.svg';
  String get json => 'assets/images/$this.json';
}
