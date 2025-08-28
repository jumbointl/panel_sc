
import 'package:flutter/material.dart';
import 'package:solexpress_panel_sc/src/pages/common/order_list_page_model.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/utils/relative_time_util.dart';

import '../../../data/memory.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import 'warehouse_home_orders_list_controller.dart';
class WarehouseHomeOrdersListPage extends OrderListPageModel{

  WarehouseHomeOrdersListController controller = Get.put(WarehouseHomeOrdersListController());
  WarehouseHomeOrdersListPage({super.key,}){
     super.isLoading = controller.isLoading ;
  }

  @override
  dynamic getActionButtons(){
    return [
      //controller.buttonHistory(),
      //controller.buttonDelivery(),
      //controller.buttonStore(),
      controller.buttonMap(),
      controller.buttonReload(),
      Spacer(),
      controller.buttonUp(),
      controller.popUpMenuButton(),
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
    return controller.getSellerOrderByStatus(context,status);

  }

  @override
  void goToOrderDetailPage(Order order) {
    controller.goToOrderDetailPage(order);
  }
  @override
  Color getWarningColor(Order order){
    Color barColor = Colors.purple;
    DateTime date = DateTime.parse(order.deliveredTime ?? '');
    bool b =(RelativeTimeUtil.differenceToToday(date)<0);
    if(b){
      barColor = Colors.white;
      return barColor;
    }

    switch(order.idOrderStatus){
      case Memory.ORDER_STATUS_CREATE_ID:
        barColor = Colors.red[500]!;
        break;
      case Memory.ORDER_STATUS_PAID_APPROVED_ID:
        barColor = Colors.amber[300]!;
        break;
      case Memory.ORDER_STATUS_PREPARED_ID:
        barColor = Colors.cyan[300]!;
        break;
      case Memory.ORDER_STATUS_SHIPPED_ID:
        barColor = Colors.green[600]!;
        break;
      default :
        barColor = Colors.blue[600]!;
        break;
    }


    return barColor;
  }
  @override
  List<Order> getExtractedOrders(){
    if(controller.orders==null){
      return <Order>[];
    }
    return controller.orders!;
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