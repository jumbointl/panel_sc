


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import 'client_profile_update_password_controller.dart';

class ClientProfileUpdatePasswordPage extends StatelessWidget {
  ClientProfileUpdatePasswordController controller = Get.put(ClientProfileUpdatePasswordController());

  ClientProfileUpdatePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          actions: [
            controller.buttonSignOut(),
          ],
        ) ,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),

          ],
        ),
    );
  }
  Widget _backgroundCover(BuildContext context){

    return SafeArea(
      child: Container(
        //alignment: Alignment.topCenter,
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.35,
        color: Colors.amber,

      ),
    );
  }
  Widget _boxForm(BuildContext context){
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height*0.55,
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.only(top: 250,
          left: 20,right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75),
            )
          ]
      ),
      child: Obx(() =>SingleChildScrollView(
        child: Column(
          children: [
            _title(),
            _textFieldOldPassword(),
            _textFieldNewPassword(),
            _textFieldRetypePassword(),
            _buttonUpdate(context),
          ],
        ),
      ),
    ));

  }
  Widget _buttonUpdate(BuildContext context){
    return Container(
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: IconButton(
        icon: controller.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.UPDATE_PASSWORD),
        onPressed: () => controller.isLoading.value ? null : controller.updatePassword(context),
        tooltip: controller.isLoading.value ? Messages.LOADING
            : Messages.UPDATE_PASSWORD,
        style: IconButton.styleFrom(
          backgroundColor: controller.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        ),
      ),
    );

  }


  Widget _textFieldOldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextField(
            obscureText:  controller.showPassword.value ? false : true,
            controller: controller.oldPasswordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: Messages.OLD_PASSWORD,
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Checkbox(
                //tristate: true, // Example with tristate
                value: controller.showPassword.value,
                onChanged: (bool? newValue) {
                  if(newValue!=null){
                    controller.setShowPassword(newValue);
                  }
                },
              ),
              SizedBox(width: 6,),
              Text(Messages.SHOW_PASSWORD),
            ],
          ),
        ],
      ),
    );
  }
  Widget _textFieldNewPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        obscureText: controller.showNewPassword.value ? false : true,
        controller: controller.newPasswordController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.NEW_PASSWORD,
          prefixIcon: Icon(Icons.person),
        ),
      ),
    );
  }
  Widget _textFieldRetypePassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          TextField(
            obscureText: controller.showNewPassword.value ? false : true,
            controller: controller.retypeNewPasswordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: Messages.RETYPE_NEW_PASSWORD,
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Checkbox(
                //tristate: true, // Example with tristate
                value: controller.showNewPassword.value,
                onChanged: (bool? newValue) {
                  if(newValue!=null){
                    controller.setShowNewPassword(newValue);
                  }
                },
              ),
              SizedBox(width: 6,),
              Text(Messages.SHOW_PASSWORD),
            ],
          ),
        ],
      ),

    );
  }

  Widget _title(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 30),
        //child: Text('${controller.userSession.name ?? Datas.NULL_FILE} ${controller.userSession.lastname ?? Datas.NULL_FILE}',
        child: Text(Memory.CHANGE_PASSWORD,
          style: TextStyle(color: Colors.black),));
  }


  Widget _imageUser(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
            child: Container(
              child: CircleAvatar(
                backgroundImage: controller.imageFile!=null
                    ? FileImage(controller.imageFile!)
                    : controller.userSession.image!=null
                    ? NetworkImage(controller.userSession.image!)
                    : AssetImage(Memory.IMAGE_USER_PROFILE) ,
                radius: Memory.RADIO_IMAGE_USER,
                backgroundColor: Colors.white,
              ),)


      ),
    );
  }





}
