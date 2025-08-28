import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/messages.dart';
import 'idempiere_configuration_controller.dart';
class IdempiereConfigurationPage extends StatelessWidget {

  IdempiereConfigurationController con = Get.put( IdempiereConfigurationController());
  double buttonWidth = 200;
  IdempiereConfigurationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        centerTitle: true,
        title: Text(
         Messages.IDEMPIERE_APP_NAME,
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
              Text(Messages.CUSTOM_URL),
              TextField(
                controller: con.urlController,
                keyboardType: TextInputType.emailAddress,
                maxLines: 3,
                decoration: InputDecoration(

                  filled: true,
                  fillColor: Colors.white,
                  hintText: Messages.CUSTOM_URL,
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.saveConfiguration(),
                  child: Text(
                    Messages.SAVE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
