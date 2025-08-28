import 'package:solexpress_panel_sc/src/data/memory.dart';
import '../../../common/orders_list_controller.dart';

class DeliveryOrdersListDeliveredController extends OrdersListController {

 DeliveryOrdersListDeliveredController(){
   orderStatus.add(Memory.deliveredOrderStatus);
 }



}