import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';

import '../../../data/messages.dart';
import '../../../models/user.dart';
import '../../common/orders_list_controller.dart';
class DeliveryHomeOrdersListController extends OrdersListController {

  DeliveryHomeOrdersListController(){
    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    Memory.PAGE_TO_RETURN_FROM_CLIENT_PRODUCTS_LIST = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    removeSavedSocietiesList();
    orderStatus.add(Memory.preparedOrderStatus);

  }


  @override
  buttonStorePressed() {
    User user = getSavedUser();
    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_DELIVERY_MAN_HOME_PAGE;
    if(user.society == null || user.society!.id == null){
      showErrorMessages(Messages.SOCIETY);
      return;
    }
    saveClientSociety(user.society!);
    Get.toNamed(Memory.ROUTE_CLIENT_PRODUCTS_LIST_PAGE,arguments: {
    Memory.KEY_IS_DEBIT_TRANSACTION :true,
    Memory.KEY_CLIENT_SOCIETY:user.society});
  }

}