import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import '../../data/memory.dart';
class HomeController extends GetxController {

  late User user ;

  HomeController(){
    user = Memory.getSavedUser();
  }

  void signOut() {

    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}