import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:solexpress_panel_sc/src/models/society.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../utils/relative_time_util.dart';
import 'order.dart';

class OrdersPdfByPrice {
  String? filePath;
  List<Order>? orders;
  List<String> products = [];
  List<String> titles = [];
  List<String> resumes = [];
  List<double> quantities = [];
  List<String> commissionResume = [];
  int maximumColumnsForPortrait = 8;
  double commission = 0.0;
  double totalCommission = 0.0;

  String totalString = Messages.TOTAL_CN;
  String dateString = Messages.DATE_CN;
  String sumString = Messages.SUM_CN;
  String finalString = Messages.FINAL_CN;
  String clientString = Messages.CLIENT_CN;
  Society society;


  double total = 0;
  OrdersPdfByPrice({
    this.filePath,
    this.orders,
    required this.commission,
    required this.society,
  });
  List<String> getResume(){
    List<String> list = [];
    list.add(totalString);
    for(int i=0;i<quantities.length;i++){
      list.add(Memory.numberFormatter.format(quantities[i]));
    }
    list.add(Memory.numberFormatter.format(total));
    return list;
  }
  List<String> getResumeCommission(){


    List<String> list = [];
    list.add('$commission%');



    for(int i=0;i<quantities.length;i++){
      if(i==quantities.length-1){
        list.add('');
      } else {
        list.add('');
      }

    }
    list.add(Memory.numberFormatter.format(-total*commission/100));
    totalCommission =   total*commission/100;
    return list;
  }
  List<String> getResumeFinal(){
    List<String> list = [];
    list.add('${100-commission}%');
    for(int i=0;i<quantities.length;i++){
      list.add('');
    }
    list.add(Memory.numberFormatter.format(total-totalCommission));
    return list;
  }
  List<String> getTitles(){
    List<String> list = <String>[dateString];

    for (var product in products) {
      list.add(product);
      //print('products: $products');
    }
    list.add(sumString);
    return list;
  }
  void setProductList(){
    for (var order in orders!) {
      if(order.total!=null){
        if(order.isDebitDocument==1){
          total = total + order.total!;
        } else {
          total = total - order.total!;
        }

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
    final font = await rootBundle.load("fonts/NotoSansTC-Regular.ttf");
    final ttf = Font.ttf(font);
    final theme = ThemeData.withFont(
      base: ttf,
      bold: ttf,
    );
    final pdf = Document(theme: theme);
    if(orders==null || orders!.isEmpty){
      return null;
    }
    if(society.idGroup!=null && society.idGroup!=6 && society.idGroup!=5){
      totalString = Messages.TOTAL;
      dateString = Messages.DATE;
      sumString = Messages.SUM;
      finalString = Messages.FINAL;
      clientString = Messages.CLIENT;

    }



    String clientName = society.name ?? '';
    if(society.idGroup ==6 || society.idGroup ==5){
      if(society.name!= null && society.name!.contains('--')){
        clientName = society.name!.split('--').last;
      }
    }

    String dayStart = RelativeTimeUtil.getDayMonth(orders![0].deliveredTime) ?? '';
    dayStart = dayStart.replaceAll('-', '/');
    String dayEnd = RelativeTimeUtil.getDayMonth(orders![orders!.length-1].deliveredTime) ?? '';
    dayEnd = dayEnd.replaceAll('-', '/');
    setProductList();
    titles = getTitles();
    resumes = getResume();
    bool isPortrait = true;
    if(titles.length>maximumColumnsForPortrait){
      isPortrait = false;
    }
    double margins = 20;
    commissionResume = getResumeCommission();
    String footer ='$clientString : $clientName - $dayStart - $dayEnd - $totalString : ${Memory.currencyFormatter.format(total-totalCommission)}';
    await Clipboard.setData(ClipboardData(text: footer));

    pdf.addPage(

      MultiPage(
        margin: EdgeInsets.symmetric(vertical: 15,horizontal: margins),
        pageFormat: orders!.length > 9 ? PdfPageFormat.a4 : PdfPageFormat.a5.landscape,
        orientation: orders!.length > 9 ? isPortrait ? PageOrientation.portrait : PageOrientation.landscape : PageOrientation.landscape,
        build: (Context context) {
          return <Widget>[
            Header(
              level: 0,
              child: Text('$clientString : $clientName'),
            ),

            TableHelper.fromTextArray(
              context: context,
              cellAlignments: getCellAlignments(),
              columnWidths: getColumnWidths(isPortrait),
              data: <List<String>>[
                titles,
                ...orders!.map(
                  (order) => getRowFromOrder(order),
                ),
                getResume(),
                if (commission != 0) commissionResume,
                if (commission != 0) getResumeFinal(),
              ],
            ),
            Footer(
              title: Text(footer,textAlign: TextAlign.left),
              padding: EdgeInsets.only(top: 10),

            ),
          ];
        },
      ),
    );
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
  List<String> getRowFromOrder(Order order){
    List<String> row = <String>[];
    List<double> q = <double>[];
    for(int i=0;i<products.length;i++){
          q.add(0);
          for (var product in order.documentItems!) {
            String productPrice = Memory.currencyFormatter.format(product.price);
            if(product.quantity!=null && productPrice==products[i]){
              if(order.isDebitDocument==1){
                quantities[i] = quantities[i] + product.quantity!;
              } else {
                quantities[i] = quantities[i] - product.quantity!;
              }
              if(order.isDebitDocument==1){
                q[i] = q[i] + product.quantity!;
              } else {
                q[i] = q[i] - product.quantity!;
              }

            }

          }
    }
    row.add(RelativeTimeUtil.getTimeOnStringOnlyDayMonth(order.deliveredTime));
    if(order.documentItems!=null){
      for(int i=0;i<products.length;i++){
        if(q[i]==0){
          row.add('');
        } else {
          row.add(Memory.numberFormatter.format(q[i]));
        }

      }
    }
    if(order.isDebitDocument==1){
      row.add(Memory.numberFormatter.format(order.total));
    } else {
      row.add(Memory.numberFormatter.format(-order.total!));
    }

    return row ;

  }
  Map<int, AlignmentGeometry> getCellAlignments() {
    Map<int, AlignmentGeometry> cellAlignments = {};
    cellAlignments[0] = Alignment.centerRight;
    for (int i = 1; i < titles.length; i++) {
      cellAlignments[i] = Alignment.centerRight;
    }

    return cellAlignments;
  }

  Map<int, TableColumnWidth> getColumnWidths(bool isPortrait) {
    Map<int, TableColumnWidth> colWidths = {};
    double width = 1 / titles.length;
    if(!isPortrait){
      width = 0.7 / titles.length;
    }
    colWidths[0] = FixedColumnWidth(width);
    for (int i = 1; i < titles.length; i++) {
      colWidths[i] = FixedColumnWidth(width);
    }
    return colWidths;
  }


}