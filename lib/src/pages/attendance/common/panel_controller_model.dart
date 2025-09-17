

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postgres/postgres.dart';

import '../../../data/memory.dart';
import '../../../data/memory_panel_sc.dart';
import '../../../data/messages.dart';
import '../../../idempiere/common/idempiere_controller_model.dart';
import '../../../models/attendance_by_group.dart';
import '../../../models/idempiere/idempiere_user.dart';
import '../../../models/panel_sc_config.dart';
import '../../../models/place.dart';
import '../../../models/pos.dart';
import '../../../models/sol_express_event.dart';
import '../../../models/ticket.dart';
import '../../../models/ticket_owner.dart';

abstract class PanelControllerModel extends IdempiereControllerModel{
  bool timerStopped = MemoryPanelSc.timerStopped;
  bool isTimerStarted = MemoryPanelSc.timerStarted;
  bool loadedConfig = false;
  RxString title = ''.obs;
  Timer? timer = MemoryPanelSc.readAttendanceTimer;
  Timer? clockTimer = MemoryPanelSc.clockTimer;
  RxBool isClosing = false.obs;
  bool attendanceLoaded = false;

  Future<bool> connectToPostgresAndLoadAttendance() async{
    int? configId = MemoryPanelSc.panelScConfig.id;

    if(!MemoryPanelSc.showTotalAttendanceByEvent){
      if(configId==null){
        return false;
      }
    } else if(MemoryPanelSc.panelScConfig.eventId==null){
      return false;
    }
    String view = 'v_total_attendance_by_config_and_place';
    String query ="SELECT total, place_id, place_name, config_id FROM public.$view "
        "where config_id = $configId  order by total desc;";

    if(MemoryPanelSc.showTotalAttendanceByEvent){
      int eventId = MemoryPanelSc.panelScConfig.eventId!;
      view = 'v_total_attendance_by_event_and_place';
      query ="SELECT total, place_id, place_name, event_id FROM public.$view "
          "where event_id = $eventId  order by total desc;";
    }
    bool testMode = GetStorage().read(Memory.KEY_TEST_MODE) ?? false;
    if(testMode){
      view = 'v_total_attendance_test';
      query ="SELECT total, place_id, place_name, config_id FROM public.$view "
          "order by total desc;";
    }
    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;
    bool success = false;



    try {
      final conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      success = true;
      print('try loading attendance..');
      print('query $query');
      final result0 = await conn.execute(query);
      attendanceLoaded = true;
      MemoryPanelSc.attendanceByGroup.clear();
      for (final row in result0) {
        String placeName = row[2].toString();
        int? placeId = int.tryParse(row[1].toString());
        placeName = placeName.toUpperCase();
        Place place = Place(id: placeId,name: placeName);
        AttendanceByGroup attendanceByGroup = AttendanceByGroup(total: int.tryParse(row[0].toString()),place: place);
        MemoryPanelSc.attendanceByGroup.add(attendanceByGroup);

      }
      print('affectedRows      ${result0.affectedRows}');
      conn.close();

    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      // Return false or throw an exception as per your error handling strategy
    } finally{
      return success;
    }

  }
  Future<bool?> connectToPostgresAttendance() async{
    if(timerStopped){
      return false ;
    }

    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;

    try {
      final conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      print('login..');
      loadedConfig = true;
      String posId = GetStorage().read(Memory.KEY_POS_ID) ?? '1';

      String getConfig = """
        SELECT config_id, config_event_name, logo_url,
            landing_url, barcode_length, place_id_length,
            show_progress_bar_each_x_times, time_offset_minutes,
            event_id, config_isactive, event_date, 
            event_name, event_start_date, event_end_date,
            event_isactive, pos_id, pos_name, function_id,
            pos_code, pos_isactive
            FROM public.v_event_configuration  where
            event_date= Date(NOW() + INTERVAL  '1 minute' *time_offset_minutes )
            and  pos_id =$posId ;
        """;
      
      final resultConfig = await conn.execute(getConfig);
      if (resultConfig.isNotEmpty) {
        var row = resultConfig[0];
        int? id = int.tryParse(row[0].toString());
        String configEventName = row[1].toString();
        String logoUrl = row[2].toString();
        String landingUrl = row[3].toString();
        int? barcodeLength = int.tryParse(row[4].toString());
        int? placeIdLength = int.tryParse(row[5].toString());
        int? showProgressBarEachXTimes = int.tryParse(row[6].toString());
        int? timeOffsetMinutes = int.tryParse(row[7].toString());
        int? eventId = int.tryParse(row[8].toString());
        int? configIsActive = int.tryParse(row[9].toString());
        String eventDate = row[10].toString();
        String eventName = row[11].toString();
        String eventStartDate = row[12].toString();
        String eventEndDate = row[13].toString();
        int? eventIsActive = int.tryParse(row[14].toString());
        MemoryPanelSc.event = SolExpressEvent(
            id: eventId,
            name: eventName,
            eventStartDate: eventStartDate,
            eventEndDate: eventEndDate,
            active: eventIsActive
        );
        MemoryPanelSc.pos = Pos(
            id: int.tryParse(row[15].toString()),
            name: row[16].toString(),
            functionId: int.tryParse(row[17].toString()),
            posCode: row[18].toString(),
            active: int.tryParse(row[19].toString())
        );
        MemoryPanelSc.panelScConfig = PanelScConfig(id: id,
          event : MemoryPanelSc.event,
          eventName: configEventName,
          logoUrl: logoUrl,
          landingUrl: landingUrl,
          barcodeLength: barcodeLength,
          placeIdLength: placeIdLength,
          showProgressBarEachXTimes: showProgressBarEachXTimes,
          timeOffsetMinutes: timeOffsetMinutes,
          eventId: eventId,
          eventDate: eventDate,
          active: configIsActive,
        );




      } else {
        return false;
      }
      conn.close();
      return true;
    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      // Return false or throw an exception as per your error handling strategy
      return null;
    }

  }
  Future<bool?> connectToPostgresAdmin(String code) async{
    if(timerStopped){
      return false ;
    }

    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;
    late Connection conn ;

    try {
        conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      print('login..');
      loadedConfig = true;
      String posId = GetStorage().read(Memory.KEY_POS_ID) ?? '1';
      String codeFilter = '';
      if(code.isNotEmpty){
        codeFilter = " and code = '$code'";
      }
      //function_id=5 = admin
      String getConfig = """
        SELECT id, name, function_id, code, isactive
	      FROM public.pos WHERE id =$posId  and function_id = 5
            $codeFilter ;
        """;
      print('getConfig $getConfig');
      final resultConfig = await conn.execute(getConfig);

      if (resultConfig.isNotEmpty) {
        GetStorage().write(Memory.KEY_ADMIN_CODE, code);
        return true;
      }

      return false;
    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      // Return false or throw an exception as per your error handling strategy
      return null;
    } finally {
      conn.close();
    }

  }


