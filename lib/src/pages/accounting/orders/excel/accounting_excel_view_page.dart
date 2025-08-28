
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../data/messages.dart';
import '../../../../models/order.dart';
import 'accounting_excel_view_controller.dart';

class AccountingExcelViewPage extends StatelessWidget {
  late AccountingExcelViewController controller;
  List<Order>? orders;

  AccountingExcelViewPage({super.key}){
    controller = AccountingExcelViewController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes para Excel'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: orders?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Orden #${orders![index].id}'),
                  subtitle: Text('Cliente: ${orders![index].society?.name ?? 'N/A'} '),
                  trailing: Text('\$${orders![index].total?.toStringAsFixed(2) ?? '0.00'}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (orders != null && orders!.isNotEmpty) {
                  try {
                    final excel = await controller.createExcel(orders!);
                    final filePath =excel.path;
                    if(filePath==null){
                      controller.showErrorMessages(Messages.FILE_NO_GENERATED);
                      return;
                    }
                    OpenFilex.open(filePath);
                  } catch (e) {
                    print('Error creando o abriendo el archivo Excel: $e');
                    // Considerar mostrar un mensaje al usuario
                  }
                }
              },
              child: const Text('Exportar a Excel'),
            ),
          ),
        ],
      ),
    );
  }
}
