import 'dart:io';

import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/models/orders_pdf_by_price.dart';
import 'package:solexpress_panel_sc/src/models/orders_pdf_by_product.dart';
import 'package:solexpress_panel_sc/src/models/society.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import '../../../../models/order.dart';
import '../../../../models/orders_excel.dart';
import '../../../../models/user.dart';
abstract class AccountingListController extends ControllerModel {

  List<Order> orders =[];
  OrdersProvider ordersProvider = OrdersProvider();
  var totalAmount = 0.0.obs;
  var totalOrders = 0.obs;
  int pageRefreshTime = 1;
  @override
  String? excelFileName;
  @override
  String? pdfFileName;
  List<OrderStatus> orderStatus = <OrderStatus>[].obs;
  late Society clientSociety ;
  AccountingListController(){
    clientSociety = getSavedClientSociety();
  }
  Future<List<Order>?> getOrderBySocietyAndStatus(OrderStatus status) async {

    if(dataLoaded || orders.isNotEmpty){
      return orders;
    }

    totalAmount.value =0;
    totalOrders.value =0;
    clientSociety = getSavedClientSociety();
    if(clientSociety.id==null){
      showErrorMessages(Messages.SOCIETY);
      return [];
    }
    User user = getSavedUser();
    if(user.idSociety==null || user.id==null){
      showErrorMessages('${Messages.SOCIETY}/${Messages.USER}');
      return [];
    }
    dataLoaded = true;
    int idOrderStatus = status.id!;
    orders.clear();
    isLoading.value = true ;
    List<Order> data = await ordersProvider.getOrderForAccountingBySocietyAndStatus(
        context, clientSociety.id!, user.id!,idOrderStatus);
    isLoading.value = false ;
    if(data.isNotEmpty){
      orders.addAll(data);
      totalOrders.value = orders.length;
      double total = 0;
      for (var data in orders) {
        if(data.total!=null){
          if(data.isDebitDocument==1){
            total = total + data.total!;
          } else {
            total = total - data.total!;
          }

        }

      }
      totalAmount.value =total;
    }
    return orders;
  }
  void goToOrderDetailPage(Order order){
    //Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_DETAIL_PAGE,arguments: {Memory.KEY_ORDER: order.toJson(),});
  }
  @override
  buttonNextPressed() {

  }