  Future<bool> connectToPostgresAndLoadTicket(IdempiereUser user) async{
    //String host = Memory.APP_PostgresSQL_HOST_NAME;
    String host = Memory.APP_HOST_NAME_WITHOUT_HTTP;

    String dbName = Memory.dbName;
    int dbPort = Memory.dbPort;
    String dbUser = user.name ?? '';
    String dbPassword = user.password ??'';
    bool success = false;
    String sectorIds = MemoryPanelSc.panelScConfig.sectorsIn ?? MemoryPanelSc.defaultPanelId;


    try {
      final conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.disable),
      );
      String date = DateTime.now().toIso8601String();
      date = date.split('T').first;
      print('has connection!---------------- $date');
      success = true;
      print('has connection!');
      // You might want to return true here if connection is successful
      String query ="SELECT a.c_bpartner_id as c_bpartner_id,  c.name,  c.name2, "
          "a.srmd_consultorios_id,  co.name as consultorio, srmd_llamar, srmd_atendiendo, "
          "srmd_atendido, srmd_agendamedica_ID, srmd_starttime, srmd_endtime, srmd_sectores_id"
          " FROM adempiere.srmd_agendamedica as a, adempiere.c_bpartner as c ,"
          " srmd_consultorios as co where  a.c_bpartner_id=c.c_bpartner_id and"
          " co.srmd_consultorios_id =a.srmd_consultorios_id and a.srmd_llamar='Y'"
          " and srmd_atendiendo='N' and a.srmd_starttime='$date' "
          " and srmd_sectores_id in($sectorIds);";

