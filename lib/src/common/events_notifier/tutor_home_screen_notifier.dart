
import '../config/app_event_widget.dart';

class TabTutorHomeScreenReloadNotifier  extends EventNotifier<bool> {
  TabTutorHomeScreenReloadNotifier._();
  static TabTutorHomeScreenReloadNotifier get instance=> _instance;
  static final TabTutorHomeScreenReloadNotifier _instance = TabTutorHomeScreenReloadNotifier._();


  ///Generate post likes key
  String get key =>"tutor_home_page_reload";
  ///notify count all the subscribers for update like count
  void notifyToReload() {
    notifyListeners(key,true);
  }
}