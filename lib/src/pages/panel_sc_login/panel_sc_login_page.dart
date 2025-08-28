import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/function_panel_sc.dart';
import '../../data/memory.dart';
import '../../data/memory_panel_sc.dart';
import 'panel_sc_login_controller.dart';

import '../../data/messages.dart';
import '../../models/host.dart';

class PanelScLoginPage extends StatelessWidget {
  Color hoverColor = Colors.amber[200]!;
  PanelScLoginPage({super.key});
  final PanelScLoginController controller = Get.put(PanelScLoginController());

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.stopTimers();
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
       /* bottomNavigationBar: SizedBox(
          height: 50,
          child: _setCustomUrl(),
        ), */// Pass controller

        body: SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Obx(() =>_boxForm(context), )),
      )
    );
  }

  Widget _boxForm(BuildContext context){ // Add controller and showIcon parameters
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double formHeight = MediaQuery.of(context).size.height * 0.8;
    if(controller.attendancePanel.value){
      return Container(
        height: formHeight,
        width: controller.getMaximumInputFieldWidth(context),
        margin: EdgeInsets.only(top: 10,
            left: 20,right: 20),
        color: Colors.white,

        child:  SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 3,
            children: [
              TextField(
                controller: controller.panelIdController,
                obscureText: false,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(

                  filled: true,
                  fillColor: Colors.white,
                  hintText: Messages.ID,
                  prefixIcon: Icon(Icons.numbers),
                  border: OutlineInputBorder(),
                ),
              ),
              _dropDownFunction(),

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
              Row(
                spacing: 6,
                children: [

                  Checkbox(
                    //tristate: true, // Example with tristate
                    value: controller.isTestMode.value,
                    hoverColor: hoverColor,
                    onChanged: (bool? newValue) {
                      if(newValue!=null){
                        controller.setTestMode(newValue);
                      }
                    },
                  ),
                  Text(Messages.TEST_MODE,
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
              ),

            ],
          ),
        ),

      );

    }




    return Container(
      height: formHeight,
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.only(top: 10,
      left: 20,right: 20),
      color: Colors.white,

        child:  SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 3,
          children: [
            TextField(
              controller: controller.panelIdController,
              obscureText: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(

                filled: true,
                fillColor: Colors.white,
                hintText: Messages.ID,
                prefixIcon: Icon(Icons.numbers),
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
            /*Row(
              children: [
                Text(Messages.FILE_HOST,
                  style: TextStyle(
                      color: Colors.black
                  ),),
                _dropDownHosts(),
              ],
            ),*/
            _dropDownHosts(context),
            _dropDownFileHosts(context),
            _dropDownFunction(),

            isLandscape ? Row(
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
                Checkbox(
                  value: controller.onlyTv.value,
                  hoverColor: hoverColor,
                  onChanged: (bool? newValue) {
                    if(newValue!=null){
                      controller.setOnlyTv(newValue);

                    }
                  },
                ),
                Text(Messages.ONLY_TV,
                  style: TextStyle(
                      color: Colors.black
                  ),),
              ],
            ) : Column(
              children: [
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
                Row(
                  spacing: 6,
                  children: [
                    Checkbox(
                      value: controller.onlyTv.value,
                      hoverColor: hoverColor,
                      onChanged: (bool? newValue) {
                        if(newValue!=null){
                          controller.setOnlyTv(newValue);

                        }
                      },
                    ),
                    Text(Messages.ONLY_TV,
                      style: TextStyle(
                          color: Colors.black
                      ),),
                  ],
                )
              ]

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
            ),

          ],
        ),
                  ),

    );

  } // Pass controller

  Widget _textAppName(){
    // No controller needed for this widget
    String title = Messages.IDEMPIERE_APP_NAME;
    switch(Memory.TYPE_OF_PANEL){
      case Memory.EVENT_PANEL:
        title = Messages.ATTENDANCE_PANEL;

        break;
      case Memory.SC_PANEL:
        title = Messages.PANEL_SC;
        break;

    }


    return Text(title,
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
  Widget _dropDownFunction() {
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
          Messages.SELECT_A_FUNCTION,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        items: _dropDownItemsFunction(MemoryPanelSc.getListFunctionPanelSc()),
        value: controller.idFunction.value == '' ? null : controller.idFunction.value,
        icon: Icon(Icons.category),
        onChanged: (option) {
          controller.setFunction(option.toString());
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsFunction(List<FunctionPanelSc> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item.id.toString(),
        child: Text(item.name ?? ''),
      ));
    }

    return list;
  }
  Widget _dropDownFileHosts(BuildContext context) {
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
          Messages.SELECT_A_FILE_HOST,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        icon: Icon(Icons.file_copy),
        items: _dropDownItemsFileHost(MemoryPanelSc.listFileHost),
        value: controller.idFileHost.value == '' ? null : controller.idFileHost.value,
        onChanged: (option) {
          controller.setFileHost(context, option.toString());
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsFileHost(List<Host> hosts) {
    List<DropdownMenuItem<String>> list = [];
    for (var host in hosts) {
      list.add(DropdownMenuItem(
        value: host.id.toString(),
        child: Text(host.name ?? ''),
      ));
    }

    return list;
  }
  Widget _dropDownHosts(BuildContext context) {
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
          Messages.SELECT_A_FILE_HOST,

          style: TextStyle(

              color: Colors.black
          ),
        ),
        icon: Icon(Icons.dns),
        items: _dropDownItemsHost(Memory.listHost),
        value: controller.idHost.value == '' ? null : controller.idHost.value,
        onChanged: (option) {
          controller.setHost(context, option.toString());
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