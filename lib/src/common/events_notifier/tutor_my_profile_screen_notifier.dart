
import '../config/app_event_widget.dart';

class TabTutorMyProfileScreenReloadNotifier  extends EventNotifier<bool> {
  TabTutorMyProfileScreenReloadNotifier._();
  static TabTutorMyProfileScreenReloadNotifier get instance=> _instance;
  static final TabTutorMyProfileScreenReloadNotifier _instance = TabTutorMyProfileScreenReloadNotifier._();


  ///Generate post likes key
  String get key =>"tutor_my_profile_page_reload";
  ///notify count all the subscribers for update like count
  void notifyToReload() {
    notifyListeners(key,true);
  }
}