      /*String query ="SELECT a.c_bpartner_id as c_bpartner_id,  c.name,  c.name2, "
          "a.srmd_consultorios_id,  co.name as consultorio, srmd_llamar, srmd_atendiendo, "
          "srmd_atendido, srmd_agendamedica_ID, srmd_starttime, srmd_endtime, srmd_sectores_id"
          " FROM adempiere.srmd_agendamedica as a, adempiere.c_bpartner as c ,"
          " srmd_consultorios as co where  a.c_bpartner_id=c.c_bpartner_id and"
          " co.srmd_consultorios_id =a.srmd_consultorios_id and a.srmd_llamar='Y'"
          " and a.srmd_atendiendo='N'";*/

      print('query $query');
      final result0 = await conn.execute(query);
      for (final row in result0) {

        String placeName = row[4].toString();
        if(!placeName.toUpperCase().contains('CONSULTORIO')){
          placeName ='CONSULTORIO ${row[4].toString()}';
        }
        String? nameOwner ;
        if(row[2]==null){
          String? aux = row[1].toString();
          String name = '';
          if(aux.contains(' ')){
            int totalIndex = 0;
            aux.split(' ').forEach((element) {
              totalIndex++;

            });
            if(totalIndex<=2){
              nameOwner = aux;
            } else {
              int index = 0;
              nameOwner ='';
              aux.split(' ').forEach((element) {
                index++;
                if(element.isNotEmpty){
                  if(index==1 || index==3){
                    nameOwner  = '$nameOwner  $element';
                  }
                }

              });
            }



          }

        } else {
          nameOwner = row[2].toString();
        }
        TicketStatus status = TicketStatus.none;
        if(row[5]=='Y'){
          status = TicketStatus.called;
        }
        if(row[6]==1) {
          status = TicketStatus.received;
        }
        if(row[7]==1) {
          status = TicketStatus.finished;
        }
        Ticket ticket = Ticket(
          id: int.tryParse(row[8].toString()),
          name: 'CONSULTA',
          place: Place(id: int.tryParse(row[3].toString()) ,name: placeName),
          owner: TicketOwner(id: int.tryParse(row[0].toString()), name: nameOwner),
          status: status,

        );

        MemoryPanelSc.newCallingTickets.add(ticket);

      }

      print('result0.affectedRows      ${result0.affectedRows}');
      if(MemoryPanelSc.callingTickets.isNotEmpty) {
        for (int i = MemoryPanelSc.callingTickets.length - 1; i > -1; i--) {
          Ticket ticket = MemoryPanelSc.callingTickets[i];
          bool exist = false;
          if (MemoryPanelSc.newCallingTickets.where((element) =>
          element.id == ticket.id).isNotEmpty) {
            exist = true;
          }
          if (!exist) MemoryPanelSc.callingTickets.removeAt(i);
        }

        for (int i = MemoryPanelSc.newCallingTickets.length - 1; i >-1; i--) {
          Ticket ticket = MemoryPanelSc.newCallingTickets[i];
          bool exist = false;
          if (MemoryPanelSc.callingTickets.where((element) =>
          element.id == ticket.id).isNotEmpty) {
            exist = true;
          }
          if (exist) MemoryPanelSc.newCallingTickets.removeAt(i);
        }
      }

