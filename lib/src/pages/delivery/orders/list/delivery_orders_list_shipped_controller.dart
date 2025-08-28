import 'package:solexpress_panel_sc/src/data/memory.dart';
import '../../../common/orders_list_controller.dart';

class DeliveryOrdersListShippedController extends OrdersListController {

  DeliveryOrdersListShippedController(){
    orderStatus.add(Memory.shippedOrderStatus);
  }


}