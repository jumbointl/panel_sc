import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/accounting/orders/list/accounting_list_controller.dart';

class AccountingListDeliveredController extends AccountingListController{
  AccountingListDeliveredController(){
    orderStatus.add(Memory.deliveredOrderStatus);
  }



}