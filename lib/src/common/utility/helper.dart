import 'file_signature.dart';

class Helper {
  Helper._();
  static Helper? _helper;
  static Helper get instance => _helper ?? (_helper = Helper._());

  static getFileExtension(List<int> headerBytes) async {
    // final bytes = await file.readAsBytes();
    final matcher = FileSignatureMatcher();
    final List<FileExtension>? matchedExtensions =
        matcher.getFileExtension(headerBytes: headerBytes);
    // Some file formats shares the same extensions, such as doc and docx
    print('Matched extensions: ${matchedExtensions.toString()}');
  }

  static String secondToMin(int secTime) {
    String getParsedTime(String time) {
      if (time.length <= 1) return "0$time";
      return time;
    }

    int min = secTime ~/ 60;
    int sec = secTime % 60;

    String parsedTime =
        "${getParsedTime(min.toString())} : ${getParsedTime(sec.toString())}";

    return parsedTime;
  }

  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
  static String formatDurationTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (duration.isNegative) {
      return "Already Expired";
    }

    if (duration.inDays > 0) {
      String days = duration.inDays.toString();
      String hours = twoDigits(duration.inHours.remainder(24));
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      return "$days Days, $hours Hours & $minutes Minutes left";
    } else if (duration.inHours > 0) {
      String hours = twoDigits(duration.inHours);
      String minutes = twoDigits(duration.inMinutes.remainder(60));
      return "$hours Hours & $minutes Minutes left";
    } else {
      String minutes = twoDigits(duration.inMinutes);
      String seconds = twoDigits(duration.inSeconds.remainder(60));
      return "$minutes Minutes & $seconds Seconds left";
    }
  }

  static String maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length < 6) {
      return phoneNumber;
    }

    final start = phoneNumber.substring(0, 3);
    final end = phoneNumber.substring(phoneNumber.length - 2);

    return '$start*****$end';
  }

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) {
      return email;
    }

    final localPart = parts[0];
    final domainPart = parts[1];

    final maskedLocalPart = localPart.length > 3
        ? '${localPart.substring(0, 3)}*****'
        : '$localPart*****';

    return '$maskedLocalPart@$domainPart';
  }
}
