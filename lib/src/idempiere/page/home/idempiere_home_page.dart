import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'idempiere_home_controller.dart';
import 'idempiere_home_page1.dart';
import 'idempiere_home_page2.dart';
import 'idempiere_home_page3.dart';

class IdempiereHomePage extends GetView<IdempiereHomeController> {

  double buttonWidth = 200;
  // var currentIndex = 0.obs;
  String? title;
  int lastIndex = 2;
  IdempiereHomePage({super.key,
  ThemeData? theme,
  }){
    title = 'Flutter Demo';
    theme = ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.put(IdempiereHomeController());
    return Scaffold(

      body: Obx(() => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            IdempiereHomePage1(),
            IdempiereHomePage2(),
            IdempiereHomePage3(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
          backgroundColor: Colors.blue,
          currentIndex: controller.currentIndex.value,
          unselectedItemColor: Color(0xff3a0ca3),
          selectedItemColor: Colors.amber[800],
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.filter_1,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.filter_2,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.filter_3,
              ),
              label: '',
            ),

          ],
          onTap: (index) => controller.changePageIndex(index, lastIndex),
        )),
      );

  }
}