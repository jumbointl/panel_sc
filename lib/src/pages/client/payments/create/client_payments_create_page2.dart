import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
class ClientPaymentsCreatePage2 extends StatelessWidget {
  const ClientPaymentsCreatePage2({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(Messages.PAYMENTS),
            ElevatedButton(
              onPressed: () => {
                Get.offNamedUntil(Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE,(route)=>false)
              },
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