      conn.close();
      /*bool exist = false;
      if(MemoryPanelSc.inicialCallingTickets.where((element) => element.id==ticket.id).isNotEmpty){
        exist = true;
      }
      if(!exist) MemoryPanelSc.inicialCallingTickets.add(ticket);*/





    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      // Return false or throw an exception as per your error handling strategy
    } finally{
      return success;
    }

  }

  Future<List<PanelScConfig>> getEventConfigs() async{
    List<PanelScConfig> events = <PanelScConfig>[];

    String host = MemoryPanelSc.attendanceDbHost;
    String dbName = MemoryPanelSc.attendanceDbName;
    int dbPort = MemoryPanelSc.attendanceDbPort;
    String dbUser = MemoryPanelSc.attendanceDbUser;
    String dbPassword = MemoryPanelSc.attendanceDbPassword;
    bool success = false;

    try {
      final conn = await Connection.open(
        Endpoint(
          host: host,
          database: dbName,
          username: dbUser,
          password: dbPassword,
          port: dbPort,
        ),
        // The postgres server hosted locally doesn't have SSL by default. If you're
        // accessing a postgres server over the Internet, the server should support
        // SSL and you should swap out the mode with `SslMode.verifyFull`.
        settings: ConnectionSettings(sslMode: SslMode.require),
      );
      success = true;
      String posId = GetStorage().read(Memory.KEY_POS_ID) ?? '1';
      int? eventId = MemoryPanelSc.panelScConfig.eventId;
      if(eventId==null){
        return events;
      }

      String getConfig = """
          SELECT config_id, config_event_name, logo_url,
              landing_url, barcode_length, place_id_length,
              show_progress_bar_each_x_times, time_offset_minutes,
              event_id, config_isactive, event_date, 
              event_name, event_start_date, event_end_date,
              event_isactive, pos_id, pos_name, function_id,
              pos_code, pos_isactive
              FROM public.v_event_configuration  where
              event_id= $eventId
              and  pos_id =$posId order by event_date;
          """;
      final resultConfig = await conn.execute(getConfig);
      if (resultConfig.isNotEmpty) {
        for (final row in resultConfig) {
          int? id = int.tryParse(row[0].toString());
          String configEventName = row[1].toString();
          String logoUrl = row[2].toString();
          String landingUrl = row[3].toString();
          int? barcodeLength = int.tryParse(row[4].toString());
          int? placeIdLength = int.tryParse(row[5].toString());
          int? showProgressBarEachXTimes = int.tryParse(row[6].toString());
          int? timeOffsetMinutes = int.tryParse(row[7].toString());
          int? eventId = int.tryParse(row[8].toString());
          int? configIsActive = int.tryParse(row[9].toString());
          String eventDate = row[10].toString();

          PanelScConfig panelScConfig = PanelScConfig(id: id,
            name: configEventName,
            eventName: configEventName,
            logoUrl: logoUrl,
            landingUrl: landingUrl,
            barcodeLength: barcodeLength,
            placeIdLength: placeIdLength,
            showProgressBarEachXTimes: showProgressBarEachXTimes,
            timeOffsetMinutes: timeOffsetMinutes,
            eventId: eventId,
            eventDate: eventDate,
            active: configIsActive,
          );
          events.add(panelScConfig);
        }



      }
      conn.close();
      return events;
    } catch (e) {
      print('Error connecting to PostgresSQL: $e');
      // Return false or throw an exception as per your error handling strategy
      return events;
    }

  }
  void showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> goToEventConfigPage(BuildContext context) async {
    isClosing.value = true;
    timerStopped = true;
    timer?.cancel();
    clockTimer?.cancel();
    await Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      print('awaiting isLoading.value to false== actual value ${isLoading.value}');

      return isLoading.value;
    });

    isClosing.value = false;
    timerStopped = false;
    isTimerStarted = false;
    Get.toNamed(Memory.ROUTE_PANEL_EVENT_CONFIG_PAGE);

  }
  void showAutoCloseMessages(BuildContext context, String message,Color color,int secounds) async {
    await AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      autoDismiss: true,
      autoHide: Duration(seconds: secounds),
      body: Center(child: Text(
        message,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),),
      title: '${Messages.EVENT}?',
      desc:   '',

    ).show();

  }
  void showAutoCloseQuestionMessages(BuildContext context, String message,Color color,int secounds) async {
    await AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      autoDismiss: true,
      autoHide: Duration(seconds: secounds),
      body: Center(child: Text(
        message,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),),
      title: '${Messages.EVENT}?',
      desc:   '',

    ).show();

  }
  void showAutoCloseErrorMessages(BuildContext context, String message,Color color,int seconds) async {
    await AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      autoDismiss: true,
      autoHide: Duration(seconds: seconds),
      body: Center(child: Text(
        message,
        style: TextStyle(fontStyle: FontStyle.italic),
      ),),
      title: '${Messages.EVENT}?',
      desc:   '',

    ).show();

  }
}