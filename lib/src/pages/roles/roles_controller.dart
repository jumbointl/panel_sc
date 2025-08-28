import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'package:solexpress_panel_sc/src/models/rol.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import '../../data/memory.dart';
class RolesController extends ControllerModel {

  late User user ;
  RolesController(){
    user = getSavedUser();
    saveFirebaseNotificationToken();


  }
  void goToPageRol(Rol rol) {
    Get.offNamedUntil(rol.route ?? Memory.ROUTE_HOME_PAGE, (route) => false);
  }

}