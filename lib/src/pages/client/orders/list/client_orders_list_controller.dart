import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/models/society.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import '../../../../models/order.dart';
import '../../../../models/user.dart';
class ClientOrdersListController extends ControllerModel {
  bool  orderListCalled = false;
  List<Order> orders =<Order>[];
  OrdersProvider ordersProvider = OrdersProvider();
  List<OrderStatus> orderStatus = <OrderStatus>[].obs;
  var totalAmount = 0.0.obs;
  var totalOrders = 0.obs;
  int pageRefreshTime = 1;

  ClientOrdersListController(){
    User user = getSavedUser();
    Society society = user.society!;
    if(society.id != null){
      saveClientSociety(society);
    }
  }

  Future<List<Order>?> getOrderByStatus(OrderStatus status) async {
    if(dataLoaded || orders.isNotEmpty){
      return orders;
    }
    dataLoaded = true;
    isLoading.value = true;
    int idOrderStatus = status.id!;

    orders = await ordersProvider.getClientOrderByStatus(context, idOrderStatus);
    isLoading.value = false;
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
    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_DETAIL_PAGE,arguments: {Memory.KEY_ORDER: order.toJson(),});
  }

  @override
  buttonDownPressed() {



  }
  @override
  buttonStorePressed() {
    User user = getSavedUser();
    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_CLIENT_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_CLIENT_HOME_PAGE;
    if(user.society == null || user.society!.id == null){
      showErrorMessages(Messages.SOCIETY);
      return;
    }
    saveClientSociety(user.society!);
    Get.toNamed(Memory.ROUTE_CLIENT_PRODUCTS_LIST_PAGE,arguments: {
      Memory.KEY_IS_DEBIT_TRANSACTION :true,
      Memory.KEY_CLIENT_SOCIETY:user.society});
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

    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_LIST_SHIPPED_PAGE);
  }
  @override
  buttonHistoryPressed() {

    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_LIST_DELIVERED_PAGE);
  }
  @override
  buttonHomePressed() {
    // TODO: implement buttonHome
    Get.toNamed(Memory.ROUTE_CLIENT_HOME_PAGE);
  }
  @override
  buttonDeclinedPressed() {
    // TODO: implement buttonDeclinedPressed
    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_LIST_CANCELED_PAGE);
  }
  @override
  buttonReturnPressed() {

    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_LIST_RETURNED_PAGE);
  }
  @override
  buttonReloadPressed() {
    dataLoaded = false;
    orders.clear();
    totalAmount.value =0;
    totalOrders.value =0;
    pageRefreshTime++;
    OrderStatus data = orderStatus[0];
    orderStatus.removeAt(0);
    orderStatus.insert(0, data);
  }
}