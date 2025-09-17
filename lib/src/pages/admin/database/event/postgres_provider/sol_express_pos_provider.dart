import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';
import '../../../../../models/pos.dart';
import 'postgres_provider_model.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/response_api.dart';
class SolExpressPosProvider extends PostgresProviderModel{

  Future<ResponseApi> insert(BuildContext context,Pos data) async{
    String query ="INSERT INTO public.pos(id, name, function_id, code, isactive) "
        "VALUES (${data.id},'${data.name}', ${data.functionId}, "
        "'${data.posCode}',${data.isActive}) RETURNING id;";
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

  Future<ResponseApi> updateData(BuildContext context, Pos data) async {
    String query ="UPDATE public.pos SET name='${data.name}', function_id=${data.functionId}, "
        " isactive=${data.isActive}, code='${data.posCode}'"
        " WHERE id =${data.id} RETURNING id;";
    print(query);
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
  Future<ResponseApi> deleteById(BuildContext context, Pos data) async {
    String query ='DELETE FROM public.pos WHERE id = ${data.id} RETURNING *';
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.DELETE}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    if(affectedRows==0){
      return ResponseApi(success: false,message: '${Messages.NO_ROWS_AFFECTED} : ${Messages.DELETE}');
    }
    data.id = result.first.first as int;
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: '${Messages.DELETE} ${data.id?.toString()} : ${Messages.OK}');

    return responseApi;
  }
  Future<ResponseApi> findByName(Pos data) async {
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

}