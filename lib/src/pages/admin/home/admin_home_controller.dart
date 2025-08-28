import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
class AdminHomePageController extends ControllerModel {
  var indexTab = 0.obs;

  AdminHomePageController();

  void changeTab(int index) {
    indexTab.value = index;
  }


}