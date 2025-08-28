import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/memory.dart';
import '../../../data/messages.dart';
import '../../../models/host.dart';
import 'idempiere_login_controller.dart';

class IdempiereLoginPage extends StatelessWidget {
  Color hoverColor = Colors.amber[200]!;
  IdempiereLoginPage({super.key});
  final IdempiereLoginController controller = Get.put(IdempiereLoginController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.autoLogin.value) {
        controller.login(context);
      }
    });
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: _textAppName(),
           
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: _setCustomUrl(),
        ), // Pass controller
        
        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: _boxForm(context), ),
      )
    );
  }

  Widget _boxForm(BuildContext context){ // Add controller and showIcon parameters
    double formHeight = 450;
    return Container(
      height: formHeight,
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.only(top: 50,
      left: 20,right: 20),
      color: Colors.white,

        child:  Obx(() =>SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              spacing: 3,
              children: [
                TextField(
                  controller: controller.passwordController,
                  obscureText: controller.showPassword.value ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.PASSWORD,
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                TextField(
                  controller: controller.userNameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.NAME,
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ), // Pass controller
                TextField(
                  controller: controller.passwordController,
                  obscureText: controller.showPassword.value ? false : true,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
            
                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.PASSWORD,
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
                Row(
                  spacing: 6,
                  children: [
                    Checkbox(
                      value: controller.showPassword.value,
                      hoverColor: hoverColor,
                      onChanged: (bool? newValue) {
                        if(newValue!=null){
                          controller.setShowPassword(newValue);
            
                        }
                      },
                    ),
                    Text(Messages.SHOW_PASSWORD,
                      style: TextStyle(
                          color: Colors.black
                      ),),
                  ],
                ),
                _dropDownHosts(),
                Row(
                  spacing: 6,
                  children: [
            
                    Checkbox(
                      //tristate: true, // Example with tristate
                      value: controller.autoLogin.value,
                      hoverColor: hoverColor,
                      onChanged: (bool? newValue) {
                        if(newValue!=null){
                          controller.setAutoLogin(newValue);
                        }
                      },
                    ),
                    Text(Messages.AUTO_LOGIN,
                        style: TextStyle(
                            color: Colors.black)),
                  ],
                ),
                IconButton(
                  hoverColor: hoverColor,
                  icon: controller.isLoading.value
                      ? CircularProgressIndicator(color: Colors.redAccent)
                      : Text(Messages.LOGIN),
                  onPressed: () => controller.login(context),
                  tooltip: controller.isLoading.value ? Messages.LOADING
                      : Messages.LOGIN,
                  style: IconButton.styleFrom(
                    backgroundColor: controller.isLoading.value
                        ? Colors.amber
                        : Memory.PRIMARY_COLOR,
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                  ),
                )],
            ),
          ),
        )),

    );

  } // Pass controller

  Widget _textAppName(){
    // No controller needed for this widget
    return Text(Messages.IDEMPIERE_APP_NAME,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black
      ),
    );
  }
  Widget _setCustomUrl(){ // Pass controller
    return GestureDetector(
      onLongPress: ()=>controller.goToSetUrlPage(),
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 30),
        child: Text(Messages.SET_CUSTOM_URL,
          style: TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold, fontSize: 17),),
      ),
    );
  }
  Widget _dropDownHosts() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      //margin: EdgeInsets.only(top: 10),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_HOST,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsHost(Memory.listHost),
        value: controller.idHost.value == '' ? null : controller.idHost.value,
        onChanged: (option) {
          controller.setHost(option.toString());
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsHost(List<Host> hosts) {
    List<DropdownMenuItem<String>> list = [];
    for (var host in hosts) {
      list.add(DropdownMenuItem(
        value: host.id.toString(),
        child: Text(host.name ?? ''),
      ));
    }

    return list;
  }
}