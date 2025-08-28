import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import '../../../../data/messages.dart';
import '../../../../models/order.dart';
import '../../../../models/order_pdf.dart';
class SellerOrdersListController extends ControllerModel {
  var totalAmount = 0.0.obs;
  var totalOrders = 0.obs;
  bool  orderListCalled = false;
  List<Order>? orders =<Order>[].obs;
  OrdersProvider ordersProvider = OrdersProvider();
  List<OrderStatus> orderStatus = <OrderStatus>[].obs;
  int pageRefreshTime = 1;



  Future<List<Order>?> getSellerOrderByStatus(BuildContext pageContext, OrderStatus status) async {
    if(dataLoaded){
      isLoading.value =false;
      return orders;
    }
    isLoading.value = true;
    dataLoaded = true;
    int idOrderStatus = status.id!;
    isLoading.value = true;
    orders = await ordersProvider.getSellerOrderByStatus(context, idOrderStatus);
    isLoading.value = false;
    if(orders!=null && orders!.isNotEmpty){
      totalOrders.value = orders!.length;
      double total = 0;
      for (var data in orders!) {
        if(data.total!=null){
          total = total + data.total!;
        }

      }
      totalAmount.value =total;
    }





    return orders;
  }
  void goToOrderDetailPage(Order order){
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_DETAIL_PAGE,arguments: {Memory.KEY_ORDER: order.toJson(),});
  }
  @override
  buttonDeliveryPressed() {
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_LIST_SHIPPED_PAGE);
  }
  @override
  buttonHistoryPressed() {
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_LIST_DELIVERED_PAGE);
  }
  @override
  buttonHomePressed() {
    Get.toNamed(Memory.ROUTE_SELLER_HOME_PAGE);
  }
  @override
  buttonUpPressed() {

    Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE,(route)=>false);

  }
  @override
  buttonDownPressed() {

    //Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE,(route)=>false);

  }
  @override
  buttonStorePressed() {

    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_SELLER_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_SELLER_HOME_PAGE;
    Get.toNamed(Memory.ROUTE_SOCIETY_LIST_PAGE);
  }
  @override
  buttonMapPressed() {

    if(Memory.TESTING_MODE){
      GetStorage().write(
          Memory.KEY_ORDERS, orders);
      Get.toNamed(
          Memory.ROUTE_SELLER_ORDER_LISTMAP_PAGE);
    } else {
      showErrorMessages(Messages.NOT_ENABLED);


    }

  }
  @override
  buttonReturnPressed() {
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_LIST_RETURNED_PAGE);
  }
  @override
  buttonDeclinedPressed() {
    // TODO: implement buttonDeclinedPressed
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_LIST_CANCELED_PAGE);
  }
  @override
  buttonReloadPressed() {
    // TODO: implement buttonReloadPressed
    dataLoaded = false;
    orders!.clear();
    totalAmount.value =0;
    totalOrders.value =0;
    pageRefreshTime++;
    OrderStatus data = orderStatus[0];
    orderStatus.removeAt(0);
    orderStatus.insert(0, data);

  }

  @override
  void buttonPdfPressed() async {

    if(pdfFileName==null){
      if (orders == null || orders!.isEmpty) {
        showErrorMessages(Messages.NO_DATA_FOUND);
        return;
      }
      //OrdersPdfByPrice ordersPdf = OrdersPdfByPrice(orders: orders);
      //OrdersPdfByProduct ordersPdf = OrdersPdfByProduct(orders: orders);
      OrderPdf ordersPdf = OrderPdf(orders: orders);
      File? pdf = await ordersPdf.generatePdf();
      if(pdf==null || ordersPdf.filePath==null){
        showErrorMessages(Messages.FILE_NO_GENERATED);
        return;

      } else if(ordersPdf.filePath!=null){
        pdfFileName = ordersPdf.filePath;
        print('OPEN FILE IN OTHER APP --${ordersPdf.filePath ?? ''}');
      }
    }
    if (pdfFileName==null) {
      showErrorMessages(Messages.FILE_NO_GENERATED);
      return;
    }
    final params = ShareParams(
      text: 'Pdf File',
      files: [XFile(pdfFileName!)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the pdf!');
    }

  }
}