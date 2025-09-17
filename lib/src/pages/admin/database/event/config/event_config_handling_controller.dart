import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/panel_sc_config.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/sol_express_event.dart';
import '../../../../common/active_dropdown.dart';
import '../../../../common/controller_model.dart';
import '../postgres_provider/sol_express_event_config_provider.dart';
import '../postgres_provider/sol_express_events_provider.dart';


class EventConfigHandlingController extends ControllerModel {
  SolExpressEventConfigProvider provider = SolExpressEventConfigProvider();
  SolExpressEventsProvider eventsProvider = SolExpressEventsProvider();
  List<SolExpressEvent> eventResults =<SolExpressEvent>[].obs;
  SolExpressEvent? eventResult;
  RxString idEventResult = ''.obs;

  RxString idConfigResult = ''.obs;
  List<PanelScConfig> configResults =<PanelScConfig>[].obs;
  PanelScConfig? configResult ;


  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;

  bool createPage= false ;
  int minimumCharacters = 3;

  TextEditingController idController= TextEditingController();
  TextEditingController eventNameController= TextEditingController();
  TextEditingController logoUrlController= TextEditingController();
  TextEditingController landingUrlController= TextEditingController();
  TextEditingController barcodeLengthController= TextEditingController();
  TextEditingController placeIdLengthController= TextEditingController();
  TextEditingController timeOffsetMinutesController= TextEditingController();
  TextEditingController showProgressBarEachXTimesController= TextEditingController();

  List<String> eventDates =<String>[].obs;
  RxString eventDate = ''.obs;
  RxBool asTemplate = false.obs;

  List<String> selectedEventDatesItems = <String>[].obs;

  EventConfigHandlingController(){

      getLatestEvents();
  }

