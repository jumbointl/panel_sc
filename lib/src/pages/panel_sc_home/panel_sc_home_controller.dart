import 'dart:async';
import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/memory_panel_sc.dart';
import '../../idempiere/common/idempiere_controller_model.dart';
import '../../models/idempiere/idempiere_user.dart';
import '../../models/panel_sc_config.dart';
import '../../models/ticket.dart';
import '../../data/memory.dart';

import '../attendance/common/panel_controller_model.dart';
import '../video/video_play_list_screen.dart';


class PanelScHomeController extends PanelControllerModel {
  late FlutterTts flutterTts;
  late IdempiereUser user  ;
  final List<Ticket> callingTickets = MemoryPanelSc.callingTickets;
  PanelScConfig panelScConfig = PanelScConfig();
  Timer? timer = MemoryPanelSc.panelScTimer;
  bool isTimerStarted = false ;
  bool onlyTv =false;
  bool ttsStopped = false;
  late VideoPlaylistController videoPlaylistController ;
  var downloadedFiles =<String>[].obs;
  late List<String> playlist;

  PanelScHomeController(){
    panelScConfig = MemoryPanelSc.panelScConfig;
    onlyTv = GetStorage().read(Memory.KEY_ONLY_TV) ?? false;
    user = getSavedIdempiereUser();
    startCalling();



  }
  Future<void> initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage(panelScConfig.languageOfSpeech ?? "es-ES");
    print('------------------------speedOfSpeech  ${panelScConfig.speedOfSpeech}');
    await flutterTts.setSpeechRate(panelScConfig.speedOfSpeech ?? 0.30); // Speed of speech
    await flutterTts.setVolume(panelScConfig.videoSoundVolume ?? MemoryPanelSc.defaultVideoVolume);
    await flutterTts.awaitSpeakCompletion(true); // Ensure completion is awaited
    // Other initialization settings like language, pitch, rate etc.
  }
  @override
  dispose() {
    print('------------------------dispose');
    stopTts();
    super.dispose();


  }
  @override
  onClose(){
    stopTts();
    print('------------------------onClose');
    super.onClose();

  }
  Future<void> stopTts() async {
    callingTickets.clear();
    ttsStopped = true;
    if(onlyTv){
      return;
    }
    try{
      timer?.cancel();
      timer = null;
    } catch(e){
      print('---------------------------------------timer cancel $e');
    }
    await flutterTts.stop();
  }

  @override
  void signOut() async {
    MemoryPanelSc.newCallingTickets.clear();
    await stopTts();
    await Future.delayed(const Duration(seconds: 1));
    ttsStopped = true ;
    if(timer!=null && timer!.isActive){
      timer!.cancel();
      timer = null;
    }
    await Future.doWhile(() async {
      await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
      return isLoading.value;
    });


    //Get.back();
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,
            (route) => route.settings.name == Memory.ROUTE_IDEMPIERE_LOGIN_PAGE); // ELIMINAR EL HISTORIAL DE PANTALLAS


  }


  Future<List<String>> readLocalFileLines(String filePath) async {
    print('------------------readLocalFileLines $filePath');
    File file = File(filePath);
    if (!await file.exists()) {
      return [];
    }
    List<String> lines = [];
    lines = await file.readAsLines();
    return lines.where((line) => line.isNotEmpty).toList();
  }
  Future<void> startTimerToRetrieveNewCalledTickets() async {
    int interval =panelScConfig.dBQueryIntervalInSeconds ?? 10;
    IdempiereUser user = getSavedIdempiereUser();
    if(user.password==null){
      return;
    }

    timer = Timer.periodic(Duration(seconds: interval), (timer) async {

      if(ttsStopped){
        timer.cancel();
        print('------------------timer cancel ttsStopped $ttsStopped');
        return;
      }

      if(!isLoading.value){
        isLoading.value = true ;
        await connectToPostgresAndLoadTicket(user);
        await readTicket();
        isLoading.value = false ;

      }

    });

  }


  Future<void> startCalling()async{


    if(!onlyTv){
      /*// Wait until all files are downloaded before initializing TTS and reading tickets
      // This ensures that configuration files are available.
      int checkCount = 0;
      while (!allFilesDownloaded.value && checkCount < 5) {
        await Future.delayed(const Duration(seconds: 30));
        checkCount++;
        print('Checking allFilesDownloaded.value attempt: $checkCount, value: ${allFilesDownloaded.value}');
      }

      if (!allFilesDownloaded.value) {
        print('Failed to download all files after 5 attempts.');
        // Handle the error case, perhaps show a message to the user or retry later.
      }*/
      await initTts();
      await readTicket();
    }

  }
  Future<void> addCallingTicket(Ticket ticket) async{

    callingTickets.insert(0,ticket);
    update();
    await speedCallingTickets(ticket);

  }
  Future<void> speedCallingTickets(Ticket ticket) async{
    videoPlaylistController = Get.find<VideoPlaylistController>();
    double volume = panelScConfig.videoSoundVolume ?? MemoryPanelSc.defaultVideoVolume;
    double volumeWhenSpeaking = panelScConfig.videoSoundVolumeWhenSpeaking ?? MemoryPanelSc.defaultVideoSoundVolumeWhenSpeaking;

    await Future.delayed(Duration(seconds: 1));
    String display =ticket.display();
    if(display==''){
      return ;
    }
    videoPlaylistController.videoPlayerController.setVolume(volumeWhenSpeaking);
    await Future.delayed(Duration(seconds: 1));
    await flutterTts.speak(display);
    if(panelScConfig.repeatSpeaking == true){
      int aux = panelScConfig.repeatSpeakingTimes ?? 1;
      for (int i = 0; i < aux; i++) {
        await Future.delayed(Duration(seconds: 3));
        await flutterTts.speak(display);
      }
    }
    await Future.delayed(Duration(seconds: 1));
    videoPlaylistController.videoPlayerController.setVolume(volume);

  }


  Future<void> readTicket() async{

    isLoading.value = true ;
    await Future.delayed(const Duration(seconds: 5));
    for (int i = 0; i < MemoryPanelSc.newCallingTickets.length; i++) {

      Ticket ticket = MemoryPanelSc.newCallingTickets[i];
      await addCallingTicket(ticket);
      await Future.delayed(const Duration(seconds: 10));

    }
    MemoryPanelSc.newCallingTickets.clear();
    isLoading.value = false ;
    if(!isTimerStarted){
      isTimerStarted = true ;
      startTimerToRetrieveNewCalledTickets();

    }
  }






}