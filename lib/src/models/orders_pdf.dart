import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'order.dart';

class OrdersPdf {
  String? filePath;
  List<Order>? orders;

  OrdersPdf({
    this.filePath,
    this.orders,
  });

  Future<File?> generatePdf() async {
    final pdf = Document();

    pdf.addPage(
      MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return <Widget>[
            Header(
              level: 0,
              child: Text('Orders Report'),
            ),
            TableHelper.fromTextArray(
              context: context,
              data: <List<String>>[
                <String>['Order ID', 'Customer Name', 'Total Amount', 'Status'],
                ...orders!.map(
                  (order) => [
                    order.id.toString(),
                    order.society?.name ?? 'N/A',
                    order.total.toString(),
                    order.orderStatus?.name ?? 'N/A',
                  ],
                ),
              ],
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
}