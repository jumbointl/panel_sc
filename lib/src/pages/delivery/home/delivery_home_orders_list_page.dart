
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../data/memory.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../common/order_list_page_model.dart';
import 'delivery_home_orders_list_controller.dart';

class DeliveryHomeOrdersListPage extends OrderListPageModel{
  DeliveryHomeOrdersListController controller= Get.put(DeliveryHomeOrdersListController());

  DeliveryHomeOrdersListPage({super.key}){
   isLoading = controller.isLoading ;
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
  dynamic getActionButtons() {

    return [
      controller.buttonHistory(),
      controller.buttonDelivery(),
      controller.buttonReturn(),
      controller.buttonStore(),
      controller.buttonReload(),

      Spacer(),
      controller.buttonUp(),
      controller.popUpMenuButton(),

    ];

  }
  @override
  int getPageRefreshTimes() {
    // TODO: implement getRefreshTimes
    return controller.pageRefreshTime;
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

