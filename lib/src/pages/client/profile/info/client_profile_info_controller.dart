import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';




class ClientProfileInfoController extends ControllerModel {

  var userSession =  Memory.getSavedUser().obs;

  void goToUpdatePage(BuildContext context) async {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_UPDATE_PAGE);
  }

  @override
  void signOut() {

    GetStorage().remove(Memory.KEY_SHOPPING_BAG);
    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

  void goToUpdatePasswordPage(BuildContext context) {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_UPDATE_PASSWORD_PAGE);
  }
}