import 'package:solexpress_panel_sc/src/data/memory.dart';
import '../../../common/orders_list_controller.dart';

class DeliveryOrdersListCanceledController extends OrdersListController {

   DeliveryOrdersListCanceledController(){
     orderStatus.add(Memory.canceledOrderStatus);
   }



}