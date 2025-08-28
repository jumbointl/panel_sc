import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/memory.dart';
import '../../models/idempiere/idempiere_object.dart';
class IdempiereObjectDetailPageModel extends StatelessWidget {

  double buttonWidth = 300;
  String title = '';
  IdempiereObject? idempiereObject;
  IdempiereObjectDetailPageModel({super.key,this.idempiereObject});

  @override
  Widget build(BuildContext context) {

    if(idempiereObject == null){
      var args = Get.arguments[Memory.KEY_IDEMPIERE_OBJECT];
      if (args != null && args is IdempiereObject) {
        idempiereObject = args;
      } else {
        if(args == null){
          idempiereObject = IdempiereObject.fromJson(args);
        } else {
          idempiereObject = IdempiereObject();
        }

      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: getActionButtons(),
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              SizedBox(
                width: buttonWidth,
                child:Text('ID: ${idempiereObject?.id ?? '--'}'),
              ),
              if(idempiereObject != null)...idempiereObject!.getOtherDataToDisplay().map((data) {
                return SizedBox(
                  width: buttonWidth,
                  child: Text(
                    data,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getActionButtons() {
    return <Widget>[Container()];
  }


}
