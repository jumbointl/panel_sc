import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/pages/admin/database/event/postgres_provider/postgres_provider_model.dart';
import '../../../../../models/place.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/response_api.dart';
class SolExpressPlaceProvider extends PostgresProviderModel {

  Future<ResponseApi> insert(BuildContext context,Place data) async{
    String query ="INSERT INTO public.place(id, name) "
        "VALUES (${data.id},'${data.name}') RETURNING id;";
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

  Future<ResponseApi> updateData(BuildContext context, Place data) async {
    String query ="UPDATE public.place SET name='${data.name}'"
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
  Future<ResponseApi> deleteById(BuildContext context, Place data) async {
    String query ='DELETE FROM public.place WHERE id = ${data.id} RETURNING *';
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
  Future<ResponseApi> findByName(Place data) async {
    String name = data.name ?? '';

    String condition =" LOWER(name) like '%${name.toLowerCase()}%'";
    if(name.contains('%')){
      condition =" LOWER(name) like '${name.toLowerCase()}'";
    }
    String query ="SELECT id, name"
        "FROM public.place where $condition order by name ;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<Place> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${data.name}');
    }

    for(var row in result){
      Place data = Place(id: null, name: '');
      data.id = row[0] as int;
      data.name = row[1] as String;
      newList.add(data);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);

    return responseApi;

  }

}