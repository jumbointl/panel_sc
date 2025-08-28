import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/messages.dart';
import 'admin_orders_list_controller.dart';
class AdminOrdersListPage extends StatelessWidget {

  AdminOrdersListController con = Get.put(AdminOrdersListController());

  AdminOrdersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Messages.ADMIN_ORDERS_LIST),
            ElevatedButton(
              onPressed: () => con.signOut(),
              child: Text(
                Messages.LOGOUT,
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
