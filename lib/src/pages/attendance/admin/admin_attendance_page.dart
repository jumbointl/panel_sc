import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/messages.dart';
import 'admin_attendance_controller.dart';
class AdminAttendancePage extends StatelessWidget {

  AdminAttendanceController con = Get.put(AdminAttendanceController());

  AdminAttendancePage({super.key});

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
