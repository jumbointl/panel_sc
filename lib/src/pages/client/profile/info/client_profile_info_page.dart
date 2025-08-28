
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/ui/ui_tools.dart';
import './client_profile_info_controller.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';

class ClientProfileInfoPage extends StatelessWidget {
  ClientProfileInfoController controller = Get.put(ClientProfileInfoController());

  ClientProfileInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(()=> Stack(
          alignment: Alignment.topCenter,
          children: [
            _backgroundCover(context),
            _boxForm(context),
            _imageUser(context),
            UiTools.getButtomSignOut(),
            _bottomBack(),

          ],
        )),
    );
  }

  Widget _backgroundCover(BuildContext context){

    return SafeArea(
      child: Container(
        alignment: Alignment.topCenter,
        //width: controller.getMaximumInputFieldWidth(context),
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.35,
        color: Memory.PRIMARY_COLOR,

      ),
    );
  }
  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.5,
      //width: double.infinity,
      width: controller.getMaximumInputFieldWidth(context),
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 250,
          left: 25,right: 25),
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
            _textName(),
            _textEmail(),
            _textPhone(),
            _bottomUpdate(context),
          ],
        ),
      ),
    );

  }
  Widget _bottomUpdate(BuildContext context){
    return Container(
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: ElevatedButton(onPressed: ()=>controller.goToUpdatePage(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:Memory.PRIMARY_COLOR,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(Messages.UPDATE_DATAS,
            style: TextStyle(color: Colors.black),
          )),
    );

  }

  Widget _textEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child:ListTile(
        leading: Icon(Icons.email),
        title: Text(controller.userSession.value.email ?? Memory.NULL_FILE),
        subtitle: Text(Messages.EMAIL),
      )

    );
  }
  Widget _textName(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child:ListTile(
          leading: Icon(Icons.person),
          title: Text('${controller.userSession.value.name ?? Memory.NULL_FILE} ${controller.userSession.value.lastname ?? Memory.NULL_FILE}'),
          subtitle: Text('${Messages.NAME} ${Messages.LAST_NAME}'),
        )

    );
  }

  Widget _textPhone(){
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child:ListTile(
          leading: Icon(Icons.phone),
          title: Text(controller.userSession.value.phone ?? Memory.NULL_FILE),
          subtitle: Text(Messages.PHONE),
        )

    );
  }


  Widget _textYourInfo(){
    return Container(
        margin: EdgeInsets.only(top: 10,bottom: 20),
        child: Text(Memory.USER_INFO,
          style: TextStyle(color: Colors.black),));
  }
  Widget _imageUser(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        child: CircleAvatar(
          backgroundImage: controller.userSession.value.image!=null
              ? NetworkImage(controller.userSession.value.image!)
              : AssetImage(Memory.IMAGE_USER_PROFILE) ,
          radius: Memory.RADIO_IMAGE_USER,
          backgroundColor: Colors.white,
        ),)


    );
  }

  Widget _bottomBack(){
    return SafeArea(child: Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(top: 10, left: 20),

      child: IconButton(onPressed: ()=>Get.toNamed(Memory.ROUTE_ROLES_PAGE),
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }

}
