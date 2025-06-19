
import '../config/app_event_widget.dart';

class TabTutorFindTuitionScreenReloadNotifier  extends EventNotifier<bool> {
  TabTutorFindTuitionScreenReloadNotifier._();
  static TabTutorFindTuitionScreenReloadNotifier get instance=> _instance;
  static final TabTutorFindTuitionScreenReloadNotifier _instance = TabTutorFindTuitionScreenReloadNotifier._();


  ///Generate post likes key
  String get key =>"tutor_find_tuition_page_reload";
  ///notify count all the subscribers for update like count
  void notifyToReload() {
    notifyListeners(key,true);
  }
}