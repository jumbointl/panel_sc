import 'package:postgres/postgres.dart';

abstract class DataSql {

  String getTableName();
  String getInsertString();
  String getUpdateString();
  String getDeleteString();
  String getSelectString(int? id);
  List<dynamic>? getResult(Result result);
  static String getSelectAllString(bool? active) {
    throw UnimplementedError();
  }
}