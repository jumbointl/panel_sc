import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../providers/users_provider.dart';

class ClientOrdersDetailController extends ControllerModel {


  User user =  Memory.getSavedUser();
  Order order = Order.fromJson(Get.arguments[Memory.KEY_ORDER]);
  OrderStatus orderStatus = Memory.preparedOrderStatus;
  var total = 0.0.obs;
  var idClient = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  List<User> users = <User>[].obs;

  ClientOrdersDetailController() {
    getTotal();
  }
  void goToOrderMapPage(){
    if(Memory.TESTING_MODE){
      Get.toNamed(Memory.ROUTE_CLIENT_ORDER_MAP_PAGE,
          arguments: {Memory.KEY_ORDER: order.toJson(),});
    } else {
      showErrorMessages(Messages.NOT_ENABLED);
    }

  }

  void getTotal() {
    total.value = order.total != null ? total.value = order.total! : 0.0;
    /*
    for (var products in order.documentItems!) {
      total.value = total.value + (products.quantity! * products.price_list!);
    }

     */
  }



  Future<void> updateOrderToReturned(BuildContext context) async {
    order.setOrderStatus(Memory.returnedOrderStatus);
    ResponseApi responseApi = await ordersProvider.updateOrderStatus(context,order);
    if (responseApi.success == true) {
      //showSuccessMessages(responseApi.message!);
      Get.offNamedUntil(Memory.ROUTE_CLIENT_HOME_PAGE, (route) => false);
    } else {
      showErrorMessages(responseApi.message!);
    }

  }



}