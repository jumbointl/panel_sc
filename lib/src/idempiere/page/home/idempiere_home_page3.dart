import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/messages.dart';
import 'idempiere_home_controller3.dart';
class IdempiereHomePage3 extends StatelessWidget {

  IdempiereHomeController3 con = Get.put(IdempiereHomeController3());
  double buttonWidth = 200;
  IdempiereHomePage3({super.key});

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
                  onPressed: () => con.goToUserWithDetailsHomePage(),
                  child: Text(
                    Messages.USER_WITH_DETAILS,
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
                  onPressed: () => con.goToTenantWithDetailsHomePage(),
                  child: Text(
                    Messages.TENANT_WITH_DETAILS,
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
                  onPressed: () => con.goToOrganizationsHomePage(),
                  child: Text(
                    Messages.ORGANIZATIONS,
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
                  onPressed: () => con.goToWarehouseHomePage(),
                  child: Text(
                    Messages.WAREHOUSES,
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
                  onPressed: () => con.goToBusinessPartnerHomePage(),
                  child: Text(
                    Messages.BUSINESS_PARTNER,
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
                  onPressed: () => con.goToBusinessPartnerLocationsHomePage(),
                  child: Text(
                    Messages.BUSINESS_PARTNER_LOCATION,
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
