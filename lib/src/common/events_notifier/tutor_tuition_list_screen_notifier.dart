
import '../config/app_event_widget.dart';

class TabTutorTuitionListScreenReloadNotifier  extends EventNotifier<bool> {
  TabTutorTuitionListScreenReloadNotifier._();
  static TabTutorTuitionListScreenReloadNotifier get instance=> _instance;
  static final TabTutorTuitionListScreenReloadNotifier _instance = TabTutorTuitionListScreenReloadNotifier._();


  ///Generate post likes key
  String get key =>"tutor_tuition_list_page_reload";
  ///notify count all the subscribers for update like count
  void notifyToReload() {
    notifyListeners(key,true);
  }
}