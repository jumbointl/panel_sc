import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/pages/attendance/common/panel_controller_model.dart';
import '../../../data/memory_panel_sc.dart';
import '../../../idempiere/common/idempiere_controller_model.dart';
import '../../../models/attendance_by_group.dart';
import '../../../data/memory.dart';


class ShowAttendanceLiveController extends PanelControllerModel {
  List<AttendanceByGroup> attendanceByGroups = <AttendanceByGroup>[].obs;
  Timer? timer = MemoryPanelSc.readAttendanceTimer;
  Timer? clockTimer = MemoryPanelSc.clockTimer;

  int screenColumns = 1;

  RxString actualTime = ''.obs;
  double fontSizeExtraBig = MemoryPanelSc.fontSizeExtraBig;
  double fontSizeBig = MemoryPanelSc.fontSizeBig;
  double fontSizeMedium = MemoryPanelSc.fontSizeMedium;


  ShowAttendanceLiveController(){
    //showTotalAttendanceByEvent = Get.arguments[Memory.KEY_SHOW_TOTAL_ATTENDANCE_BY_EVENT] ?? false;
    DateTime now = DateTime.now();
    print(now.toIso8601String().substring(5,19));
    String time = now.toIso8601String().substring(5,19);
    actualTime.value = time.replaceAll('T', ' ');
    readAdjustment();
    if(!isTimerStarted){
      isTimerStarted = true ;
      startTimerToRetrieveNewCalledAttendanceByGroups();
    }

  }
 /*@override
  void onClose() {
    // TODO: implement onClose
   if(timer!=null && timer!.isActive){
     try{
       timer!.cancel();
       timer = null;
       print('------------------timer cancel onClose');
     }catch(e){
       print(e);
     }
   }
   if(clockTimer!=null && clockTimer!.isActive){
     try{
       clockTimer!.cancel();
       clockTimer= null;
       print('------------------clockTimer cancel onClose');
     }catch(e){
       print(e);
     }
   }

    super.onClose();
  }*/
  @override
  dispose(){
    if(timer!=null && timer!.isActive){
      try{
        timer!.cancel();
        timer = null;
        print('------------------timer cancel dispose');
      }catch(e){
        print(e);
      }
    }
    if(clockTimer!=null && clockTimer!.isActive){
      try{
        clockTimer!.cancel();
        clockTimer= null;
        print('------------------clockTimer cancel dispose');
      }catch(e){
        print(e);
      }
    }

    super.dispose();
  }

  @override
  void signOut() async {
    MemoryPanelSc.attendanceByGroup.clear();
    timerStopped = true;
    loadedConfig = false;
    if(timer!=null && timer!.isActive){
      try{
        timer!.cancel();
        timer = null;
        print('------------------timer cancel signOut');
      }catch(e){
        print(e);
      }
    }
    if(clockTimer!=null && clockTimer!.isActive){
      try{
        clockTimer!.cancel();
        clockTimer= null;
        print('------------------clockTimer cancel singOut');
      }catch(e){
        print(e);
      }
    }
    await Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      print('awaiting isLoading.value to false== actual value ${isLoading.value}');

      return isLoading.value;
    }); // Wait until isLoading.value becomes false
    if(timer!=null && timer!.isActive){
      try{
        timer!.cancel();
        timer = null;
        print('------------------timer cancel signOut 2');
      }catch(e){
        print(e);
      }
    }
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,
            (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS

   // Get.back();

  }


  Future<void> startTimerToRetrieveNewCalledAttendanceByGroups() async {
    int interval =MemoryPanelSc.intervalToRetrieveNewCalledAttendanceByGroups;
    timer = Timer.periodic(Duration(seconds:interval), (timer) async {
      if(timerStopped){
        timer.cancel();
        print('------------------timer cancel ttsStopped $timerStopped');
        return;
      }
      if(!isLoading.value){
        isLoading.value = true ;
        bool success = await connectToPostgresAndLoadAttendance();
        if(success){
          readAttendanceByGroup();
        }

        isLoading.value = false ;

      }

    });
    int intervalClock =MemoryPanelSc.intervalToRefreshClockInSecond;
    clockTimer = Timer.periodic(Duration(seconds: intervalClock), (timer) async {
      if(timerStopped){
        clockTimer?.cancel();
        print('------------------clockTimer cancel ttsStopped $timerStopped');
        return;
      }
      DateTime now = DateTime.now();
     /* print(now.timeZoneName); // Returns a timezone abbreviation (e.g., "EDT", "CST")
      print(now.timeZoneOffset); // Returns the UTC offset (e.g., -04:00:00.000000)
      print(now.toIso8601String().substring(5,19));*/
      String time = now.toIso8601String().substring(5,19);
      actualTime.value = time.replaceAll('T', ' ');
    });
  }


  void readAttendanceByGroup() {

    //isLoading.value = true ;
    //await Future.delayed(const Duration(seconds: 5));
    attendanceByGroups.clear();
    attendanceByGroups.addAll(MemoryPanelSc.attendanceByGroup);

    //isLoading.value = false ;

  }

  void readAdjustment() {

    fontSizeExtraBig = MemoryPanelSc.fontSizeExtraBig = MemoryPanelSc.fontSizeExtraBig*MemoryPanelSc.fontSizeAdjustment;
    fontSizeBig = MemoryPanelSc.fontSizeBig = MemoryPanelSc.fontSizeBig*MemoryPanelSc.fontSizeAdjustment;
    fontSizeMedium = MemoryPanelSc.fontSizeMedium = MemoryPanelSc.fontSizeMedium*MemoryPanelSc.fontSizeAdjustment;


  }









}