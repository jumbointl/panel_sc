import 'package:solexpress_panel_sc/src/data/memory.dart';
import '../../../common/orders_list_controller.dart';

class DeliveryOrdersListReturnedController extends OrdersListController {

  DeliveryOrdersListReturnedController(){
    orderStatus.add(Memory.returnedOrderStatus);
  }


}