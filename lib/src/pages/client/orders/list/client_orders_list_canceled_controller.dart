import 'package:solexpress_panel_sc/src/data/memory.dart';

import 'client_orders_list_controller.dart';
class ClientOrdersListCanceledController extends  ClientOrdersListController {

  ClientOrdersListCanceledController(){
    orderStatus.add(Memory.canceledOrderStatus);
  }

}