
import 'package:flutter/material.dart';
import 'package:solexpress_panel_sc/src/pages/common/order_list_page_model.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/delivery/orders/list/delivery_orders_list_delivered_controller.dart';
import '../../../../data/memory.dart';
import '../../../../models/order.dart';
import '../../../../models/order_status.dart';

class DeliveryOrdersListDeliveredPage extends OrderListPageModel{
  DeliveryOrdersListDeliveredController controller
                    = Get.put(DeliveryOrdersListDeliveredController());

  DeliveryOrdersListDeliveredPage({super.key}){
    isLoading = controller.isLoading ;
  }

  @override
  dynamic getActionButtons(){
    return <IconButton>[controller.buttonHome(),controller.buttonReturn(),controller.buttonDeclined()];
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
    return controller.getOrderByDeliveryAndStatus(status);
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
  Widget getBottomActionButton() {
    return controller.buttonPdf();
  }
  @override
  Color getAppBarColor(BuildContext context) {
    // TODO: implement getAppBarColor
    if(controller.pageRefreshTime.isEven){
      return Memory.colorsAppBarEven[0];
    } else {
      return Memory.colorsAppBarOdd[0];
    }

  }
}

