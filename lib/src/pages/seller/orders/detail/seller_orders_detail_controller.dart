import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../models/user.dart';
import '../../../../providers/orders_provider.dart';
import '../../../../providers/users_provider.dart';
import '../../../../providers/warehouses_provider.dart';

class SellerOrdersDetailController extends ControllerModel {
  late User user;
  Order order = Order.fromJson(Get.arguments[Memory.KEY_ORDER]);
  OrderStatus orderStatus = Memory.preparedOrderStatus;
  var total = 0.0.obs;
  var idDelivery = ''.obs;

  UsersProvider usersProvider = UsersProvider();
  OrdersProvider ordersProvider = OrdersProvider();
  WarehousesProvider warehousesProvider = WarehousesProvider();
  List<User> users = <User>[].obs;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? homeMarker;

  SellerOrdersDetailController() {
    user =  Memory.getSavedUser();
    getDeliveryMen();
    getTotal();
  } 
  
  void updateOrderToPrepared(BuildContext context) async {
    if(order.idOrderStatus != Memory.ORDER_STATUS_PAID_APPROVED_ID){
      showErrorMessages(Messages.NOT_ENABLED);
      return;
    }

    if (idDelivery.value != '') { // SI SELECCIONO EL DELIVERY
      order.idDelivery = int.tryParse(idDelivery.value);
      if(order.idDelivery==null){
        showErrorMessages(Messages.ERROR);
        return;
      }
      User? deliveryMan = getUserById(users, order.idDelivery);
      if(deliveryMan!=null){
        order.setDeliveryBoy(deliveryMan);
      }
      order.setOrderPicker(user);
      order.setOrderStatus(orderStatus);
      isLoading.value = true;
      ResponseApi responseApi = await ordersProvider.updateToPrepared(context,order);
      isLoading.value = false;
      if (responseApi.success == true) {
        showSuccessMessages(responseApi.message!);
        Get.offNamedUntil(Memory.ROUTE_SELLER_HOME_PAGE, (route) => false);
      } else {
        showErrorMessages(responseApi.message!= null ? responseApi.message! : Messages.ERROR);
      }
    }
    else {
      showErrorMessages(Messages.ASSIGN_DELIVERY_PERSON);
      //Get.snackbar('Peticion denegada', 'Debes asignar el repartidor');
    }
  }

  void getDeliveryMen() async {
    var result = await usersProvider.findDeliveryMen();
    if(result!=null){
      users.clear();
      users.addAll(result);
    }
    update();

  }

  void getTotal() {
    total.value = 0.0;
    for (var product in order.documentItems!) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }


  void goToOrderMapPage(){
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_MAP_PAGE,
        arguments: {Memory.KEY_ORDER: order.toJson(),});
  }


  void goToPaymentsPage() {
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_SELLER_HOME_PAGE;
    saveOrder(order);
    Get.toNamed(Memory.ROUTE_CLIENT_PAYMENTS_CREATE_PAGE);

  }






}