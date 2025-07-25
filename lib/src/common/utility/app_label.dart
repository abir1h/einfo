import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

///App Language
enum AppLanguage { english, bangla }

String label({required String e, required String b}) {
  return AppLabel.currentAppLanguage == AppLanguage.english
      ? (e.isNotEmpty ? e : b)
      : (b.isNotEmpty ? b : e);
}

class AppLabel {
  AppLabel._();
  static AppLabel? _app;
  static AppLabel get instance => _app ?? (_app = AppLabel._());

  //App Language
  static AppLanguage _appLanguage = AppLanguage.english;
  static AppLanguage get currentAppLanguage => _appLanguage;

  ///Set current language
  static Future<bool> setAppLanguage(int index) async {
    Completer<bool> completer = Completer();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("appLanguage", index).then((x) async {
        _appLanguage = index == 1 ? AppLanguage.english : AppLanguage.bangla;
        completer.complete(true);
        await getCurrentLanguage();
      }).catchError((x) {
        completer.completeError("Not storred !");
      });
    } catch (e) {
      completer.completeError("Not storred !");
    }
    return completer.future;
  }

  ///Get current language
  static Future<AppLanguage> getCurrentLanguage() async {
    Completer<AppLanguage> completer = Completer();
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? index = prefs.getInt("appLanguage");
      AppLanguage language =
          index == 1 ? AppLanguage.english : AppLanguage.bangla;
      _appLanguage = language;
      completer.complete(language);
    } catch (e) {
      //print(e);
      completer.complete(AppLanguage.bangla);
    }
    return completer.future;
  }
}
String convertMillisecondsToHMS(int milliseconds) {
  Duration duration = Duration(milliseconds: milliseconds);

  int hours = duration.inHours;
  int minutes = duration.inMinutes % 60;
  int seconds = duration.inSeconds % 60;

  return '${_twoDigits(hours)}:${_twoDigits(minutes)}:${_twoDigits(seconds)}';
}

String _twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}
String replaceEnglishNumberWithBengali(String inputString) {
  Map<String, String> numberMap = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  String result = '';
  for (int i = 0; i < inputString.length; i++) {
    String char = inputString[i];
    String replacement = numberMap[char] ?? char;
    result += replacement;
  }

  return result;
}

String timeAgoToBengali(String timeAgo) {
  // Define a map to store the mapping of English words to Bangla words
  final Map<String, String> banglaMap = {
    'january': 'জানুয়ারি',
    'february': 'ফেব্রুয়ারি',
    'march': 'মার্চ',
    'april': 'এপ্রিল',
    'may': 'মে',
    'june': 'জুন',
    'july': 'জুলাই',
    'august': 'আগস্ট',
    'september': 'সেপ্টেম্বর',
    'october': 'অক্টোবর',
    'november': 'নভেম্বর',
    'december': 'ডিসেম্বর',
    'seconds': 'সেকেন্ড',
    'minute': 'মিনিট',
    'minutes': 'মিনিট',
    'hour': 'ঘন্টা',
    'hours': 'ঘন্টা',
    'day': 'দিন',
    'days': 'দিন',
    'week': 'সপ্তাহ',
    'weeks': 'সপ্তাহ',
    'month': 'মাস',
    'months': 'মাস',
    'year': 'বছর',
    'years': 'বছর',
    'ago': 'আগে',
    'moment': 'কিছুক্ষণ',
    'about': 'প্রায়',
    'an': 'এক',
    'am': 'এম',
    'pm': 'পিএম',
    'a': '',
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  // Split the timeAgo string into words
  List<String> words = timeAgo.split(' ');

  // Replace English words with Bangla words using the map
  String banglaText = words.map((word) {
    // Check if the word is a number
    if (int.tryParse(word) != null) {
      // Convert each digit separately
      return word.split('').map((char) => banglaMap[char] ?? char).join('');
    }
    if (word == 'AM') {
      print(word);
    }
    return banglaMap[word.toLowerCase()] ?? word;
  }).join(' ');
  print(banglaText);

  return banglaText;
}

String nightDayConvertor(String timeAgo, String timstamp) {
  // Define a map to store the mapping of English words to Bangla words
  DateTime time = DateTime.parse(timstamp).toUtc();
  int hours = time.hour;

  String greeting = "";

  if (hours >= 1 && hours <= 12) {
    greeting = "সকাল";
  } else if (hours > 12 && hours <= 17) {
    greeting = "অপরাহ্ণ";
  } else if (hours > 17 && hours <= 20) {
    greeting = "সন্ধ্যা";
  } else if (hours > 20 && hours <= 24) {
    greeting = "রাত";
  }
  final Map<String, String> banglaMap = {
    'january': 'জানুয়ারি $greeting',
    'february': 'ফেব্রুয়ারি $greeting',
    'march': 'মার্চ $greeting',
    'april': 'এপ্রিল $greeting',
    'may': 'মে $greeting',
    'june': 'জুন $greeting',
    'july': 'জুলাই $greeting',
    'august': 'আগস্ট $greeting',
    'september': 'সেপ্টেম্বর $greeting',
    'october': 'অক্টোবর $greeting',
    'november': 'নভেম্বর $greeting',
    'december': 'ডিসেম্বর $greeting',
    'seconds': 'সেকেন্ড',
    'minute': 'মিনিট',
    'minutes': 'মিনিট',
    'hour': 'ঘন্টা',
    'hours': 'ঘন্টা',
    'day': 'দিন',
    'days': 'দিন',
    'week': 'সপ্তাহ',
    'weeks': 'সপ্তাহ',
    'month': 'মাস',
    'months': 'মাস',
    'year': 'বছর',
    'years': 'বছর',
    'ago': 'আগে',
    'moment': 'কিছুক্ষণ',
    'about': 'প্রায়',
    'an': 'এক',
    'am': '',
    'pm': '',
    'a': '',
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  // Split the timeAgo string into words
  List<String> words = timeAgo.split(' ');

  String banglaText = words.map((word) {
    if (int.tryParse(word) != null) {
      return word.split('').map((char) => banglaMap[char] ?? char).join('');
    }

    return banglaMap[word.toLowerCase()] ?? word;
  }).join(' ');

  return banglaText;
}

bool areSameDateFast(DateTime a) {
  DateTime now = DateTime.now();
  return a.day == now.day && a.month == now.month && a.year == now.year;
}

Future<void> onLaunchUrl(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

String getDateRange(DateTime startDate, DateTime endDate) {
  // Define the day format
  String dayFormat(int day) => day.toString().padLeft(2, '0');

  // Check if both dates are in the same month and year
  if (startDate.month == endDate.month && startDate.year == endDate.year) {
    return "${dayFormat(startDate.day)} - ${dayFormat(endDate.day)} ${getMonthName(startDate.month)}";
  } else {
    return "${dayFormat(startDate.day)} ${getMonthName(startDate.month)} - ${dayFormat(endDate.day)} ${getMonthName(endDate.month)}";
  }
}

String getMonthName(int month) {
  const monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return monthNames[month - 1];
}
