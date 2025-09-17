import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/attendance/common/panel_controller_model.dart';
class AdminAttendanceHomeController extends PanelControllerModel {

  var indexTab = 0.obs;
  void changeTab(int index) {
    indexTab.value = index;
  }

}