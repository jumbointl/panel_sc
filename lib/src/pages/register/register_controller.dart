import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'package:solexpress_panel_sc/src/providers/users_provider.dart';

import '../../data/memory.dart';
import '../common/controller_model.dart';



class RegisterController extends ControllerModel {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  TextEditingController confirmPasswordController= TextEditingController();
  UsersProvider usersPrivider = UsersProvider();


  goToRootPage() {
    Get.toNamed(Memory.ROUTE_LOGIN_PAGE);
  }
  void register(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String  name = nameController.text.trim();
    String  lastName = lastNameController.text.trim();
    String  phone = phoneController.text.trim();
    String  confirmPassword= confirmPasswordController.text.trim();

    if(isValidForm(email, password,name,lastName,phone,confirmPassword)){

      User newUser = User(
        email: email,
        password: password,
        name: name,
        lastname: lastName,
        phone: phone,
        extensionImage: getExtension(imageFile!.path),
      );
      isLoading.value = true;
      ResponseApi responseApi = await usersPrivider.createWithImage(context,newUser, imageFile!);
      isLoading.value = false;
      if(responseApi.success!=null && responseApi.success!){
        saveUser(responseApi, password);
        User myUser =getSavedUser();
        if (myUser.roles!.length > 1) {

          for(int i=0; i < myUser.roles!.length; i++){

            switch ( myUser.roles![i].id) {
              case 1:
                myUser.roles![i] = Memory.ROL_ADMIN;
                break;
              case 2:
                myUser.roles![i] = Memory.ROL_DELIVERY_MAN;
                break;
              case 3:
                myUser.roles![i] = Memory.ROL_CLIENT;
                break;
              case 4:
                myUser.roles![i] = Memory.ROL_ORDERSPICKER;
                break;

            }

          }

          goToRolesPage();
        }
        else { // SOLO UN ROL

          goToClientProductPage();
        }

      }


    }
  }

  bool isValidForm(String email, String password, String name, String lastName,
      String phone, String confirmPassword){
    if(email.isEmpty || !GetUtils.isEmail(email)){
      showErrorMessages(Messages.EMAIL);
      return false;
    }
    if(name.isEmpty){
      showErrorMessages(Messages.NAME);
      return false;
    }
    if(lastName.isEmpty){
      showErrorMessages(Messages.LAST_NAME);
      return false;
    }
    if(phone.isEmpty){
      showErrorMessages(Messages.PHONE);
      return false;
    }


    if(password.isEmpty || confirmPassword.isEmpty || password!=confirmPassword){
      showErrorMessages(Messages.ERROR_PASSWORD);
      return false;
    }

    if(imageFile==null){
     showErrorMessages(Messages.ERROR_IMAGE);
      return false;
    }
    return true;
  }


}