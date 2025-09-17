import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/models/data_sql.dart';
import 'package:solexpress_panel_sc/src/models/sol_express_event.dart';

class SolExpressEventSql extends SolExpressEvent implements DataSql{
  @override
  String getDeleteString() {
    if(id==null){
      return '';
    }
    return 'DELETE FROM ${getTableName()}  WHERE id = $id;';
  }

  @override
  String getInsertString() {
    if(name==null || eventStartDate==null || eventEndDate==null){
      return '';
    }
    String query = "INSERT INTO ${getTableName()}(name, event_start_date, isactive, event_end_date)"
        " VALUES ('$name', '$eventStartDate',$active, '$eventEndDate');";
    if(id!=null){
      query = "INSERT INTO ${getTableName()}(id, name, event_start_date, isactive, event_end_date)"
          " VALUES ($id,'$name', '$eventStartDate',$active, '$eventEndDate');";
    }
    return query;
  }

  @override
  List? getResult(Result result) {
    if(result.isEmpty){
      return null;
    }
    List<SolExpressEvent> solExpressEvents = [];
    for (final row in result) {
      int? id = int.tryParse(row[0].toString());
      String name = row[1].toString();
      String eventStartDate = row[2].toString();
      int? active = int.tryParse(row[3].toString());
      String eventEndDate = row[4].toString();
      SolExpressEvent solExpressEvent = SolExpressEvent(
          id: id,
          name: name,
          eventStartDate: eventStartDate,
          eventEndDate: eventEndDate,
          active: active
      );
      solExpressEvents.add(solExpressEvent);
    }
    return solExpressEvents;


  }

  @override
  String getSelectString(int? id) {
    String query = 'SELECT  id, name, event_start_date, isactive, event_end_date FROM ${getTableName()};';
    if(id!=null){
      query = 'SELECT  id, name, event_start_date, isactive, event_end_date FROM ${getTableName()} where id = $id;';
    }

    return query;
  }

  @override
  String getTableName() {
    return 'event';
  }

  @override
  String getUpdateString() {
    if(id==null || name==null || eventStartDate==null || eventEndDate==null ||active==null){
      return '';
    }
    String query = "UPDATE ${getTableName()} SET name = '$name', event_start_date = '$eventStartDate', "
        "isactive = $active, event_end_date = '$eventEndDate' WHERE id = $id;";
    return query;
  }





}