


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/admin/database/database_handling_controller.dart';

import '../../../data/memory.dart';
import '../../../data/messages.dart';

class DatabaseHandlingPage extends StatelessWidget {
  DatabaseHandlingController controller = Get.put(DatabaseHandlingController());

  DatabaseHandlingPage({super.key});
  late double screenWith  ;

  late double screenHeight;

  @override
  Widget build(BuildContext context) {

    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        //alignment: Alignment.topCenter,
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textInfo(),
          _buttomBack(),

        ],
      ),
    );
  }
  Widget _backgroundCover(BuildContext context){

    return SafeArea(
      child: Container(
        //alignment: Alignment.topCenter,
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.30,
        color: Memory.PRIMARY_COLOR,

      ),
    );
  }
  Widget _buttomBack(){
    return SafeArea(child: Container(
      margin: EdgeInsets.only(top: 10, left: 20),

      child: IconButton(onPressed: ()=>Get.toNamed(Memory.ROUTE_ROLES_PAGE),
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }
  Widget _boxForm(BuildContext context){
    double space = 7;
    return Container(
      height: MediaQuery.of(context).size.height*0.85,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.15,
          left: 10,right: 10),
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
        child: Row (
          children: [
            Column(
              children: [
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text(
                    Messages.VAT_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {},

                  child: Text(
                    Messages.GROUP_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text(
                    Messages.STATUS_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_ADMIN_CATEGORIES_CREATE_PAGE)},
                  child: Text(
                    Messages.CATEGORY_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text(
                    Messages.USER_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {},
                  child: Text(
                    Messages.SOCIETY_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () =>{Get.toNamed(Memory.ROUTE_ADMIN_PRODUCTS_CREATE_PAGE)},
                  child: Text(
                    Messages.PRODUCT_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () =>{Get.toNamed(Memory.ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_CREATE_PAGE)},
                  child: Text(
                    Messages.PRICE_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),

                ]),

            Column(
                children: [
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      Messages.VAT_HANDLING,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      Messages.GROUP_HANDLING,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      Messages.STATUS_HANDLING,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                  onPressed: () => Get.toNamed(Memory.ROUTE_ADMIN_CATEGORIES_HANDLING_PAGE),
                    child: Text(
                      Messages.CATEGORY_HANDLING,
                      style: TextStyle(
                      color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      Messages.USER_HANDLING,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {},
                    child: Text(
                      Messages.SOCIETY_HANDLING,
                      style: TextStyle(
                      color: Colors.black
                      ),
                    ),
                  ),
                  SizedBox(height: space,),
                  ElevatedButton(
                    onPressed: () => {Get.toNamed(Memory.ROUTE_ADMIN_PRODUCTS_HANDLING_PAGE)},
                    child: Text(
                      Messages.PRODUCT_HANDLING,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    ),
                  ),
                SizedBox(height: space,),
                ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_HANDLING_PAGE)},
                  child: Text(
                    Messages.PRICE_HANDLING,
                    style: TextStyle(
                    color: Colors.black
                    ),
                    ),
                  ),


            ]),
        ])
      ),

    );

  }

  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 20),
        alignment: Alignment.topCenter,
        child: Text(Messages.DATABASE,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ))
    );
  }

}
