
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/models/sol_express_event.dart';
import 'package:solexpress_panel_sc/src/models/panel_sc_config.dart';
import 'package:solexpress_panel_sc/src/models/ticket.dart';

import '../models/attendance_by_group.dart';
import '../models/function_panel_sc.dart';
import '../models/host.dart';
import '../models/pos.dart';
import 'memory.dart';
import 'messages.dart';

class MemoryPanelSc extends Memory {
  static const String ROUTE_PANEL_SC_ROLES_PAGE = '/panel_sc/roles';
  static double fontSizeExtraBig = 40;
  static double fontSizeBig = 20;
  static double fontSizeMedium = 14;
  static String DB_NAME= 'panel_sc.db';
  static String ROUTE_PANEL_SC_CALLING_PAGE='/panel_sc/calling';
  static String ROUTE_PANEL_SC_HOME_PAGE='/panel_sc/home';
  static String ROUTE_PANEL_SC_LOGIN_PAGE='/panel_sc';



  static Color callingColor= Colors.blue[800]!;

  static const Color receivedColor =Colors.black;

  static List<Ticket> callingTickets = <Ticket>[].obs;
  static List<Ticket> newCallingTickets = <Ticket>[].obs;
  static RxBool isLoading = false.obs;
  static String fileHost1St='https://sc-demo.masverdecde.com';
  static String get videoPlaylistFileUrl {
    Host host = Host.fromGetStorage(GetStorage().read(Memory.KEY_APP_FILE_HOST_WITH_HTTP));
    String fileHost = fileHost1St;
    if(host.url!=null){
      fileHost = host.url!;
    }

    String id = GetStorage().read(Memory.KEY_ID);
    print('$fileHost/videos/config/videolist$id.txt');
    return '$fileHost/videos/config/videolist$id.txt';
  }
  static String get demoVideoUrl {
    Host host = Host.fromGetStorage(GetStorage().read(Memory.KEY_APP_FILE_HOST_WITH_HTTP));
    String fileHost = fileHost1St;
    if(host.url!=null){
      fileHost = host.url!;
    }
    return '$fileHost/videos/sample/demo.mp4';
  }
  static bool  repeatSpeaking = false;

  static PanelScConfig panelScConfig = PanelScConfig();
  static PanelScConfig panelScConfigByEvent = PanelScConfig();
  static Pos pos = Pos();
  static SolExpressEvent event = SolExpressEvent();
  static String get configurationFileUrl {
    Host host = Host.fromGetStorage(GetStorage().read(Memory.KEY_APP_FILE_HOST_WITH_HTTP));
    String fileHost = fileHost1St;
    if(host.url!=null){
      fileHost = host.url!;
    }
    print('-----------------------------------fileHost $fileHost');
    String id = GetStorage().read(Memory.KEY_ID);
    print('$fileHost/videos/config/config$id.txt');
    return '$fileHost/videos/config/config$id.txt';
  }
  static Host get customHost {
    var aux = GetStorage().read(Memory.KEY_COSTUM_URL) ;
    if(aux==null) {
          return
       Host(id:3,name: 'http://192.168.200.201',url: 'http://192.168.200.201:8090',active:1);
    }

    Host host = Host.fromGetStorage(aux) ;
    return host;
   }
  static FunctionPanelSc panelFunctionPanelSc =FunctionPanelSc(id:FUNCTION_PANEL,name: Messages.PANEL,active:1);
  static FunctionPanelSc callerFunctionPanelSc =FunctionPanelSc(id:FUNCTION_CALLER,name: Messages.CALLER,active:1);
  static FunctionPanelSc showAttendanceFunctionPanelSc =FunctionPanelSc(id:FUNCTION_SHOW_ATTENDANCE,name: Messages.SHOW_ATTENDANCE,active:1);
  static FunctionPanelSc registerAttendanceFunctionPanelSc =FunctionPanelSc(id:FUNCTION_REGISTER_ATTENDANCE ,name: Messages.REGISTER_ATTENDANCE,active:1);

  static List<FunctionPanelSc> getListFunctionPanelSc(){
    switch(Memory.TYPE_OF_PANEL){
      case Memory.EVENT_PANEL:
        return [showAttendanceFunctionPanelSc,registerAttendanceFunctionPanelSc];
      case Memory.SC_PANEL:
        return [panelFunctionPanelSc,callerFunctionPanelSc];
      default:
        return [panelFunctionPanelSc,callerFunctionPanelSc,showAttendanceFunctionPanelSc,registerAttendanceFunctionPanelSc];

    }

  }
  static const int  FUNCTION_PANEL = 1;
  static const int  FUNCTION_CALLER = 2;
  static const int  FUNCTION_SHOW_ATTENDANCE = 3;
  static const int  FUNCTION_REGISTER_ATTENDANCE = 4;
  static const int  FUNCTION_ADMIN_ATTENDANCE = 5;