  @override
  buttonBackPressed() {
    //Get.back();
    buttonUpPressed();
  }
  @override
  buttonDownPressed() {



  }
  @override
  buttonStorePressed() {

  }
  @override
  buttonMapPressed() {

  }
  @override
  buttonUserPressed() {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_INFO_PAGE);
  }
  @override
  buttonDeliveryPressed() {
    //Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_SHIPPED_PAGE);
  }
  @override
  buttonHistoryPressed() {
    Get.offNamedUntil(Memory.ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_DELIVERED_PAGE,(route)=>false);
  }
  @override
  void buttonListPressed() {
    // TODO: implement buttonListPressed
    Get.offNamedUntil(Memory.ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_UNCOMPLETED_PAGE,(route)=>false);
  }
  @override
  buttonHomePressed() {
    // TODO: implement buttonHome
    orders = [];
    Get.offNamedUntil(Memory.ROUTE_ACCOUNTING_HOME_PAGE,(route)=>false);
  }
  @override
  buttonDeclinedPressed() {
    //Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_CANCELED_PAGE);
  }
  @override
  buttonReturnPressed() {
    //Get.toNamed(Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_RETURNED_PAGE);
  }

  @override
  buttonReloadPressed() {
    dataLoaded = false;
    orders.clear();
    totalAmount.value =0;
    totalOrders.value =0;
    pageRefreshTime ++;
    OrderStatus data = orderStatus[0];
    orderStatus.removeAt(0);
    orderStatus.insert(0, data);
  }
  @override
  void buttonExcelPressed() async {
    // TODO: implement buttonExcelPressed
    excelFileName = null;
    if (orders.isEmpty) {
      showErrorMessages(Messages.NO_DATA_FOUND);
      return;
    }
    OrdersExcel ordersExcel = OrdersExcel(orders: orders);
    Excel? excel = await ordersExcel.generateExcel();
    if(excel==null){
      showErrorMessages(Messages.FILE_NO_GENERATED);
      return;

    } else if(ordersExcel.path!=null){
      excelFileName = ordersExcel.path;
      print('OPEN FILE IN OTHER APP --${ordersExcel.path ?? ''}');
      var res = await OpenFilex.open(ordersExcel.path!);
    }


  }
  @override
  void buttonSendPressed() async {

    if(excelFileName==null){
      if (orders.isEmpty) {
        showErrorMessages(Messages.NO_DATA_FOUND);
        return;
      }
      OrdersExcel ordersExcel = OrdersExcel(orders: orders);
      Excel? excel = await ordersExcel.generateExcel();
      if(excel==null || ordersExcel.path==null){
        showErrorMessages(Messages.FILE_NO_GENERATED);
        return;

      } else if(ordersExcel.path!=null && ordersExcel.fileBytes!=null){
        excelFileName = ordersExcel.path;
        print('Leer leer la tabla del Excel');
        var decoder = SpreadsheetDecoder.decodeBytes(ordersExcel.fileBytes!);
        var table = decoder.tables[decoder.tables.keys.first];

        if (table == null) {
          print('No se pudo leer la tabla del Excel');
        } else {
          // Filtrar filas vacías o con celdas nulas
          List<List<dynamic>> filteredRows = [];
          StringBuffer stringBuffer = StringBuffer();

          for (var row in table.rows) {
            if (row.any((cell) => cell != null && cell.toString().trim().isNotEmpty)) {
              filteredRows.add(row);
              print(row.toString());
              // Extract each cell data and save it in StringBuffer
              for (var cell in row) {
                stringBuffer.write(cell?.toString() ?? '');
                stringBuffer.write('\t'); // Use tab as a separator between cells
              }
              stringBuffer.writeln(); // Add a new line after each row
            }
          }
          print('Extracted Data:\n$stringBuffer');
        }

        print('OPEN FILE IN OTHER APP --${ordersExcel.path ?? ''}');
      }
    }
    if (excelFileName==null) {
      showErrorMessages(Messages.FILE_NO_GENERATED);
      return;
    }
    final params = ShareParams(
      text: 'Excel file',
      files: [XFile(excelFileName!)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the xlxs!');
    }

  }
  @override
  void buttonPdfPressed() async {

    if(pdfFileName==null){
      if (orders.isEmpty) {
        showErrorMessages(Messages.NO_DATA_FOUND);
        return;
      }
      late OrdersPdfByPrice ordersPdf ;
      if(clientSociety.idGroup!=null){
        if(clientSociety.configuration!=null){
          //print('----------------------------------${clientSociety.configuration!.toJson()}');
        }
        if(clientSociety.idGroup==6){
          ordersPdf = OrdersPdfByPrice(orders: orders,commission: 25, society: clientSociety);
        } else if(clientSociety.idGroup==5){
          ordersPdf = OrdersPdfByPrice(orders: orders,commission: 0, society: clientSociety);
        } else{
          ordersPdf = OrdersPdfByProduct(orders: orders,commission: 0, society: clientSociety) ;
        }
      }
      File? pdf = await ordersPdf.generatePdf();
      if(pdf==null || ordersPdf.filePath==null){
        showErrorMessages(Messages.FILE_NO_GENERATED);
        return;

      } else if(ordersPdf.filePath!=null){
        pdfFileName = ordersPdf.filePath;
        print('OPEN FILE IN OTHER APP --${ordersPdf.filePath ?? ''}');
      }
    }
    if (pdfFileName==null) {
      showErrorMessages(Messages.FILE_NO_GENERATED);
      return;
    }


    final params = ShareParams(
      text: 'Pdf File',
      files: [XFile(pdfFileName!)],
    );

    final result = await SharePlus.instance.share(params);

    if (result.status == ShareResultStatus.success) {
      print('Thank you for sharing the pdf!');
    }

  }



}