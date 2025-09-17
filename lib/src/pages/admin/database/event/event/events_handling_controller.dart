import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/sol_express_event.dart';
import '../../../../common/active_dropdown.dart';
import '../../../../common/controller_model.dart';
import '../postgres_provider/sol_express_events_provider.dart';


class EventsHandlingController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController findController= TextEditingController();
  TextEditingController activeController= TextEditingController();
  TextEditingController imageController= TextEditingController();
  TextEditingController startDateController= TextEditingController();
  TextEditingController endDateController= TextEditingController();

  SolExpressEventsProvider provider =  SolExpressEventsProvider();
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  RxString idSolExpressEventResult = ''.obs;
  List<SolExpressEvent> eventsResult =<SolExpressEvent>[].obs;
  SolExpressEvent? solExpressEventResult;
  bool saveImageLink = false ;
  int minimumCharacters = 3;

  Rx<DateTime> startDate = Memory.getDateTimeNowLocal().obs;
  var startDateInString =''.obs;
  late DateTime minDay ;
  late DateTime maxDay ;
  late DateTime today ;

  Rx<DateTime>endDate = Memory.getDateTimeNowLocal().obs;
  var endDateInString =''.obs;
  var findControllerText = ''.obs;

  EventsHandlingController(){
    DateTime now = Memory.getDateTimeNowLocal();
    maxDay = DateTime(now.year+1, now.month, now.day,now.hour,0);
    minDay = DateTime(now.year-1, now.month, now.day,now.hour,0);
    today  = DateTime(now.year, now.month, now.day,now.hour,0);
    startDate.value = today;
    startDateInString.value =   startDate.value.toString().split(' ').first;
    startDateController.text = startDateInString.value;
    endDate.value = today;
    endDateInString.value =   endDate.value.toString().split(' ').first;
    endDateController.text = endDateInString.value;
    findController.text = findControllerText.value;
  }

  void deleteById(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }
    SolExpressEvent data = SolExpressEvent(
      id: obId,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.deleteById(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.DELETE);
      clearForm();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }
  void create(BuildContext context) async {

    String  id = idController.text.trim();
    int? obId = int.tryParse(id);
    if(obId!=null){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }

    String  name = nameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messages.NAME} : $name');
      return;
    }
    String?  image ;
    if(saveImageLink){
      image = imageController.text.trim();
      if(image.isEmpty){
        showErrorMessages('${Messages.IMAGE} : $image');
        return;
      }
    }

    String  startDate = startDateController.text.trim();
    if(startDate.isEmpty){
      showErrorMessages('${Messages.START_DATE} : $startDate');
      return;
    }
    String  endDate = endDateController.text.trim();
    if(endDate.isEmpty){
      showErrorMessages('${Messages.END_DATE} : $endDate');
      return;
    }

    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }

    SolExpressEvent data = SolExpressEvent(
      id: obId,
      name: name.toUpperCase(),
      image: image,
      eventStartDate: startDate,
      eventEndDate: endDate ,
      active: active,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.insert(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      SolExpressEvent c = responseApi.data;
      idController.text = c.id.toString() ;
      nameController.text = c.name ?? '';
      showSuccessMessages(responseApi.message ?? Messages.CREATE);
      update();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }
  void findByName(BuildContext context) async {

    String title = '${Messages.FIND_BY_NAME} : ${Messages.minimumCharacters(minimumCharacters)}';
    String  name = await getTextFromDialog(context, title);
    if(name.isEmpty || name.length<minimumCharacters){
      showErrorMessages('${Messages.NAME} ${Messages.minimumCharacters(minimumCharacters)} : $name');
      return;
    }
    name = name.trim();
    findControllerText.value = name;
    SolExpressEvent data = SolExpressEvent(
      name: name,
    );

    eventsResult.clear();
    isLoading.value = true;
    ResponseApi responseApi = await provider.findByName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<SolExpressEvent> list = responseApi.data;
      print('list.length ${list.length}');


      if(list.isNotEmpty){
        print('list ${list[0].toJson()}');
        eventsResult.addAll(list);
        if(eventsResult.length==1){
          setData(eventsResult[0]);
        }
      } else {
        clearForm();
      }
      showSuccessMessages(responseApi.message ?? Messages.FIND);

    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }
    update();

  }
  void updateData(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId<=0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }

    String  name = nameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messages.NAME} : $name');
      return;
    }
    String?  image ;
    if(saveImageLink){
      image = imageController.text.trim();
      if(image.isEmpty){
        showErrorMessages('${Messages.IMAGE} : $image');
        return;
      }
    }
    String  startDate = startDateController.text.trim();
    if(startDate.isEmpty){
      showErrorMessages('${Messages.START_DATE} : $startDate');
      return;
    }
    String  endDate = startDateController.text.trim();
    if(endDate.isEmpty){
      showErrorMessages('${Messages.END_DATE} : $endDate');
      return;
    }
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }

    SolExpressEvent data = SolExpressEvent(
      id: obId,
      name: name.toUpperCase(),
      image: image,
      eventStartDate: startDate,
      eventEndDate: endDate ,
      active: active,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.updateData(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.UPDATE);
      int index = eventsResult.indexWhere((element) => element.id == data.id);
      if (index != -1) {
        // Replace the element at the found index
        eventsResult[index] = data;
      }
      idSolExpressEventResult.value = data.id.toString();
      nameController.text = data.name ?? '';
      update();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }

  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,(route)=>false);
  }

  void setData(SolExpressEvent? data){
    solExpressEventResult = data ;

    if(data==null){
      return;
    }
    print(solExpressEventResult!.toJson());
    idSolExpressEventResult.value = data.id.toString();
    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    activeController.text=data.active.toString();
    imageController.text=data.image ?? '';
    startDateController.text=data.eventStartDate ?? '';
    endDateController.text=data.eventEndDate ?? '';
    update();
  }

  void clearForm(){
    startDate.value = today;
    startDateInString.value =   startDate.value.toString().split(' ').first;
    startDateController.text = startDateInString.value;
    endDate.value = today;
    endDateInString.value =   endDate.value.toString().split(' ').first;
    endDateController.text = endDateInString.value;
    findController.text = findControllerText.value;


    idController.text= '' ;
    nameController.text='';
    findControllerText.value = '';
    activeController.text='';
    imageController.text='';
    eventsResult.clear();
    idSolExpressEventResult.value ='';
    solExpressEventResult = null;
    imageFile = null;
    update();
  }

  void onHandlingItemTapped(BuildContext context, int index) {
    if(isLoading.value) return;
    switch (index) {
      case 0:
        findByName(context);
        break;
      case 1:
        updateData(context);
        break;
      case 2:
        deleteById(context);
        break;

    }
  }

  void setStartDate(DateTime? data) {
    if(data==null){
      return;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    startDate.value = DateTime(data.year, data.month, data.day,now.hour,0);
    Memory.deliveryDateLocal = startDate.value;
    print('Local--- ${startDate.value.day}/${startDate.value.month}/${startDate.value.year}. ${startDate.value.hour}:${startDate.value.minute}');
    String s = data.toString().split(' ').first;
    if(s.isEmpty){
      return;
    }
    startDateInString.value = s;
    startDateController.text = startDateInString.value;

  }
  void setEndDate(DateTime? data) {
    if(data==null){
      return;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    endDate.value = DateTime(data.year, data.month, data.day,now.hour,0);
    Memory.deliveryDateLocal = endDate.value;
    print('Local--- ${endDate.value.day}/${endDate.value.month}/${endDate.value.year}. ${endDate.value.hour}:${endDate.value.minute}');
    String s = data.toString().split(' ').first;
    if(s.isEmpty){
      return;
    }
    endDateInString.value = s;
    endDateController.text = endDateInString.value;

  }

}