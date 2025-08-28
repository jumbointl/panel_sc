import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import '../../../data/memory_panel_sc.dart';
import 'register_attendance_controller.dart';

class RegisterAttendancePage extends StatelessWidget {
  final FocusNode _focusNode = FocusNode();
  late RegisterAttendanceController controller;

  int count =0;

  RegisterAttendancePage({super.key});
  @override
  Widget build(BuildContext context) {
    // Inject the controller
    controller = Get.put(RegisterAttendanceController());

    return Scaffold(
      appBar: AppBar(title: Text(Messages.REGISTER_ATTENDANCE)),
      body: Obx(() => controller.isLogout.value ? Center(child:CircularProgressIndicator()) :
        SafeArea(
          child: Focus(
          focusNode: _focusNode,
          autofocus: true, // Automatically focus this widget
          onKeyEvent: (FocusNode node, KeyEvent event) {
            controller.handleKeyEvent(context,event);
            return KeyEventResult.handled; // Consume the event
          },
          child: Container(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.isLoading.value ? getProgressBar(context) : Container(child: SizedBox(height: 15,)),
                  SizedBox(height: 10),
                  GestureDetector(
                      onTap: (){
                        controller.typeCode(context,'');
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.keyboard),
                          SizedBox(width: 8),
                          Text(
                            Messages.SCAN_OR_INPUT,
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),

                  SizedBox(height: 10),

                  Expanded(
                    flex: 1,
                    child: ListView.builder(
                      itemCount: controller.attendances.length,
                      itemBuilder: (context, index) {
                        final attendance = controller.attendances[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 2),
                          child: Center(
                            child: Text(attendance.qr ?? '',style:
                            TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: index==0 ? Colors.purple : Colors.black),
                                                    ),
                          ),);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Text( controller.unprocessedAttendances.isEmpty ? Messages.NO_DATA_TO_SEND :
                    Messages.DATA_TO_BE_SENT,
                    style:
                      TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                          color: controller.unprocessedAttendances.isEmpty ? Colors.black : Colors.purple),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: controller.unprocessedAttendances.length,
                      itemBuilder: (context, index) {
                        final attendance = controller.unprocessedAttendances[index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 2),
                          child: Center(
                            child: Text(attendance.qr ?? '',style:
                              TextStyle(fontSize: 16,fontWeight: FontWeight.bold,
                              color: attendance.qr== Messages.NO_DATA_TO_SEND ? Colors.black : Colors.purple),

                              ),
                          ),
                          );
                      },
                    ),
                  ),

                ],
              ),
          ),),
                ),
        ),
      ));
  }
  Widget getProgressBar(BuildContext context) {
    int showProgressBarEachXTimes = MemoryPanelSc.intervalToShowProgressBar;
    if(showProgressBarEachXTimes==0){
      return Container(child: SizedBox(height: 15,));
    }

    if(count<showProgressBarEachXTimes){
      count++;
      return Container(child: SizedBox(height: 15,));
    }
    count = 0;
    return LinearProgressIndicator(minHeight: 15,color: Colors.purple,);

  }
}