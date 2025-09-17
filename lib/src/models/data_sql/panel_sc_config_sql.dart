
import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/models/data_sql.dart';

import '../panel_sc_config.dart';

class PanelScConfigSql extends PanelScConfig implements DataSql{
  @override
  String getDeleteString() {
    // TODO: implement getDeleteString
    throw UnimplementedError();
  }

  @override
  String getInsertString() {
    // TODO: implement getInsertString
    throw UnimplementedError();
  }

  @override
  List? getResult(Result result) {
    // TODO: implement getResult
    throw UnimplementedError();
  }

  @override
  String getSelectString(int? id) {
    // TODO: implement getSelectString
    throw UnimplementedError();
  }

  @override
  String getTableName() {
    // TODO: implement getTableName
    throw UnimplementedError();
  }

  @override
  String getUpdateString() {
    // TODO: implement getUpdateString
    throw UnimplementedError();
  }

  @override
  bool isActiveString(String data) {
    // TODO: implement isActiveString
    throw UnimplementedError();
  }



}