import 'package:flutter/material.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

import '../../../../models/orders_excel.dart';

class ExvelViewPage extends StatelessWidget {
  OrdersExcel? excel;

  ExvelViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    excel = ModalRoute.of(context)!.settings.arguments as OrdersExcel?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Excel'),
      ),
      body: Center(
        child: excel != null
            ? _buildExcelContent(excel!.fileBytes!)
            : const Text('No se pudo cargar el archivo Excel'),
      ),
    );
  }

  Widget _buildExcelContent(List<int> bytes) {
    var decoder = SpreadsheetDecoder.decodeBytes(bytes);
    var table = decoder.tables[decoder.tables.keys.first];

    if (table == null) {
      return const Center(child: Text('No se pudo leer la tabla del Excel'));
    }

    // Filtrar filas vacías o con celdas nulas
    List<List<dynamic>> filteredRows = [];
    for (var row in table.rows) {
      if (row.any((cell) => cell != null && cell.toString().trim().isNotEmpty)) {
        filteredRows.add(row);
      }
    }

    if (filteredRows.isEmpty) {
      return const Center(child: Text('El archivo Excel está vacío o no tiene datos válidos'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
          columns: filteredRows.first
              .map((header) => DataColumn(label: Text(header?.toString() ?? '')))
              .toList(),
          rows: filteredRows.skip(1).map((row) {
            return DataRow(
              cells: row.map((cell) {
                return DataCell(
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      cell?.toString() ?? '',
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
          columnSpacing: 10,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 50,
        ),
      ),
    );
  }
}
