import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/models/data_sql.dart';

import '../pos.dart';

class PosSql extends Pos implements DataSql{
  @override
  String getDeleteString() {
    if(id==null){
      return '';
    }
    return 'DELETE FROM ${getTableName()}  WHERE id = $id;';
  }

  @override
  String getInsertString() {
    if(name==null || functionId==null || posCode==null){
      return '';
    }
    String query = "INSERT INTO ${getTableName()}(name, function_id, code, isactive)"
        " VALUES ('$name', '$functionId', '$posCode',$active);";
    if(id!=null){
      query = "INSERT INTO ${getTableName()}(id, name, function_id, code, isactive)"
          " VALUES ($id,'$name', '$functionId' '$posCode',$active,);";
    }
    return query;
  }

  @override
  List? getResult(Result result) {
    if(result.isEmpty){
      return null;
    }
    List<Pos> poss = [];
    for (final row in result) {
      int? id = int.tryParse(row[0].toString());
      String? name = row[1].toString();
      int? functionId = int.tryParse(row[2].toString());
      String? posCode = row[3].toString();
      int? active = int.tryParse(row[4].toString());

      Pos pos = Pos(
          id: id,
          name: name,
          functionId: functionId,
          posCode: posCode,
          active: active
      );
      poss.add(pos);
    }
    return poss;


  }

  @override
  String getSelectString(int? id) {
    String query = 'SELECT  id, name, function_id, code , isactive FROM ${getTableName()};';
    if(id!=null){
      query = 'SELECT  id, name, function_id, code , isactive FROM ${getTableName()} where id = $id;';
    }

    return query;
  }

  @override
  String getTableName() {
    return 'pos';
  }

  @override
  String getUpdateString() {
    if(id==null || name==null || functionId==null || posCode==null ||active==null){
      return '';
    }
    String query = "UPDATE ${getTableName()} SET name = '$name', function_id = '$functionId', "
        "isactive = $active, code = '$posCode' WHERE id = $id;";
    return query;
  }
  static getSelectAllString(bool? active){
    String query = 'SELECT  id, name, function_id, code , isactive FROM pos;';
    if(active==null){
      return query;
    }
    if(active){
      query = 'SELECT  id, name, function_id, code , isactive FROM pos where isactive = 1;';
    } else {
      query = 'SELECT  id, name, function_id, code , isactive FROM pos where isactive = 0;';

    }

  }


}