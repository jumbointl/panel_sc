


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/ui/ui_tools.dart';
import './client_profile_update_controller.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';

class ClientProfileUpdatePage extends StatelessWidget {
  ClientProfileUpdateController controller = Get.put(ClientProfileUpdateController());

  ClientProfileUpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.topCenter,

          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            UiTools.getButtomSignOut(),
            _bottomBack(),

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _buttonUpdate(context),
            _bottomUpdatePassword(context),
          ],
        ),
      ),
    );

  }
  Widget _buttonUpdate(BuildContext context){
    return Container(
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: IconButton(
    icon: controller.isLoading.value
    ? CircularProgressIndicator(color: Colors.redAccent)
        : Text(Messages.UPDATE_DATAS),
    onPressed: () => controller.isLoading.value ? null : controller.updateInfo(context),
    tooltip: controller.isLoading.value ? Messages.LOADING
        : Messages.UPDATE_DATAS,
    style: IconButton.styleFrom(
    backgroundColor: controller.isLoading.value
    ? Memory.PRIMARY_COLOR
        : Memory.BAR_BACKGROUND_COLOR,
    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
    ),
    ));

  }
  Widget _bottomUpdatePassword(BuildContext context){
    return Container(
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: ElevatedButton(onPressed: ()=>controller.goToUpdatePasswordPage(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:Memory.PRIMARY_COLOR,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(Messages.UPDATE_PASSWORD,
            style: TextStyle(color: Colors.black),
          )),
    );

  }


  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.NAME,
          prefixIcon: Icon(Icons.person),
        ),
      ),
    );
  }
  Widget _textFieldLastName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.lastNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.LAST_NAME,
          prefixIcon: Icon(Icons.person_outlined),
        ),
      ),
    );
  }
  Widget _textFieldPhone(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: Messages.PHONE,
          prefixIcon: Icon(Icons.phone),
        ),
      ),
    );
  }


  Widget _textYourInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 30),
        //child: Text('${controller.userSession.name ?? Datas.NULL_FILE} ${controller.userSession.lastname ?? Datas.NULL_FILE}',
        child: Text(Memory.USER_INFO,
          style: TextStyle(color: Colors.black),));
  }
  Widget _bottomBack(){
    return SafeArea(child: Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, left: 20),

      child: IconButton(onPressed: ()=>Get.back(),
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }

  Widget _imageUser(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        child: GestureDetector(
            onTap: ()=> controller.goToImageToolPage(),
            child: GetBuilder<ClientProfileUpdateController>(
              builder: (value)=>CircleAvatar(
                backgroundImage: controller.imageFile!=null
                    ? FileImage(controller.imageFile!)
                    : controller.userSession.image!=null
                    ? NetworkImage(controller.userSession.image!)
                    : AssetImage(Memory.IMAGE_USER_PROFILE) ,
                radius: Memory.RADIO_IMAGE_USER,
                backgroundColor: Colors.white,
              ),)
        ),

      ),
    );
  }





}
