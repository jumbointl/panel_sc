import 'package:solexpress_panel_sc/src/data/memory.dart';

import 'client_orders_list_controller.dart';
class ClientOrdersListReturnedController extends  ClientOrdersListController {
  ClientOrdersListReturnedController(){
    orderStatus.add(Memory.returnedOrderStatus);
  }


}