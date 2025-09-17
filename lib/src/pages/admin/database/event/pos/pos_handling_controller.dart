import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/function_panel_sc.dart';
import '../../../../../models/pos.dart';
import '../../../../common/active_dropdown.dart';
import '../../../../common/controller_model.dart';
import '../postgres_provider/sol_express_pos_provider.dart';


class PosHandlingController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController findController= TextEditingController();
  TextEditingController activeController= TextEditingController();
  TextEditingController posCodeController= TextEditingController();
  SolExpressPosProvider provider =  SolExpressPosProvider();
  List<Active> activeList = ActiveDropdown.activeList.obs;
  List<FunctionPanelSc> functionList = MemoryPanelSc.getListAllFunctionAttendance().obs;
  RxString isActive = '1'.obs;
  RxString functionId = ''.obs;
  RxString idPosResult = ''.obs;
  List<Pos> posResults =<Pos>[].obs;
  Pos? posResult;
  bool saveImageLink = false ;
  int minimumCharacters = 3;

  var findControllerText = ''.obs;

  PosHandlingController(){
    findController.text = findControllerText.value;
  }

  void deleteById(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }
    Pos data = Pos(
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
    //insert with id, in this case the id is not auto increment
    String  id = idController.text.trim();
    int? obId = int.tryParse(id);
    if(obId==null || obId<=0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }

    String  name = nameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messages.NAME} : $name');
      return;
    }
    late String posCode ;
    posCode = posCodeController.text.trim();
    if(posCode.isEmpty){
      showErrorMessages('${Messages.IMAGE} : $posCode');
      return;
    }

    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }
    int? function = int.tryParse(functionId.value);
    if(function==null){
      showErrorMessages('${Messages.FUNCTION} : $function');
      return;
    }

    Pos data = Pos(
      id: obId,
      name: name.toUpperCase(),
      posCode: posCode,
      functionId: function,
      active: active,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.insert(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      Pos c = responseApi.data;
      idController.text = c.id.toString() ;
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
    Pos data = Pos(
      name: name,
    );

    posResults.clear();
    isLoading.value = true;
    ResponseApi responseApi = await provider.findByName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<Pos> list = responseApi.data;
      print('list.length ${list.length}');


      if(list.isNotEmpty){
        print('list ${list[0].toJson()}');
        posResults.addAll(list);
        if(posResults.length==1){
          setData(posResults[0]);
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
    String?  posCode ;
    posCode = posCodeController.text.trim();
    if(posCode.isEmpty){
      showErrorMessages('${Messages.IMAGE} : $posCode');
      return;
    }

    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }
    int? function = int.tryParse(functionId.value);
    if(function==null){
      showErrorMessages('${Messages.FUNCTION} : $function');
      return;
    }
    Pos data = Pos(
      id: obId,
      name: name.toUpperCase(),
      posCode: posCode,
      functionId: function,
      active: active,
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.updateData(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.UPDATE);
      // Find the index of the element to replace
      int index = posResults.indexWhere((element) => element.id == data.id);
      if (index != -1) {
        // Replace the element at the found index
        posResults[index] = data;
      }
      idPosResult.value = data.id.toString();
      setData(data);
      update();
    } else {
      showErrorMessages(responseApi.message ?? Messages.ERROR);
    }

  }

  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE,(route)=>false);
  }
  void setData(Pos? data){
    posResult = data ;

    if(data==null){
      return;
    }
    print(posResult!.toJson());
    idPosResult.value = data.id.toString();
    idController.text= data.id.toString() ;
    functionId.value = data.functionId.toString();
    nameController.text=data.name ?? '';
    activeController.text=data.active.toString();
    posCodeController.text=data.posCode ?? '';
    update();
  }

  void clearForm(){
    findController.text = findControllerText.value;
    functionId.value = '';
    idController.text= '' ;
    nameController.text='';
    findControllerText.value = '';
    activeController.text='';
    posCodeController.text='';
    posResults.clear();
    idPosResult.value ='';
    posResult = null;
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

}