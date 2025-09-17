import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:postgres/postgres.dart';
import '../../../../../models/panel_sc_config.dart';
import 'postgres_provider_model.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/response_api.dart';
import '../../../../../models/sol_express_event.dart';
class SolExpressEventConfigProvider extends PostgresProviderModel{

  Future<ResponseApi> insert(List<PanelScConfig> data) async{
    String query ="""INSERT INTO public.config(event_name, logo_url, landing_url,
     barcode_length, place_id_length, show_progress_bar_each_x_times, time_offset_minutes,
      event_id, isactive, event_date)	VALUES ('${data[0].eventName}', '${data[0].logoUrl}', 
      '${data[0].landingUrl}', ${data[0].barcodeLength}, ${data[0].placeIdLength},
       ${data[0].showProgressBarEachXTimes}, ${data[0].timeOffsetMinutes},
        ${data[0].eventId},${data[0].isActive},'${data[0].eventDate}')  """;
    for(int i=1;i<data.length;i++){
      query += """,('${data[i].eventName}', '${data[i].logoUrl}', 
      '${data[i].landingUrl}', ${data[i].barcodeLength}, ${data[i].placeIdLength},
       ${data[i].showProgressBarEachXTimes}, ${data[i].timeOffsetMinutes},
        ${data[i].eventId},${data[i].isActive},'${data[i].eventDate}')  """;
    }
    query += " ON CONFLICT DO NOTHING RETURNING ID;";
    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null || result.isEmpty){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.CREATE}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    ResponseApi responseApi = ResponseApi(data: data,
        success: true,message: '${Messages.OK} : ($affectedRows) ${Messages.REGISTERS}');

    return responseApi;

  }

  Future<ResponseApi> updateData(BuildContext context, PanelScConfig data) async {
    //USER CANNOT EDIT EVENT ID
    String query =
        """UPDATE public.config SET event_name='${data.eventName}',
        logo_url='${data.logoUrl}', landing_url='${data.landingUrl}', barcode_length=${data.barcodeLength},
        place_id_length=${data.placeIdLength}, 
        show_progress_bar_each_x_times=${data.showProgressBarEachXTimes},
        time_offset_minutes=${data.timeOffsetMinutes}, isactive=${data.isActive},
        event_date='${data.eventDate}' WHERE id =${data.id} RETURNING id;""";
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
  Future<ResponseApi> deleteById(BuildContext context, PanelScConfig data) async {
    String query ='DELETE FROM public.config WHERE id = ${data.id} RETURNING *';
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
        success: true,message: '${Messages.DELETE} : ${data.id} : ${Messages.OK}');

    return responseApi;
  }
  
  Future<ResponseApi> findConfigByConfigEventName(PanelScConfig data) async {
    String name = data.eventName ?? '';
    String condition =" LOWER(event_name) like '%${name.toLowerCase()}%'";
    if(name.contains('%')){
      condition =" LOWER(event_name) like '${name.toLowerCase()}'";
    }
    String query = """
        SELECT id, event_name, logo_url, landing_url, barcode_length, place_id_length,
            show_progress_bar_each_x_times, time_offset_minutes, event_id, isactive,
            TO_CHAR(event_date, 'YYYY-MM-DD') as event_date 
            FROM public.config where  $condition order by event_name ;
        """;

    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<PanelScConfig> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${data.name}');
    }

    for(var row in result){

      int? id = int.tryParse(row[0].toString());
      String configEventName = row[1].toString();
      String logoUrl = row[2].toString();
      String landingUrl = row[3].toString();
      int? barcodeLength = int.tryParse(row[4].toString());
      int? placeIdLength = int.tryParse(row[5].toString());
      int? showProgressBarEachXTimes = int.tryParse(row[6].toString());
      int? timeOffsetMinutes = int.tryParse(row[7].toString());
      int? eventId = int.tryParse(row[8].toString());

      String eventDate = row[10].toString();

      PanelScConfig aux = PanelScConfig(id: id,
        eventName: configEventName,
        logoUrl: logoUrl,
        landingUrl: landingUrl,
        barcodeLength: barcodeLength,
        placeIdLength: placeIdLength,
        showProgressBarEachXTimes: showProgressBarEachXTimes,
        timeOffsetMinutes: timeOffsetMinutes,
        eventId: eventId,
        eventDate: eventDate,
      );
      if(row[9]!=null){
        if(row[9] is bool){
          aux.active = row[9] ==true ? 1 : 0;
        } else {
          if(row[9] is int){
            aux.active = row[9] as int;
          }
        }
      }
      newList.add(aux);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);

    return responseApi;

  }
  Future<ResponseApi> findConfigInEventId(SolExpressEvent data) async {
    String query = """
        SELECT id, event_name, logo_url, landing_url, barcode_length, place_id_length,
            show_progress_bar_each_x_times, time_offset_minutes, event_id, isactive,
            TO_CHAR(event_date, 'YYYY-MM-DD') as event_date 
            FROM public.config where  event_id =${data.id} order by event_date ;
        """;

    print(query);
    Result? result = await connectToPostgresAndExecuteQuery(query);
    if(result==null){
      return ResponseApi(success: false,message: '${Messages.ERROR_DATABASE_QUERY} : ${Messages.FIND}');
    }
    final affectedRows = result.length;
    print('----------affectedRows: $affectedRows');
    late List<PanelScConfig> newList =[] ;
    if(affectedRows==0){
      return ResponseApi(success: true,data: newList,
          message: '${Messages.NO_DATA_FOUND} : ${Messages.FIND} ${data.name}');
    }
    List<String> daysConfigured =[];
    for(var row in result){

      int? id = int.tryParse(row[0].toString());
      String configEventName = row[1].toString();
      String logoUrl = row[2].toString();
      String landingUrl = row[3].toString();
      int? barcodeLength = int.tryParse(row[4].toString());
      int? placeIdLength = int.tryParse(row[5].toString());
      int? showProgressBarEachXTimes = int.tryParse(row[6].toString());
      int? timeOffsetMinutes = int.tryParse(row[7].toString());
      int? eventId = int.tryParse(row[8].toString());

      String eventDate = row[10].toString();
      daysConfigured.add(eventDate);
      PanelScConfig aux = PanelScConfig(id: id,
        event : data,
        eventName: configEventName,
        logoUrl: logoUrl,
        landingUrl: landingUrl,
        barcodeLength: barcodeLength,
        placeIdLength: placeIdLength,
        showProgressBarEachXTimes: showProgressBarEachXTimes,
        timeOffsetMinutes: timeOffsetMinutes,
        eventId: eventId,
        eventDate: eventDate,
      );
      if(row[9]!=null){
        if(row[9] is bool){
          aux.active = row[9] ==true ? 1 : 0;
        } else {
          if(row[9] is int){
            aux.active = row[9] as int;
          }
        }
      }
      newList.add(aux);
    }


    ResponseApi responseApi = ResponseApi(data: newList,
        success: true,message: Messages.OK);
    data.daysConfigured = daysConfigured;
    for(String date in data.daysConfigured!){
      print('provider data.daysConfigured  $date');
      //eventDates.add(date);
    }

    return responseApi;

  }

}