import 'dart:io';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import '../../data/messages.dart';
import '../../models/order.dart';
import '../../models/order_pdf.dart';
import '../../models/user.dart';
abstract class OrdersListController extends ControllerModel {
  bool  orderListCalled = false;
  List<Order> orders =<Order>[].obs;
  OrdersProvider ordersProvider = OrdersProvider();
  var totalAmount = 0.0.obs;
  var totalOrders = 0.obs;
  int pageRefreshTime = 1;

  List<OrderStatus> orderStatus = <OrderStatus>[].obs;


  Future<List<Order>?> getOrderByDeliveryAndStatus(OrderStatus status) async {

    if(dataLoaded || orders.isNotEmpty){
      return orders;
    }
    dataLoaded = true;

    User user =  Memory.getSavedUser();
    int idOrderStatus = status.id!;
    orders.clear();
    List<Order>? data = [];
    isLoading.value = true;
    data = await ordersProvider.getByDeliveryAndStatus(context, user.id!, idOrderStatus);
    isLoading.value = false;
    if(data!=null){
      orders.addAll(data);
    }
    if(orders.isNotEmpty){
      totalOrders.value = orders.length;
      double total = 0;
      for (var data in orders) {
        if(data.total!=null){
          total = total + data.total!;
        }

      }
      totalAmount.value =total;
    }

    return orders;
  }
  void goToOrderDetailPage(Order order){
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_DETAIL_PAGE,arguments: {Memory.KEY_ORDER: order.toJson(),});
  }
  @override
  buttonNextPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_DELIVERED_PAGE);
  }

  @override
  buttonBackPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_SHIPPED_PAGE);
  }
  @override
  buttonDownPressed() {

    isLoading.value = false;

  }
  @override
  buttonStorePressed() {

  }
  @override
  buttonMapPressed() {

  }
  @override
  buttonUserPressed() {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_INFO_PAGE);
  }
  @override
  buttonDeliveryPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_SHIPPED_PAGE);
  }
  @override
  buttonHistoryPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_DELIVERED_PAGE);
  }
  @override
  buttonHomePressed() {
    // TODO: implement buttonHome
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_HOME_PAGE);
  }
  @override
  buttonDeclinedPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_CANCELED_PAGE);
  }
  @override
  buttonReturnPressed() {
    Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_RETURNED_PAGE);
  }
  @override
  buttonReloadPressed() {
    dataLoaded = false;
    isLoading.value = true;
    orders.clear();
    totalAmount.value =0;
    totalOrders.value =0;
    pageRefreshTime ++;
    OrderStatus data = orderStatus[0];
    orderStatus.removeAt(0);
    orderStatus.insert(0, data);
    isLoading.value =false;
  }
  @override
  void buttonPdfPressed() async {

    if(pdfFileName==null){
      if (orders.isEmpty) {
        showErrorMessages(Messages.NO_DATA_FOUND);
        return;
      }

      //OrdersPdfByPrice ordersPdf = OrdersPdfByPrice(orders: orders);
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