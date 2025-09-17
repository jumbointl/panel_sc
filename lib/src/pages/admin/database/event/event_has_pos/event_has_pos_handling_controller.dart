import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/data_sql/event_has_pos.dart';
import '../../../../../models/pos.dart';
import '../../../../../models/sol_express_event.dart';
import '../../../../common/controller_model.dart';
import '../postgres_provider/sol_express_event_has_pos_provider.dart';
import '../postgres_provider/sol_express_events_provider.dart';


class EventHasPosHandlingController extends ControllerModel {
  SolExpressEventHasPosProvider provider = SolExpressEventHasPosProvider();
  SolExpressEventsProvider eventsProvider = SolExpressEventsProvider();
  List<SolExpressEvent> eventResults =<SolExpressEvent>[].obs;
  SolExpressEvent? eventResult;
  RxString idEventResult = ''.obs;


  RxString idPosResult = ''.obs;
  List<Pos> posResults =<Pos>[].obs;
  Pos? posResult ;

  bool createPage= false ;
  int minimumCharacters = 3;



  List<Pos> selectedPosItems = <Pos>[].obs;

  EventHasPosHandlingController(){
      getLatestEvents();
  }

  void deleteById(BuildContext context) async {

    String  eventId = idEventResult.value;
    int ? ob1Id = int.tryParse(eventId);
    if(ob1Id==null ||ob1Id<=0){
      showErrorMessages('${Messages.EVENT_ID} : $eventId');
      return;
    }
    String  posId  = idPosResult.value;
    int ? ob2Id = int.tryParse(posId);
    if(ob2Id==null ||ob2Id<=0){
      showErrorMessages('${Messages.POS_ID} : $eventId');
      return;
    }
    SolExpressEvent event = SolExpressEvent(
      id: ob1Id,
    );
    Pos pos = Pos(
      id: ob2Id,
    );
    EventHasPos data = EventHasPos(
      event: event,pos: pos,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.deleteByIds(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.DELETE);
      findPosInEventId();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }
  void create(BuildContext context) async {
    if(selectedPosItems.isEmpty){
      return;
    }
    List<EventHasPos> selectedEventHasPosItems = <EventHasPos>[].obs;
    for(int i=0;i<selectedPosItems.length;i++){
      if(selectedPosItems[i].id==null || selectedPosItems[i].id!<=0){
        return;
      }
      EventHasPos data = EventHasPos(
        event: eventResult,
        pos: selectedPosItems[i],
      );
      selectedEventHasPosItems.add(data);
    }
    isLoading.value = true;
    ResponseApi responseApi = await provider.insert(selectedEventHasPosItems);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.CREATE);
      findPosNotInEventId();
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
        clearForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void findPosByName(BuildContext context) async {

    String title = '${Messages.FIND_POS_BY_NAME} : ${Messages.minimumCharacters(minimumCharacters)}';
    String  name = await getTextFromDialog(context, title);
    if(name.isEmpty || name.length<minimumCharacters){
      showErrorMessages('${Messages.NAME} ${Messages.minimumCharacters(minimumCharacters)} : $name');
      return;
    }
    name = name.trim();
    Pos data = Pos(
      name: name,
    );

    posResults.clear();
    isLoading.value = true;
    ResponseApi responseApi = await provider.findPosSimpleByName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<Pos> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        posResults.addAll(list);
        if(posResults.length==1){
          setPosData(posResults[0]);
        }
      } else {
        clearPosForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void findPosInEventId() async {
    if(eventResult==null){
      return;
    }

    posResults.clear();
    idPosResult.value = '';
    posResult = null;
    isLoading.value = true;
    ResponseApi responseApi = await provider.findPosInEventId(eventResult!);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<Pos> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        posResults.addAll(list);
        if(posResults.length==1){
          setPosData(posResults[0]);
        }
      } else {
        clearPosForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void findPosNotInEventId() async {
    if(eventResult==null){
      return;
    }
    idPosResult.value = '';
    posResult = null;
    posResults.clear();
    selectedPosItems.clear();
    isLoading.value = true;
    ResponseApi responseApi = await provider.findPosNotInEventId(eventResult!);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<Pos> list = responseApi.data;
      print('list.length ${list.length}');

      if(list.isNotEmpty){
        posResults.addAll(list);
        if(posResults.length==1){
          setPosData(posResults[0]);
        }
      } else {
        clearPosForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

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
    if(createPage){
      findPosNotInEventId();
    } else {
      findPosInEventId();
    }
    update();
  }
  void setPosData(Pos? data){
    posResult = data ;
    if(data==null){
      return;
    }
    idPosResult.value = data.id.toString();
    update();
  }

  void clearForm(){
    eventResults.clear();
    idEventResult.value ='';
    eventResult = null;
    posResults.clear();
    idPosResult.value ='';
    posResult = null;
    selectedPosItems.clear();
    update();
  }
  void clearPosForm(){
    posResults.clear();
    idPosResult.value ='';
    posResult = null;
    selectedPosItems.clear();
    update();
  }

  void onHandlingItemTapped(BuildContext context, int index) {
    if(isLoading.value) return;
    switch (index) {
      case 0:
        findEventByName(context);
        break;
      case 1:
        findPosByName(context);
        break;
      case 2:
        deleteById(context);
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