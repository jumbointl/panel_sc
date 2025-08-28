import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/memory.dart';
class AdminOrdersListController extends GetxController {
  void signOut() {

    GetStorage().remove(Memory.KEY_SHOPPING_BAG);
    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }
}