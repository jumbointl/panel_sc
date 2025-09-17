import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/memory.dart';
import '../../../data/messages.dart';
import '../../../utils/custom_animated_bottom_bar.dart';
import 'admin_attendance_home_controller.dart';
import 'attendance_database_handling_page.dart';
class AdminAttendanceHomePage extends StatelessWidget {

  AdminAttendanceHomeController con = Get.put(AdminAttendanceHomeController());

  AdminAttendanceHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Messages.ADMINISTRATOR),

      ) ,
      bottomNavigationBar: _bottomBar(),
      body: Obx(() => IndexedStack(
        index: con.indexTab.value,
        children: [
          AttendanceDatabaseHandlingPage(),
        ],
      )),

    );
  }
  Widget _bottomBar() {
    return Obx(() => CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Memory.BAR_BACKGROUND_COLOR,
      showElevation: true,
      itemCornerRadius: 24,
      curve: Curves.easeIn,
      selectedIndex: con.indexTab.value,
      onItemSelected: (index) => con.changeTab(index),
      items: [

        BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text(Messages.DATABASE),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),

        /*
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text(Messages.ORDERS),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),


        BottomNavyBarItem(
            icon: Icon(Icons.restaurant),
            title: Text(Messeges.PRODUCTS),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),
        BottomNavyBarItem(
            icon: Icon(Icons.price_check),
            title: Text(Messeges.PRICE_LIST_SHORT),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),
        */
        BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(Messages.PROFIT),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),
      ],
    ));
  }
}