  void deleteById(BuildContext context) async {

    if(configResult==null || configResult!.id==null || configResult!.id! <=0){
      showErrorMessages('${Messages.CONFIG_ID} : ${configResult?.id}');
      return;
    }
    isLoading.value = true;
    ResponseApi responseApi = await provider.deleteById(context,configResult!);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.DELETE);
      findConfigInEventId();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }
  void create(BuildContext context) async {
    if(selectedEventDatesItems.isEmpty){
      showErrorMessages('${Messages.EVENT_DATE} : ${Messages.EMPTY}');
      return;
    }
    String  id = idConfigResult.value;
    int ? obId = int.tryParse(id);
    if(obId!=null && obId >=0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }

    String  eventName = eventNameController.text.trim();
    if(eventName.isEmpty){
      showErrorMessages('${Messages.NAME} : $eventName');
      return;
    }
    String logoUrl = logoUrlController.text.trim();
    if(logoUrl.isEmpty){
      showErrorMessages('${Messages.LOGO} : $logoUrl');
      return;
    }

    String?  landingUrl ;
    landingUrl = landingUrlController.text.trim();
    if(landingUrl.isEmpty){
      showErrorMessages('${Messages.IMAGE} : $landingUrl');
      return;
    }
    String  barcodeLength = barcodeLengthController.text.trim();
    int? barcodeLengthInt = int.tryParse(barcodeLength);
    if(barcodeLengthInt==null || barcodeLengthInt<=0){
      showErrorMessages('${Messages.BARCODE_LENGTH} : $barcodeLength');
      return;
    }
    String  placeIdLength = placeIdLengthController.text.trim();
    int? placeIdLengthInt = int.tryParse(placeIdLength);
    if(placeIdLengthInt==null || placeIdLengthInt<=0){
      showErrorMessages('${Messages.PLACE_ID_LENGTH} : $placeIdLength');
      return;
    }
    int? showProgressBarEachXTimes = int.tryParse(showProgressBarEachXTimesController.text.trim());
    if(showProgressBarEachXTimes==null || showProgressBarEachXTimes<=0){
      showErrorMessages('${Messages.SHOW_PROGRESS_BAR_EACH_X_TIMES} : $showProgressBarEachXTimes');
      return;
    }
    int? timeOffsetMinutes = int.tryParse(timeOffsetMinutesController.text.trim());
    if(timeOffsetMinutes==null || timeOffsetMinutes.obs()>1440){
      showErrorMessages('${Messages.TIME_OFFSET_MINUTES} : $timeOffsetMinutes');
      return;
    }

    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }
    List<PanelScConfig> toCreates = <PanelScConfig>[].obs;



    for(int i=0;i<selectedEventDatesItems.length;i++){
      if(selectedEventDatesItems[i].isEmpty){
        return;
      }
      print('-------selectedEventDatesItems[i] $selectedEventDatesItems[i]');
      PanelScConfig data = PanelScConfig(
        id: obId,
        name: eventName.toUpperCase(),
        eventName: eventName.toUpperCase(),
        barcodeLength: barcodeLengthInt,
        placeIdLength: placeIdLengthInt,
        timeOffsetMinutes: timeOffsetMinutes,
        showProgressBarEachXTimes: showProgressBarEachXTimes,
        event: eventResult,
        logoUrl: logoUrl,
        landingUrl   : landingUrl,
        active: active,
        eventDate: selectedEventDatesItems[i],
        eventId: eventResult?.id,

      );

      toCreates.add(data);
    }
    isLoading.value = true;
    ResponseApi responseApi = await provider.insert(toCreates);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      showSuccessMessages(responseApi.message ?? Messages.CREATE);
      findConfigInEventId();
      update();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }
  void findEventByName(BuildContext context) async {

    String title = '${Messages.FIND_EVENT_BY_NAME} : ${Messages.minimumCharacters(minimumCharacters)}';
    String  name = await getTextFromDialog(context, title);
    if(name.isEmpty || name.length<minimumCharacters){
      showErrorMessages('${Messages.NAME} ${Messages.minimumCharacters(minimumCharacters)} : $name');
      return;
    }
    name = name.trim();
    SolExpressEvent data = SolExpressEvent(
      name: name,
    );

    eventResults.clear();
    isLoading.value = true;
    ResponseApi responseApi = await eventsProvider.findByName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<SolExpressEvent> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        eventResults.addAll(list);
        setEventData(eventResults[0]);
      } else {
        showSuccessMessages(responseApi.message ?? Messages.FIND);
        clearForm();
      }


    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }

  void findConfigInEventId() async {
    if(eventResult==null){
      return;
    }
    asTemplate.value = false;
    configResults.clear();
    idConfigResult.value = '';
    configResult = null;
    isLoading.value = true;
    ResponseApi responseApi = await provider.findConfigInEventId(eventResult!);
    eventDates.clear();
    selectedEventDatesItems.clear();
    if(createPage){
      /*for(String date in eventResult!.getEventDates()){
        print('getEventDates $date');
        eventDates.add(date);
      }*/
      if(eventResult!.daysConfigured!=null){
        for(String date in eventResult!.daysConfigured!){
          print('getEventConfiguredDays $date');
          //eventDates.add(date);
        }
      }


      for(String date in eventResult!.getEventNoConfiguredDays()){
        print('getEventNoConfiguredDays $date');
        eventDates.add(date);
      }
      print('eventDates.length ${eventDates.length}');
      for(String date in eventDates){
        print('eventDates $date');
      }
    } else {
      for(String date in eventResult!.getEventDates()){
        eventDates.add(date);
      }
    }

    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<PanelScConfig> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        configResults.addAll(list);

        setConfigData(configResults[0]);

      } else {
        showSuccessMessages(responseApi.message ?? Messages.FIND);
        clearConfigForm();
      }


    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void findConfigByConfigEventName(BuildContext context) async {
    String title = '${Messages.FIND_CONFIG_BY_NAME} : ${Messages.minimumCharacters(minimumCharacters)}';
    String  name = await getTextFromDialog(context, title);
    if(name.isEmpty || name.length<minimumCharacters){
      showErrorMessages('${Messages.NAME} ${Messages.minimumCharacters(minimumCharacters)} : $name');
      return;
    }
    name = name.trim();
    asTemplate.value = true;
    configResults.clear();
    idConfigResult.value = '';
    configResult = null;
    isLoading.value = true;
    PanelScConfig data = PanelScConfig(
      eventName: name,
    );
    ResponseApi responseApi = await provider.findConfigByConfigEventName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<PanelScConfig> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        configResults.addAll(list);
        if(configResults.length==1){
          setConfigData(configResults[0]);
        }
      } else {
        showSuccessMessages(responseApi.message ?? Messages.FIND);
        clearConfigForm();
      }


    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void updateData(BuildContext context) async {

    String  id = idConfigResult.value;
    int ? obId = int.tryParse(id);
    if(obId==null ||obId<=0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }

    String  eventName = eventNameController.text.trim();
    if(eventName.isEmpty){
      showErrorMessages('${Messages.NAME} : $eventName');
      return;
    }
    String logoUrl = logoUrlController.text.trim();
    if(logoUrl.isEmpty){
      showErrorMessages('${Messages.LOGO} : $logoUrl');
      return;
    }

    String?  landingUrl ;
    landingUrl = landingUrlController.text.trim();
    if(landingUrl.isEmpty){
      showErrorMessages('${Messages.IMAGE} : $landingUrl');
      return;
    }
    String  barcodeLength = barcodeLengthController.text.trim();
    int? barcodeLengthInt = int.tryParse(barcodeLength);
    if(barcodeLengthInt==null || barcodeLengthInt<=0){
      showErrorMessages('${Messages.BARCODE_LENGTH} : $barcodeLength');
      return;
    }
    String  placeIdLength = placeIdLengthController.text.trim();
    int? placeIdLengthInt = int.tryParse(placeIdLength);
    if(placeIdLengthInt==null || placeIdLengthInt<=0){
      showErrorMessages('${Messages.PLACE_ID_LENGTH} : $placeIdLength');
      return;
    }
    int? showProgressBarEachXTimes = int.tryParse(showProgressBarEachXTimesController.text.trim());
    if(showProgressBarEachXTimes==null || showProgressBarEachXTimes<=0){
      showErrorMessages('${Messages.SHOW_PROGRESS_BAR_EACH_X_TIMES} : $showProgressBarEachXTimes');
      return;
    }
    int? timeOffsetMinutes = int.tryParse(timeOffsetMinutesController.text.trim());
    if(timeOffsetMinutes==null || timeOffsetMinutes.obs()>1440){
      showErrorMessages('${Messages.TIME_OFFSET_MINUTES} : $timeOffsetMinutes');
      return;
    }
    if(eventDate.value.isEmpty){
      showErrorMessages('${Messages.EVENT_DATE} : ${eventDate.value}');
      return;
    }

    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }

    PanelScConfig data = PanelScConfig(
      id: obId,
      name: eventName.toUpperCase(),
      eventName: eventName.toUpperCase(),
      barcodeLength: barcodeLengthInt,
      placeIdLength: placeIdLengthInt,
      timeOffsetMinutes: timeOffsetMinutes,
      showProgressBarEachXTimes: showProgressBarEachXTimes,
      event: eventResult,
      logoUrl: logoUrl,
      landingUrl   : landingUrl,
      active: active,
      eventDate: eventDate.value,
      eventId: eventResult?.id,

    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.updateData(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.UPDATE);
      int index = configResults.indexWhere((element) => element.id == data.id);
      if (index != -1) {
        // Replace the element at the found index
        configResults[index] = data;
      }
      idConfigResult.value = data.id.toString();
      setConfigData(data);
      update();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }

  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,(route)=>false);
  }
  void setEventData(SolExpressEvent? data){
    eventResult = data ;
    if(data==null){
      return;
    }
    idEventResult.value = data.id.toString();


    findConfigInEventId();
    update();
  }
  void setConfigData(PanelScConfig? data){
    configResult = data ;
    if(data==null){
      return;
    }
    asTemplate.value ? idConfigResult.value = '' : idConfigResult.value = data.id.toString();
    asTemplate.value ? eventDate.value='' : eventDate.value=data.eventDate ?? '';

    idController.text= idConfigResult.value ;
    eventNameController.text=data.eventName ?? '';
    logoUrlController.text=data.logoUrl ?? '';
    landingUrlController.text=data.landingUrl ?? '';
    barcodeLengthController.text=data.barcodeLength.toString();
    placeIdLengthController.text=data.placeIdLength.toString();
    timeOffsetMinutesController.text=data.timeOffsetMinutes.toString();
    showProgressBarEachXTimesController.text=data.showProgressBarEachXTimes.toString();

    isActive.value=data.active.toString();

    update();
  }

  void clearForm(){
    eventResults.clear();
    idEventResult.value ='';
    eventResult = null;

    configResults.clear();
    idConfigResult.value ='';
    configResult = null;
    selectedEventDatesItems.clear();

    idController.text = '';
    eventNameController.text = '';
    logoUrlController.text = '';
    landingUrlController.text = '';
    barcodeLengthController.text = '';
    placeIdLengthController.text = '';
    timeOffsetMinutesController.text = '';
    showProgressBarEachXTimesController.text = '';
    eventDate.value = '';
    isActive.value = '1';

    eventDates.clear();
    update();
  }
  void clearConfigForm(){
    configResults.clear();
    idConfigResult.value ='';
    configResult = null;
    selectedEventDatesItems.clear();
    if(!createPage){
      eventDate.value = '';
      eventDates.clear();
    }


    idController.text = '';
    eventNameController.text = '';
    logoUrlController.text = '';
    landingUrlController.text = '';
    barcodeLengthController.text = '';
    placeIdLengthController.text = '';
    timeOffsetMinutesController.text = '';
    showProgressBarEachXTimesController.text = '';

    isActive.value = '1';
    update();
  }

  void onHandlingItemTapped(BuildContext context, int index) {
    if(isLoading.value) return;
    switch (index) {
      case 0:
        findEventByName(context);
        break;
      case 1:
        findConfigByConfigEventName(context);
        break;
      case 2:
        updateData(context);
        break;

    }
  }

  void getLatestEvents() async {
    eventResults.clear();
    isLoading.value = true;
    ResponseApi responseApi = await eventsProvider.findLatestEvents();
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      List<SolExpressEvent> list = responseApi.data;
      print('list.length ${list.length}');
      if(list.isNotEmpty){
        eventResults.addAll(list);
        setEventData(eventResults[0]);
      } else {
        clearForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();
  }



}