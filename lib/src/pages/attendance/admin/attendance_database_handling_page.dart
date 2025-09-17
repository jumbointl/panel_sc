


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/memory.dart';
import '../../../data/messages.dart';
import 'attendance_database_handling_controller.dart';

class AttendanceDatabaseHandlingPage extends StatelessWidget {
  AttendanceDatabaseHandlingController controller = Get.put(AttendanceDatabaseHandlingController());

  AttendanceDatabaseHandlingPage({super.key});
  late double screenWith  ;

  late double screenHeight;

  @override
  Widget build(BuildContext context) {

    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
       /*appBar: AppBar(
         centerTitle: true,
           title: Text(Messages.ADMINISTRATOR,style: TextStyle(color: Colors.white,
               fontSize: 20,fontWeight: FontWeight.bold),),),*/
       body: SafeArea(child: _boxForm(context)),
    );
  }

  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.85,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 7,
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_POS_CREATE_PAGE)},
                  child: Text(
                    Messages.POS_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_POS_HANDLING_PAGE)},
                  child: Text(
                    Messages.POS_HANDLING,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {
                    Get.toNamed(Memory.ROUTE_PANEL_EVENT_CREATE_PAGE)
                  },

                  child: Text(
                    Messages.EVENT_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {
                    Get.toNamed(Memory.ROUTE_PANEL_EVENT_HANDLING_PAGE)
                  },
                  child: Text(
                    Messages.EVENT_HANDLING,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_EVENT_CONFIG_CREATE_PAGE)},
                  child: Text(
                    Messages.EVENT_CONFIG_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_EVENT_CONFIG_HANDLING_PAGE)},
                  child: Text(
                    Messages.EVENT_CONFIG_HANDLING,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_EVENT_HAS_POS_CREATE_PAGE)},
                  child: Text(
                    Messages.POS_OF_EVENT_CREATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => {Get.toNamed(Memory.ROUTE_PANEL_EVENT_HAS_POS_HANDLING_PAGE)},
                  child: Text(
                    Messages.POS_OF_EVENT_HANDLING,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
              ),


              ]),
        )
      ),

    );

  }


}
