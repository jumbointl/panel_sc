import 'package:flutter/material.dart' ;
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/accounting/orders/list/accounting_list_page_model.dart';
import 'package:solexpress_panel_sc/src/pages/accounting/orders/list/accounting_list_uncompleted_controller.dart';

import '../../../../models/order.dart';
import '../../../../models/order_status.dart';

class AccountingListUncompletedPage extends AccountingListPageModel{

  AccountingListUncompletedController controller
              = Get.put(AccountingListUncompletedController());

  AccountingListUncompletedPage({super.key}){
    isLoading = controller.isLoading;
  }



  @override
  dynamic getActionButtons(){
    return <IconButton>[controller.buttonUp(),controller.buttonHome(),controller.buttonHistory(),controller.buttonReload()];
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

}