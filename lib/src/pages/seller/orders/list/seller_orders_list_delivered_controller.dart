import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/seller/orders/list/seller_orders_list_controller.dart';

class SellerOrdersListDeliveredController extends SellerOrdersListController {

  @override
  SellerOrdersListDeliveredController(){
    orderStatus.add(Memory.deliveredOrderStatus);
  }


}