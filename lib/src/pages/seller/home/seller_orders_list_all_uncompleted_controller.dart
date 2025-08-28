import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/seller/orders/list/seller_orders_list_controller.dart';

class SellerOrdersListAllUncompletedController extends SellerOrdersListController {


  SellerOrdersListAllUncompletedController(){
    Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = Memory.ROUTE_SOCIETY_LIST_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_SOCIETY_LIST_PAGE;
    Memory.PAGE_TO_RETURN_FROM_CLIENT_PRODUCTS_LIST = Memory.ROUTE_SOCIETY_LIST_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = Memory.ROUTE_SELLER_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY = Memory.ROUTE_SELLER_HOME_PAGE;
    removeSavedSocietiesList();
    orderStatus.add(Memory.allUncompletedOrderStatus);
  }






}