import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/home/home_controller.dart';
import '../../data/messages.dart';
class HomePage extends StatelessWidget {

  HomeController con = Get.put(HomeController());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => con.signOut(),
          child: Text(
            Messages.LOGOUT,
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ),
      ),
    );
  }
}
