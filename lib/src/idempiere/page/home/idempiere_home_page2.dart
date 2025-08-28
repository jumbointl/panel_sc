import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/messages.dart';
import 'idempiere_home_controller2.dart';
class IdempiereHomePage2 extends StatelessWidget {

  IdempiereHomeController2 con = Get.put(IdempiereHomeController2());
  double buttonWidth = 200;
  IdempiereHomePage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          con.buttonSignOut(),
          con.popUpMenuButton(),
        ],
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

              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToCountriesHomePage(),
                  child: Text(
                    Messages.COUNTRIES,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToRegionsHomePage(),
                  child: Text(
                    Messages.REGIONS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToCitiesHomePage(),
                  child: Text(
                    Messages.CITIES,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToSalesRegionHomePage(),
                  child: Text(
                    Messages.SALES_REGIONS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToLocationsHomePage(),
                  child: Text(
                    Messages.LOCATIONS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToSalesRegionHomePage(),
                  child: Text(
                    Messages.CURRENCIES,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToLocatorHomePage(),
                  child: Text(
                    Messages.LOCATORS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToUOMHomePage(),
                  child: Text(
                    Messages.UOM,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: buttonWidth,
                child: ElevatedButton(
                  onPressed: () => con.goToPOSHomePage(),
                  child: Text(
                    Messages.POS,
                    textAlign: TextAlign.center,
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
