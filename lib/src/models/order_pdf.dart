import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../utils/relative_time_util.dart';
import 'document_item.dart';
import 'order.dart';

class OrderPdf {
  String? filePath;
  List<Order>? orders;
  List<String> products = [];
  List<String> columnsTitles = [];
  List<String> resumes = [];
  List<double> quantities = [];
  int maximumColumnsForPortrait = 8;
  static const double point = 1.0;
  static const double inch = 72.0;
  static const double cm = inch / 2.54;
  static const double mm = inch / 25.4;
  double total = 0;
  OrderPdf({
    this.filePath,
    this.orders,
  });

  List<String> getColumnsTitles(){
    List<String> list = <String>['#',Messages.NAME,Messages.QUANTITY_SHORT,
      Messages.PRICE_SHORT,Messages.SUM];
    return list;
  }
  void setProductList(){
    for (var order in orders!) {
      if(order.total!=null){
        total = total + order.total!;
      }
      if(order.documentItems!=null){

        for (var product in order.documentItems!) {
          String productPrice = Memory.currencyFormatter.format(product.price);
          bool found = false;
          for (var price in products) {
            if(price==productPrice){
              found = true;
              break;
            }
          }
          if(!found){
            products.add(productPrice);
          }

        }
      }
    }
    for (int i=0;i<products.length;i++) {
      quantities.add(0);

    }
  }

  Future<File?> generatePdf() async {

    if(orders==null || orders!.isEmpty){
      return null;
    }
    final pdf = Document();


    String dayStart = RelativeTimeUtil.getDayMonth(orders![0].deliveredTime) ?? '';
    dayStart = dayStart.replaceAll('-', '/');
    String dayEnd = RelativeTimeUtil.getDayMonth(orders![orders!.length-1].deliveredTime) ?? '';
    dayEnd = dayEnd.replaceAll('-', '/');
    setProductList();
    columnsTitles = getColumnsTitles();
    bool isPortrait = true;
    double margins = 20;

    for (var order in orders!) {
      String clientName = order.society?.name ?? '';
      String orderDate = RelativeTimeUtil.getTimeOnStringOnlyDayMonth(order.deliveredTime) ?? '';
      orderDate = orderDate.replaceAll('-', '/');
      String footer =
          '$orderDate - ${Messages.TOTAL} : ${Memory.currencyFormatter.format(order.total)}';
      pdf.addPage(

        MultiPage(
          margin: EdgeInsets.symmetric(vertical: 15, horizontal: margins),
          pageFormat:  PdfPageFormat.a4,
          orientation: PageOrientation.portrait,
          build: (Context context) {
            return <Widget>[
              Header(
                level: 0,
                child: Text('''Order # ${order.id ?? ''} : $clientName\t\t$orderDate\n${Messages.ADDRESS}:${order.address?.address?? ''}'''),
              ),
              TableHelper.fromTextArray(
                context: context,
                cellAlignments: getCellAlignments(),
                columnWidths: getColumnWidths(isPortrait),
                cellHeight: 0,
                cellStyle: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.normal,
                  color: PdfColors.black,
                ),
                data: <List<String>>[
                  columnsTitles,
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),
                  ...order.documentItems!.asMap().entries.map(
                        (entry) => getRowFromDocumentItem(entry.value, entry.key + 1),
                  ),

                  getResumePerOrder(order), // Removed resume as it's per order now
                ],
              ),
              Footer(
                title: Text(footer, textAlign: TextAlign.left,style: TextStyle(
                  fontSize: 8,
                )),
                padding: EdgeInsets.only(top: 10),
              ),
            ];
          },
        ),
      );
    }

    final directory = (await getExternalStorageDirectory())!.path;

    filePath = '$directory/orders.pdf';
    print('path: $filePath');

    final file = File(filePath!);
    await file.writeAsBytes(await pdf.save());
    if (file.existsSync()) {
      return file;
    } else {
      return null;
    }

  }

  List<String> getRowFromDocumentItem(DocumentItem item, int index) {

    List<String> row = <String>[];
    //row.add(item.id?.toString() ?? ''); // Assuming DocumentItem has an id
    row.add(index.toString()); // Assuming DocumentItem has an id
    row.add(item.name ?? '');
    row.add(Memory.numberFormatter.format(item.quantity ?? 0));
    row.add(Memory.numberFormatter.format(item.price ?? 0));
    row.add(Memory.numberFormatter.format((item.quantity ?? 0) * (item.price ?? 0)));

    return row;
  }

  // This method might need adjustment or removal depending on how you want to handle totals per page.
  // For now, it's not used in getRowFromDocumentItem.

  Map<int, AlignmentGeometry> getCellAlignments() {
    Map<int, AlignmentGeometry> cellAlignments = {};
    cellAlignments[0] = Alignment.centerLeft;
    cellAlignments[1] = Alignment.centerLeft;
    for (int i = 2; i < columnsTitles.length; i++) {
      cellAlignments[i] = Alignment.centerRight;
    }

    return cellAlignments;
  }

  Map<int, TableColumnWidth> getColumnWidths(bool isPortrait) {
    Map<int, TableColumnWidth> colWidths = {};

    //['#',Messages.NAME,Messages.QUANTITY,Messages.PRICE,Messages.SUM];

    double width = 1 / 8;

    colWidths[0] = FixedColumnWidth(width/2);
    colWidths[1] = FixedColumnWidth(width+width*3);
    colWidths[2] = FixedColumnWidth(width);
    colWidths[3] = FixedColumnWidth(width*1.5);
    colWidths[4] = FixedColumnWidth(width*2);

    return colWidths;
  }

  List<String> getResumePerOrder(Order order) {
    List<String> list = ['','','',Messages.TOTAL,Memory.numberFormatter.format(order.total)];
    return list;
  }


}