  static Host productionHost1 =Host(id:1,name: 'https://sc-demo.masverdecde.com',url: 'https://sc-demo.masverdecde.com',active:1);
  static Host productionHost2 =Host(id:2,name: 'http://erp-sc.plantelmedico.com',url: 'http://erp-sc.plantelmedico.com',active:1);
  //static Host customHost =Host(id:3,name: 'http://192.168.200.201',url: 'http://192.168.200.201:8090',active:1);
  static List<Host> listFileHost =<Host>[productionHost1,productionHost2,customHost];

  static String FILE_SUB_PATH='panel_sc/videos';
  static String FILE_DOWNLOAD_PATH='/storage/emulated/0/Download/panel_sc/videos';

  static String defaultUserName='mylancd';
  static String defaultPassword='mylancd.159753';
  static String defaultPanelId='1';

  static double defaultVideoSoundVolumeWhenSpeaking =0.0;

  static double defaultVideoVolume=0.8;

  static RxList<String> playlist=<String>[].obs;

  //static String attendanceDbName='defaultdb';
  static String attendanceDbName='eventpanel';
  static String attendanceDbHost='db-postgresql-nyc1-58118-do-user-5998638-0.a.db.ondigitalocean.com';
  static int attendanceDbPort=25060;
  static String attendanceDbUser='eventpanel';
  //static String attendanceDbUser='doadmin';
  static String attendanceDbPassword='EventPanel.2025';
  //static String attendanceDbPassword='dv8gukp0isu70mli';

  static List<AttendanceByGroup>attendanceByGroup =<AttendanceByGroup>[];

  static int intervalToRetrieveNewCalledAttendanceByGroups = 10;
  static int intervalToShowProgressBar = 100;

  static int barcodeLength = 7;
  static int placeIdLength = 2;

  static const int EVENT_PANEL_COLUMNS_WIDTH = 480;

  static String TABLE_SCANNED='scanned';
  static int ROWS_SCANNED_TO_SHOW=10;

  static String IMAGE_EVENT_LOGO='assets/images/event_panel.png';

  static double EVENT_PANEL_LOGO_HEIGHT = 60;
  static double EVENT_PANEL_LOGO_WIDTH = 60;
  static Timer? readAttendanceTimer;
  static Timer? registerAttendanceTimer;
  static Timer? panelScTimer;
  static Timer? clockTimer;

  static int intervalToRefreshClockInSecond = 1;

  static String defaultFontSizeAdjustment='100';
  static String defaultLogoSizeAdjustment='100';
  static String defaultClockRightMarginAdjustment='0';

  static double fontSizeAdjustment=100;
  static double logoSizeAdjustment=100;
  static double clockRightMarginAdjustment=0;

  static String WEB_URL = 'https://www.youtube.com/watch?v=icMPQ84mG1Y&t=7s';

  static String ROUTE_WEB_VIEW_PAGE = Memory.ROUTE_WEB_VIEW_PAGE;

  static var defaultPosId='1001';

  static String defaultConfigId='1';

  static bool isValidCode(String value) {
    if(value.length<barcodeLength){
      return false;
    }
    return true;

  }

  static FunctionPanelSc getDefaultFunction() {

    switch(Memory.TYPE_OF_PANEL) {
      case Memory.EVENT_PANEL:
        return showAttendanceFunctionPanelSc;
      case Memory.SC_PANEL:
        return panelFunctionPanelSc;
      default:
        return showAttendanceFunctionPanelSc;
    }
  }

  static bool isValidFunctionId(int functionId) {
    switch(Memory.TYPE_OF_PANEL) {
      case Memory.EVENT_PANEL:
        return functionId==showAttendanceFunctionPanelSc.id || functionId==registerAttendanceFunctionPanelSc.id;
      case Memory.SC_PANEL:
        return functionId==panelFunctionPanelSc.id || functionId==callerFunctionPanelSc.id;
      default:
        return functionId==showAttendanceFunctionPanelSc.id || functionId==registerAttendanceFunctionPanelSc.id || functionId==panelFunctionPanelSc.id || functionId==callerFunctionPanelSc.id;
    }

  }
  static bool timerStarted = false;
  static bool timerStopped = false;

}