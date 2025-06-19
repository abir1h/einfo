import '../config/app_event_widget.dart';

class TutorUserLandingScreenReloadNotifier extends EventNotifier<bool> {
  TutorUserLandingScreenReloadNotifier._();
  static TutorUserLandingScreenReloadNotifier get instance => _instance;
  static final TutorUserLandingScreenReloadNotifier _instance =
      TutorUserLandingScreenReloadNotifier._();

  String get key => "tutor_user_landing_page_reload";

  void notifyToReload() {
    notifyListeners(key, true);
  }
}
