import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'package:solexpress_panel_sc/src/providers/users_provider.dart';
import 'package:solexpress_panel_sc/src/utils/image/tool/redrawable.dart';

import '../../../../data/messages.dart';
import '../../../../models/data_for_renew_user.dart';
import '../../../common/controller_model.dart';


class ClientProfileUpdatePasswordController extends ControllerModel implements Redrawable {
  TextEditingController oldPasswordController= TextEditingController();
  TextEditingController newPasswordController= TextEditingController();
  TextEditingController retypeNewPasswordController= TextEditingController();
  User userSession = Memory.getSavedUser();
  UsersProvider usersProvider = UsersProvider();
  var showPassword = false.obs;

  var showNewPassword = false.obs;

  void updatePassword(BuildContext context) async {

    String  oldPassword = oldPasswordController.text.trim();
    String  newPassword = newPasswordController.text.trim();
    String  retypedPassword = retypeNewPasswordController.text.trim();

    if(isValidForm(oldPassword,newPassword,
        retypedPassword)){

      DataForRenewUser data = DataForRenewUser(
        id: userSession.id,
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      //print('Response user create ${response.body}');
      isLoading.value = true;
      DataForRenewUser data2 = await usersProvider.updatePassword(context,data);
      isLoading.value = false;
      if(data2.success!=null){
        saveUser(userSession,newPassword);
        Get.offNamedUntil(Memory.ROUTE_USER_PROFILE_INFO_PAGE, (route)=>false);
      }
    }
  }
  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }
  bool isValidForm(String oldPassword,String newPassword,
      String retypedPassword){

    if(oldPassword.isEmpty){
      showErrorMessages(Messages.PASSWORD);
      return false;
    }
    if(newPassword.isEmpty){
      showErrorMessages( Messages.NEW_PASSWORD);
      return false;
    }
    if(retypedPassword.isEmpty){
      showErrorMessages(Messages.RETYPE_NEW_PASSWORD);
      return false;
    }

    if(retypedPassword != newPassword){
      showErrorMessages(Messages.PASSWORDS_DO_NOT_MATCH);
      return false;
    }

    return true;
  }



  @override
  void redrawImage() {
    // TODO: implement redrawImage
    if(imageFile!=null){
      update();
    }

  }

  void setShowPassword(bool newValue) {
    showPassword.value = newValue;
    update();
  }

  void setShowNewPassword(bool newValue) {
    showNewPassword.value = newValue;
    update();
  }




}