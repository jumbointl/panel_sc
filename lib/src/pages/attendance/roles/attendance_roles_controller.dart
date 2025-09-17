import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/rol.dart';
import '../../../data/memory.dart';
import '../common/panel_controller_model.dart';
class AttendanceRolesController extends PanelControllerModel {
  List<Rol> roles = <Rol>[].obs;


  AttendanceRolesController();
  void goToPageRol(Rol rol) {
    Get.offNamedUntil(rol.route ?? Memory.ROUTE_HOME_PAGE, (route) => false);
  }

}