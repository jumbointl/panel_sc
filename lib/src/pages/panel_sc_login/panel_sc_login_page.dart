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
  double fontSize = 15;
  double texFieldHeight = 35;

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.stopTimers();
      if (controller.autoLogin.value && !controller.isLoaded) {
        controller.login(context);
        controller.loadedConfig = false;
      }
    });
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: _textAppName(),
            bottom: TabBar(
              labelColor: Colors.purple,
              labelStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: Messages.LOGIN,),
                Tab(text: Messages.CONFIG),
              ],
            ),
          ),
         /* bottomNavigationBar: SizedBox(
            height: 50,
            child: _setCustomUrl(),
          ), */// Pass controller

          body: SafeArea(
              child: TabBarView(
                children: [
                  // Content for Tab 1
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Obx(() =>_boxForm1(context)),
                  ),
                  // Content for Tab 2
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    child: Obx(() =>_boxForm2(context)),
                  ),
                ],
              ),
        )
        ),
    );
  }

  Widget _boxForm1(BuildContext context){ // Add controller and showIcon parameters
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
              ListTile(
                leading:Text('POS',
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold,
                        color: Colors.black)),
                title: SizedBox(
                  height: texFieldHeight,
                  width: double.infinity,
                  child: TextField(
                    textAlignVertical: TextAlignVertical.bottom,
                    controller: controller.posIdController,
                    obscureText: false,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: Messages.POS,
                      //prefixIcon: Icon(Icons.numbers),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

              ),

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
                          fontSize: fontSize, fontWeight: FontWeight.bold,
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
                        fontSize: fontSize, fontWeight: FontWeight.bold,
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
            SizedBox(
              height: texFieldHeight,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
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
            ),
            SizedBox(
              height: texFieldHeight,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
                controller: controller.userNameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: Messages.NAME,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
            ), // Pass controller
            SizedBox(
              height: texFieldHeight,
              child: TextField(
                textAlignVertical: TextAlignVertical.bottom,
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
  Widget _boxForm2(BuildContext context){ // Add controller and showIcon parameters
    bool isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    double formHeight = MediaQuery.of(context).size.height * 0.8;
    if(controller.attendancePanel.value){
      if(!controller.showConfiguration.value){
        return Container(
          height: formHeight,
          width: controller.getMaximumInputFieldWidth(context),
          margin: EdgeInsets.only(top: 10,
              left: 20,right: 20),
          //color: Colors.white,
          child: Center(
            child: SizedBox(
              height: texFieldHeight+10,
              width: double.infinity, // Make TextButton take full width
              child: TextButton(
                  style: TextButton.styleFrom(
                    side: BorderSide(color: Colors.white, width: 1), // Add border here
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder( // Match TextField border
                      borderRadius: BorderRadius.circular(4.0), // Adjust as needed
                    ),
                  ),
                  onPressed: (){controller.showConfiguration.value = true;},
                  child: Text(Messages.SHOW_CONFIGURATION,style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold,
                      color: Colors.white))),
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
              SizedBox(
                height: texFieldHeight*5,
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: controller.urlController,
                  obscureText: false,
                  maxLines: 6,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.DATABASE_URL_WITHOUT_HTTP,
                    prefixIcon: Icon(Icons.link),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: texFieldHeight,
                child: Text('${Messages.FONT_SIZE_ADJUSTMENT} %',
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: texFieldHeight,
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: controller.fontSizeAdjustmentController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '${Messages.FONT_SIZE_ADJUSTMENT} %',
                    prefixIcon: Icon(Icons.percent),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: texFieldHeight,
                child: Text('${Messages.LOGO_SIZE_ADJUSTMENT} %',
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: texFieldHeight,
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: controller.logoSizeAdjustmentController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '${Messages.LOGO_SIZE_ADJUSTMENT} %',
                    prefixIcon: Icon(Icons.percent),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: texFieldHeight,
                child: Text(Messages.CLOCK_RIGHT_MARGIN_ADJUSTMENT,

                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ),
              SizedBox(
                height: texFieldHeight,
                child: TextField(
                  textAlignVertical: TextAlignVertical.bottom,
                  controller: controller.clockRightMarginAdjustmentController,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: Messages.CLOCK_RIGHT_MARGIN_ADJUSTMENT,
                    prefixIcon: Icon(Icons.numbers),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                height: texFieldHeight+10,
                width: double.infinity, // Make TextButton take full width
                child: TextButton(
                    style: TextButton.styleFrom(
                      side: BorderSide(color: Colors.black, width: 1), // Add border here
                      backgroundColor: Colors.amber[200],
                      shape: RoundedRectangleBorder( // Match TextField border
                        borderRadius: BorderRadius.circular(4.0), // Adjust as needed
                      ),
                    ),
                    onPressed: (){controller.showConfiguration.value = false;},
                    child: Text(Messages.HIDE_CONFIGURATION,style: TextStyle(
                    fontSize: fontSize, fontWeight: FontWeight.bold,
                    color: Colors.black))),
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
              Center(child: Text(Messages.NOT_ENABLED),),

          ],
        ),
      ),

    );

  }
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
        fontSize: 30,
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
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
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