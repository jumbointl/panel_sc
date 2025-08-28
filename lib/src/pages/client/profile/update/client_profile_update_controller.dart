import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'package:solexpress_panel_sc/src/providers/users_provider.dart';
import 'package:solexpress_panel_sc/src/utils/image/tool/redrawable.dart';

import '../../../../data/messages.dart';
import '../../../common/controller_model.dart';
import '../info/client_profile_info_controller.dart';


class ClientProfileUpdateController extends ControllerModel implements Redrawable {
  TextEditingController nameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  User userSession = Memory.getSavedUser();
  UsersProvider usersPrivider = UsersProvider();
  ClientProfileInfoController clientInfoController = Get.find();
  ClientProfileUpdateController(){
    nameController.text = userSession.name ?? '';
    lastNameController.text = userSession.lastname ?? '';
    phoneController.text = userSession.phone ?? '';
  }

  void _updateWithImage(BuildContext context) async {

    String  name = nameController.text.trim();
    String  lastName = lastNameController.text.trim();
    String  phone = phoneController.text.trim();
    String?  password = userSession.password;

    if(isValidForm(name,lastName,phone)){

      User newUser = User(
        id: userSession.id,
        name: name,
        lastname: lastName,
        phone: phone,
        sessionToken: userSession.sessionToken,
        extensionImage: getExtension(imageFile!.path),
      );
      if(userSession.image!=null){
        newUser.imageToDelete = getFirebaseFileName(userSession.image!);
        //print('Image to delete ${newUser.imageToDelete!}');
      }
      isLoading.value = true;
      Stream? stream = await usersPrivider.updateWithImage(context,newUser, imageFile!);
      isLoading.value = false;
      if(stream!=null){
        stream.listen((res){

          ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
          if(responseApi.success==null || !responseApi.success!){
            if (responseApi.message == 401) {
              showErrorMessages('${Messages.ERROR}, ${Messages.ERROR_UNAUTHORIZED}');
              return ;
            }
            showErrorMessages('${Messages.ERROR_REGISTER}, ${Messages.EMPTY}');

          } else {
            saveUser(responseApi,password);
            showSuccessMessages('${Messages.UPDATE_DATAS}, ${Messages.SUCCESS}');
            clientInfoController.userSession.value =  Memory.getSavedUser();
            userSession  =  Memory.getSavedUser();
            imageFile = null;
            update();
          }

        });
      }
    }
  }
  void updateInfo(BuildContext context) async {
    imageFile==null ? _updateWithoutImage(context)
        : _updateWithImage(context);
  }
  void _updateWithoutImage(BuildContext context) async {

    String  name = nameController.text.trim();
    String  lastName = lastNameController.text.trim();
    String  phone = phoneController.text.trim();

    if(isValidForm(name,lastName,phone)){

      User newUser = User(
        id: userSession.id,
        name: name,
        lastname: lastName,
        phone: phone,
        sessionToken: userSession.sessionToken,
      );
      //print('Response user create ${response.body}');
      isLoading.value = true;
      ResponseApi responseApi = await usersPrivider.updateWithoutImage(newUser);
      isLoading.value = false;
      if(responseApi.success==null || !responseApi.success!){
        showErrorMessages(responseApi.message ?? Messages.EMPTY);

      } else {
        saveUser(responseApi, userSession.password);
        clientInfoController.userSession.value = getSavedUser();
        userSession  = clientInfoController.userSession.value;
        update();
      }
    }
  }
  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }
  bool isValidForm(String name, String lastName,String phone){

    if(name.isEmpty){
      Get.snackbar(Messages.FIELD_ERROR, Messages.NAME);
      return false;
    }
    if(lastName.isEmpty){
      Get.snackbar(Messages.FIELD_ERROR, Messages.LAST_NAME);
      return false;
    }
    if(phone.isEmpty){
      Get.snackbar(Messages.FIELD_ERROR, Messages.PHONE);
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

  void goToUpdatePasswordPage(BuildContext context) {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_UPDATE_PASSWORD_PAGE);
  }



}