import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'postgres_provider_model.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/response_api.dart';
import '../../../../../models/sol_express_event.dart';
class SolExpressEventsProvider extends PostgresProviderModel{

  Future<ResponseApi> insert(BuildContext context,SolExpressEvent data) async{
    String query ="INSERT INTO public.event(name, event_start_date, isactive, event_end_date)"
        "VALUES ('${data.name}', '${data.eventStartDate}', "
        "${data.isActive},'${data.eventEndDate}') RETURNING id;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.CREATE}');
    }
    data.id = result.first.first as int;
    print(data.toJson());
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: Messages.OK);

    return responseApi;

  }

  Future<ResponseApi> updateData(BuildContext context, SolExpressEvent data) async {
    String query ="UPDATE public.event SET name='${data.name}', event_start_date='${data.eventStartDate}',"
        " isactive=${data.isActive}, event_end_date='${data.eventEndDate}'"
        " WHERE id =${data.id} RETURNING id;";
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.UPDATE}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    if(affectedRows==0){
      return ResponseApi(success: false,message: '${Messages.NO_ROWS_AFFECTED} : ${Messages.UPDATE}');
    }

    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: Messages.OK);

    return responseApi;
  }
  Future<ResponseApi> deleteById(BuildContext context, SolExpressEvent data) async {
    String query1 ='DELETE FROM public.config WHERE event_id = ${data.id} RETURNING id;';
    String query2 ='DELETE FROM public.event_has_pos WHERE event_id = ${data.id} RETURNING event_id;';
    String query3 ='DELETE FROM public.event WHERE id = ${data.id} RETURNING id;';
    List<String> queries = [query1,query2,query3];
    List<Result> results = await connectToPostgresAndExecuteMultipleQueriesInTransaction(queries);
    if(results.isEmpty || results.length!=queries.length){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_TRANSACTION} : ${Messages.DELETE}');
    }
    final affectedRows = results[2].length;
    print('----------affectedRows: $affectedRows');
    if(affectedRows==0){
      return ResponseApi(success: false,message: '${Messages.NO_ROWS_AFFECTED} : ${Messages.DELETE}');
    }
    data.id = results[2].first.first as int;
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: '${Messages.DELETE} ${data.id?.toString()} : ${Messages.OK}');

    return responseApi;
  }
  Future<ResponseApi> findByName(SolExpressEvent data) async {
    String name = data.name ?? '';

    String condition =" LOWER(name) like '%${name.toLowerCase()}%'";
    if(name.contains('%')){
      condition =" LOWER(name) like '${name.toLowerCase()}'";
    }
    String query ="SELECT id,name, TO_CHAR(event_start_date, 'YYYY-MM-DD') as event_start_date ,"
        " TO_CHAR(event_end_date, 'YYYY-MM-DD') as event_end_date ,isactive	"
        "FROM public.event where $condition  order by name ;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<SolExpressEvent> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${data.name}');
    }

    for(var row in result){
      SolExpressEvent data = SolExpressEvent();
      data.id = row[0] as int;
      data.name = row[1] as String;
      data.eventStartDate = row[2] as String;
      data.eventEndDate = row[3] as String;
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
  Future<ResponseApi> findLatestEvents() async {
    int limit = MemoryPanelSc.SQL_QUERY_ALL_LIMIT;
    String condition =" order by event_start_date desc,name limit $limit";

    String query ="SELECT id,name, TO_CHAR(event_start_date, 'YYYY-MM-DD') as event_start_date ,"
        " TO_CHAR(event_end_date, 'YYYY-MM-DD') as event_end_date ,isactive	"
        "FROM public.event where isactive = true $condition;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<SolExpressEvent> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND}');
    }

    for(var row in result){
      SolExpressEvent data = SolExpressEvent();
      data.id = row[0] as int;
      data.name = row[1] as String;
      data.eventStartDate = row[2] as String;
      data.eventEndDate = row[3] as String;
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