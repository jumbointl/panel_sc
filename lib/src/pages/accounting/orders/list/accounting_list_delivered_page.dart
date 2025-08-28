import 'package:flutter/material.dart' ;
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/accounting/orders/list/accounting_list_page_model.dart';

import '../../../../models/order.dart';
import '../../../../models/order_status.dart';
import 'accounting_list_delivered_controller.dart';

class AccountingListDeliveredPage extends AccountingListPageModel{

  AccountingListDeliveredController controller
              = Get.put(AccountingListDeliveredController());

  AccountingListDeliveredPage({super.key}){
    isLoading = controller.isLoading;
  }



  @override
  dynamic getActionButtons(){
    return <IconButton>[
      controller.buttonUp(),
      controller.buttonHome(),
      controller.buttonList(),
      controller.buttonReload()
    ];
  }

  @override
  int getTabLength() {
    return controller.orderStatus.length;
  }

  @override
  List<OrderStatus> getOrderStatusList() {
    return controller.orderStatus;
  }
  @override
  Future<List<Order>?> getOrders(BuildContext context, OrderStatus status) async {
    return controller.getOrderBySocietyAndStatus(status);
  }

  @override
  void goToOrderDetailPage(Order order) {
    controller.goToOrderDetailPage(order);
  }
  @override
  List<Order> getExtractedOrders(){
    return controller.orders;
  }
  @override
  double getTotalAmountObsValue(){
    return controller.totalAmount.value;
  }
  @override
  int getTotalOrderObsValue(){
    return controller.totalOrders.value;
  }
  @override
  String getTitle() {
    // TODO: implement getTitle
    return controller.clientSociety.name ?? '';
  }
  @override
  void updateOrderToSettlement(BuildContext context, Order order) {
    // TODO: implement updateOrderStatus
    controller.updateOrderToSettlement(context, order);
   // controller.showErrorMessages(Messages.NOT_ENABLED);
  }
  @override
  Widget getBottomSheet() {
    // TODO: implement getBottomSheet
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          controller.buttonExcel(),
          controller.buttonPdf(),
          controller.buttonSend(),

        ],

      ),
    );
  }

}