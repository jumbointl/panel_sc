import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_controller_model.dart';
import 'package:solexpress_panel_sc/src/models/attendance.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/memory.dart';
import '../../../data/memory_panel_sc.dart';
import '../../../utils/sqflite/database_event_panel.dart';
import '../common/panel_controller_model.dart'; // For LogicalKeyboardKey

class RegisterAttendanceController extends PanelControllerModel {
  final RxSet<LogicalKeyboardKey> pressedKeys = <LogicalKeyboardKey>{}.obs;
  final RxString enteredText = ''.obs;
  final List<Attendance> attendances = <Attendance>[].obs;
  final List<Attendance> unprocessedAttendances = <Attendance>[].obs;
  late Database db;
  late DatabaseEventPanel databaseEventPanel;
  final RxBool isLogout = false.obs;

  bool timerStopped =false;
  Timer? timer = MemoryPanelSc.registerAttendanceTimer;

  RegisterAttendanceController(){
    initDatabase();
  }

  @override
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

    super.onClose();
  }
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

    await Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      return isLoading.value;
    }); // Wait until isLoading.value becomes false
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,
            (route) => route.settings.name == Memory.ROUTE_IDEMPIERE_LOGIN_PAGE); // ELIMINAR EL HISTORIAL DE PANTALLAS


  }
  void handleKeyEvent(BuildContext context, KeyEvent event) {
    if(isLoading.value){
      return;
    }
    if (event is KeyDownEvent) {
      pressedKeys.add(event.logicalKey);
      //print('Key Down: ${event.logicalKey}');

      // Save key label to enteredText until Enter is pressed
      if (event.logicalKey != LogicalKeyboardKey.enter && event.character != null) {
        enteredText.value += event.character!;
      }
    }

    /*else if (event is KeyUpEvent) {
      pressedKeys.remove(event.logicalKey);
      print('Key Up: ${event.logicalKey}');
    }*/

    // If Enter key is pressed, call scanned method and clear enteredText
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      //print('Key Enter: ${event.logicalKey}');
      if(context.mounted){
        scanned(context,enteredText.value);
        enteredText.value = ''; // Clear the text after processing
      }

    }
  }

  Future<void> scanned(BuildContext context, String value) async {
    // Implement what should happen when a code is "scanned" (Enter is pressed)
    print('Scanned value: $value');
    // Example: You might want to process the enteredText.value here
    insertAttendance(value);


  }
  /*
  Future<void> scanned(BuildContext context, String value) async {
    // Implement what should happen when a code is "scanned" (Enter is pressed)
    print('Scanned value: $value');
    // Example: You might want to process the enteredText.value here
    if(MemoryPanelSc.isValidCode(value)){
      isLoading.value = true;
      int? placeId = int.tryParse(value.substring(0, MemoryPanelSc.lengthPlaceId));
      Attendance attendance = Attendance(placeId: placeId,qr: value);
      insertAttendance(attendance);
      int? id = await connectToPostgresAndInsertAttendance(attendance);
      isLoading.value = false;
      if(id==null){
        if(context.mounted){
          typeCode(context, value);
        }
      }

    }

  }*/
  Future<void> typeCode(BuildContext context, String value) async {
    // Implement what should happen when a code is "scanned" (Enter is pressed)
    if(timerStopped){
      return;
    }
    String? newValue ;
    if(context.mounted){
      newValue = await showInputNumericDialog(context, Messages.BARCODE, Messages.BARCODE, value);
    }
    if(newValue==null){
      showErrorMessages(Messages.NO_REGISTERED);
      return;
    }
    int aux = MemoryPanelSc.panelScConfig.barcodeLength ?? MemoryPanelSc.barcodeLength;
    if(value.length>aux){
      value = value.substring(value.length-aux);

    }
    value = newValue;
    print('Scanned value: $value');
    insertAttendance(value);

  }


  Future<void> initDatabase() async {
    databaseEventPanel = DatabaseEventPanel();
    db = await databaseEventPanel.database;
    startTimerToSendAttendanceToServer();
  }

  Future<void> insertAttendance(String value) async {
    if(timerStopped){
      return;
    }
    if(MemoryPanelSc.isValidCode(value)){
      int aux = MemoryPanelSc.panelScConfig.barcodeLength ?? MemoryPanelSc.barcodeLength;
      if(value.length>aux){
        value = value.substring(value.length-aux);

      }

      int? id = await databaseEventPanel.insertIntoScanned(db, value);
      if(id!=null){
        int? placeId = int.tryParse(value.substring(0, MemoryPanelSc.placeIdLength));
        Attendance attendance = Attendance(placeId: placeId,qr: value);
        int rows = MemoryPanelSc.ROWS_SCANNED_TO_SHOW ;
        attendances.insert(0,attendance);
        if(attendances.length>rows){
          attendances.removeLast();
        }
        final result = await databaseEventPanel.getUnprocessedAttendance();
        unprocessedAttendances.clear();
        if (result.isNotEmpty) {
          List<Attendance> attendanceList = Attendance.fromJsonList(result);
          unprocessedAttendances.addAll(attendanceList);
          /*for (Attendance attendance in attendanceList) {
          print('attendance     ${attendance.toJson()}');
        }*/

        }



      }
    }
  }
  Future<void> startTimerToSendAttendanceToServer() async {
    int interval =MemoryPanelSc.intervalToRetrieveNewCalledAttendanceByGroups;

    timer = Timer.periodic(Duration(seconds: interval), (timer) async {

      if(timerStopped){
        timer.cancel();
        print('------------------timer cancel ttsStopped $timerStopped');
        return;
      }
      if(!isLoading.value){
        isLoading.value = true ;
        String? registerDate = MemoryPanelSc.panelScConfig.eventDate;
        List<Attendance>? aux = await databaseEventPanel.getUnprocessedAttendanceAndSendToServer(registerDate);

        if(aux!=null){
          //attendances.removeWhere((item) => !aux.any((auxItem) => auxItem.qr == item.qr));
          unprocessedAttendances.clear();
          unprocessedAttendances.addAll(aux);
        }

        isLoading.value = false ;

      }

    });

  }
  @override
  void buttonMorePressed() {
    print(MemoryPanelSc.panelScConfig.landingUrl ?? MemoryPanelSc.WEB_URL);
    //String url ='https://www.youtube.com/watch?v=icMPQ84mG1Y&t=7s';
    String url =MemoryPanelSc.panelScConfig.landingUrl ?? MemoryPanelSc.WEB_URL;

    Get.toNamed(
      Memory.ROUTE_WEB_VIEW_PAGE,
      arguments: url,
    );
  }
}