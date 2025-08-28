import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'orders_picker_orders_list_controller.dart';

class OrdersPickerHomeOrdersListController extends OrdersPickerOrdersListController {

  OrdersPickerHomeOrdersListController(){
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = Memory.ROUTE_ORDERSPICKER_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY = Memory.ROUTE_ORDERSPICKER_HOME_PAGE;
    removeSavedSocietiesList();
    orderStatus.add(Memory.allUncompletedOrderStatus);
  }

}