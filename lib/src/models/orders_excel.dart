import 'dart:io';

import 'package:excel/excel.dart';
import 'package:open_filex/open_filex.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/order.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class OrdersExcel {
  late List<Order> orders;
  List<int>? fileBytes;
  String? path;
  Excel excel = Excel.createExcel();
  OrdersExcel({required this.orders});

  Future<Excel?> generateExcel() async {
    // Request storage permission
    bool status = await Memory.checkExternalMediaPermission();
    if (!status) {
      await openAppSettings();
      return excel;
    }
    if (status) {
      excel.rename('Sheet1', 'Orders');
      final Sheet sheetObject = excel['Orders'];

      // Add headers
      sheetObject.appendRow([
        TextCellValue('Order ID'),
        TextCellValue('Client'),
        TextCellValue('Delivery Address'),
        TextCellValue('Status'),
        TextCellValue('Timestamp'),
        // Add more headers as needed for your Order model
      ]);

      // Add data for each order
      for (var order in orders) {
        sheetObject.appendRow([
          TextCellValue('${order.id}' ?? 'N/A'),
          TextCellValue(order.society?.name ?? 'N/A'), // Assuming Client has a name property
          TextCellValue(order.address?.address ?? 'N/A'), // Assuming Address has an address property
          TextCellValue(order.orderStatus?.name ?? 'N/A'),
          TextCellValue(order.deliveredTime?.toString() ?? 'N/A'), // Convert timestamp to string
          // Add more data cells corresponding to your headers
        ]);
      }

      // Get the directory to save the file
      final directory = await getExternalStorageDirectory();
      path = '${directory?.path}/orders.xlsx';

      // Save the file
      fileBytes = excel.save();
      if (fileBytes != null) {
        path = '${directory?.path}/orders.xlsx';
        File(path!)
          ..createSync(recursive: true)
          ..writeAsBytesSync(fileBytes!);
        print('Excel file saved to $path');

      } else {
        print('Error saving excel file');
      }
      print('return excel--------------------------------------');
      return excel;
    } else {
      print('Storage permission not granted');
    }
    return null;
  }

  Future<List<int>?> generateExcelBytes(List<Order> orders) async {
    final excel = Excel.createExcel();
    final Sheet sheetObject = excel['Orders'];

    // Add headers
    sheetObject.appendRow([
      TextCellValue('Order ID'),
      TextCellValue('Client'),
      TextCellValue('Delivery Address'),
      TextCellValue('Status'),
      TextCellValue('Timestamp'),
      // Add more headers as needed for your Order model
    ]);

    // Add data for each order
    for (var order in orders) {
      sheetObject.appendRow([
        TextCellValue('${order.id}' ?? 'N/A'),
        TextCellValue(order.society?.name ?? 'N/A'), // Assuming Client has a name property
        TextCellValue(order.address?.address ?? 'N/A'), // Assuming Address has an address property
        TextCellValue(order.orderStatus?.name ?? 'N/A'),
        TextCellValue(order.deliveredTime?.toString() ?? 'N/A'), // Convert timestamp to string
        // Add more data cells corresponding to your headers
      ]);
    }
    return excel.save();
  }
  void openFile() async{
    if(path!=null){
      await OpenFilex.open(path!);

    } else {
      print('Path is null');
    }
  }
}