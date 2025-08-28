import 'package:solexpress_panel_sc/src/data/memory.dart';

import '../../../models/user.dart';
import '../orders/list/client_orders_list_controller.dart';
class ClientOrdersListAllUncompletedController extends ClientOrdersListController {

  ClientOrdersListAllUncompletedController(){
    User user = getSavedUser();
    if(user.society!=null ){
      saveClientSociety(user.society!);
    }
    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_CLIENT_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_CLIENT_HOME_PAGE;
    Memory.PAGE_TO_RETURN_FROM_CLIENT_PRODUCTS_LIST = Memory.ROUTE_CLIENT_HOME_PAGE;
    orderStatus.add(Memory.allUncompletedOrderStatus);
  }




}