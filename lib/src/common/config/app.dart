import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_entity.dart';

class App {
  App._();
  static App? _app;
  static App get instance => _app ?? (_app = App._());

  ///App Session
  static UserSession _session = UserSession.empty();
  static UserSession get currentSession => _session;
  static bool isOnboarded = false;

  static Future<UserSession> getCurrentSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getString("session_data");
    if (data != null && data.isNotEmpty) {
      _session = UserSession.fromJson(jsonDecode(data));
    }
    return Future.value(_session);
  }
  static Future setOnboardUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboard', true);
  }  static Future<bool> getOnboardUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getBool("isOnboard");
    if (data != null && data) {
      isOnboarded = data;
    }
    return Future.value(isOnboarded);
  }
  static Future<UserSession> setCurrentSession(UserSession session) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_data', jsonEncode(session.toJson()));
    return getCurrentSession();
  }

  static Future<void> logOut() async {
    await App.setCurrentSession(UserSession.empty());
  }
}
