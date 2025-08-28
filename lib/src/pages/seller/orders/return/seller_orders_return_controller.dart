import 'package:solexpress_panel_sc/src/data/memory.dart';

import 'orders_return_controller.dart';

class SellerOrdersReturnController extends OrdersReturnController{

  SellerOrdersReturnController(){
    Memory.PAGE_TO_RETURN_FROM_ORDERS_RETURN_PAGE = Memory.ROUTE_SELLER_HOME_PAGE;
  }


}