import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import '../../../../../models/data_sql/event_has_pos.dart';
import '../../../../../models/pos.dart';
import 'postgres_provider_model.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/response_api.dart';
import '../../../../../models/sol_express_event.dart';
class SolExpressEventHasPosProvider extends PostgresProviderModel{

  Future<ResponseApi> insert(List<EventHasPos> data) async{
    String query ="INSERT INTO public.event_has_pos(event_id, pos_id)"
        "VALUES (${data[0].eventId}, '${data[0].posId}')";
    for(int i=1;i<data.length;i++){
      query += ",(${data[i].eventId}, '${data[i].posId}')";
    }
    query += " ON CONFLICT DO NOTHING RETURNING *;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.CREATE}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: Messages.OK);

    return responseApi;

  }


  Future<ResponseApi> deleteByIds(BuildContext context, EventHasPos data) async {
    String query ='DELETE FROM public.event_has_pos WHERE event_id = ${data.eventId}'
        ' and pos_id = ${data.posId} RETURNING *';
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.DELETE}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    if(affectedRows==0){
      return ResponseApi(success: false,message: '${Messages.NO_ROWS_AFFECTED} : ${Messages.DELETE}');
    }
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: '${Messages.DELETE} ${data.eventId?.toString()} ,${data.posId?.toString()}: ${Messages.OK}');

    return responseApi;
  }
  
  Future<ResponseApi> findPosSimpleByName(Pos data) async {
    // only show POS id and name
    String name = data.name ?? '';

    String condition =" LOWER(name) like '%${name.toLowerCase()}%'";
    if(name.contains('%')){
      condition =" LOWER(name) like '${name.toLowerCase()}'";
    }
    String query ="SELECT id, name, function_id, code, isactive	"
        "FROM public.pos where $condition order by name ;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<Pos> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${data.name}');
    }

    for(var row in result){
      Pos data = Pos();
      data.id = row[0] as int;
      data.name = row[1] as String;
      data.functionId = row[2] as int;
      data.posCode = row[3] as String;
      if(row[4]!=null){
        if(row[4] is bool){
          data.active = row[4] ==true ? 1 : 0;
        } else {
          if(row[4] is int){
            data.active = row[4] as int;
          }
        }
      }

      newList.add(data);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);

    return responseApi;

  }
  Future<ResponseApi> findPosInEventId(SolExpressEvent event) async {
    String condition =" event_id = ${event.id}";
    String query ="SELECT event_id, event_name, pos_id, pos_name FROM public.v_event_has_pos "
        " where $condition order by pos_name ;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<Pos> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${event.name}');
    }

    for(var row in result){
      Pos data = Pos();
      data.id = row[2] as int;
      data.name = row[3] as String;
      newList.add(data);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);

    return responseApi;

  }
  Future<ResponseApi> findPosNotInEventId(SolExpressEvent event) async {
    String condition =" (SELECT pos_id FROM event_has_pos WHERE event_id =${event.id})"
        " ORDER BY NAME LIMIT ${MemoryPanelSc.SQL_QUERY_ALL_LIMIT}; ";

    String query ="SELECT id, name, function_id, code, isactive FROM public.pos WHERE id NOT IN "
        "$condition ;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<Pos> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${event.name}');
    }

    for(var row in result){
      Pos data = Pos();
      data.id = row[0] as int;
      data.name = row[1] as String;
      data.functionId = row[2] as int;
      data.posCode = row[3] as String;
      if(row[4]!=null){
        if(row[4] is bool){
          data.active = row[4] ==true ? 1 : 0;
        } else {
          if(row[4] is int){
            data.active = row[4] as int;
          }
        }
      }

      newList.add(data);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);

    return responseApi;

  }
}