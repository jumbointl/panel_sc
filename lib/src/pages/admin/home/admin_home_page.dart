import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/memory.dart';
import '../../../data/messages.dart';
import '../../../utils/custom_animated_bottom_bar.dart';
import '../../client/profile/info/client_profile_info_page.dart';
import '../database/database_handling_page.dart';
import 'admin_home_controller.dart';
class AdminHomePage extends StatelessWidget {

  AdminHomePageController con = Get.put(AdminHomePageController());

  AdminHomePage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Messages.ADMINISTRATOR),
        automaticallyImplyLeading: false,
        actions: [
          con.buttonUp(),
          con.buttonUser(),
          con.buttonSignOut(),

        ],
      ) ,
      bottomNavigationBar: _bottomBar(),
      body: Obx(() => IndexedStack(
          index: con.indexTab.value,
          children: [
            DatabaseHandlingPage(),
            ClientProfileInfoPage(),
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
        /*
        BottomNavyBarItem(
            icon: Icon(Icons.list),
            title: Text(Messages.ORDERS),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),

         */


        BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text(Messages.DATABASE),
            activeColor: Memory.BAR_ACTIVE_COLOR,
            inactiveColor: Memory.BAR_INACTIVE_COLOR
        ),
        /*
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
