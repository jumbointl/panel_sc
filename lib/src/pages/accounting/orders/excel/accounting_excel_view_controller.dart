import 'package:solexpress_panel_sc/src/models/orders_excel.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import '../../../../models/order.dart';

class AccountingExcelViewController extends ControllerModel{
  List<Order>? orders;

  Future<OrdersExcel> createExcel(List<Order>? list) async{
    orders = <Order>[];
    if (list != null && list.isNotEmpty) {
      orders!.addAll(list);

    }
    OrdersExcel excel = OrdersExcel(orders: orders!);
    await excel.generateExcel();
    return excel;
  }
}