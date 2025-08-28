import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/messages.dart';
import 'idempiere_home_controller1.dart';
class IdempiereHomePage1 extends StatelessWidget {

  IdempiereHomeController1 con = Get.put(IdempiereHomeController1());
  double buttonWidth = 200;
  IdempiereHomePage1({super.key});

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
                  onPressed: () => con.refreshToken(),
                  child: Text(
                    Messages.REFRESH_TOKEN,
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
                  onPressed: () => con.goToProductsHomePage(),
                  child: Text(
                    Messages.PRODUCTS,
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
                  onPressed: () => con.goToProductsCategoriesHomePage(),
                  child: Text(
                    Messages.PRODUCTS_CATEGORIES,
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
                  onPressed: () => con.goToProductsBrandsHomePage(),
                  child: Text(
                    Messages.PRODUCTS_BRANDS,
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
                  onPressed: () => con.goToProductsLinesHomePage(),
                  child: Text(
                    Messages.PRODUCTS_LINES,
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
                  onPressed: () => con.goToProductsPricesHomePage(),
                  child: Text(
                    Messages.PRODUCTS_PRICES,
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
                  onPressed: () => con.goToTaxesCategoriesHomePage(),
                  child: Text(
                    Messages.TAXES_CATEGORIES,
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
                  onPressed: () => con.goToTaxesHomePage(),
                  child: Text(
                    Messages.TAXES,
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
                  onPressed: () => con.goToPriceListsHomePage(),
                  child: Text(
                    Messages.PRICE_LISTS,
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
                  onPressed: () => con.goToPriceListVersionsHomePage(),
                  child: Text(
                    Messages.PRICE_LIST_VERSION,
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
                  onPressed: () => con.goToTransactionsHomePage(),
                  child: Text(
                    Messages.TRANSACTIONS,
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
