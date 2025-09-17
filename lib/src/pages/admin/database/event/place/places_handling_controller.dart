import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/place.dart';
import '../../../../common/controller_model.dart';
import '../postgres_provider/sol_express_places_provider.dart';


class PlacesHandlingController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();

  TextEditingController findController= TextEditingController();
  SolExpressPlaceProvider provider =  SolExpressPlaceProvider();
  RxString idPlacesResult = ''.obs;
  List<Place> placesResults =<Place>[].obs;
  Place? placesResult;
  int minimumCharacters = 3;
  var findControllerText = ''.obs;

  PlacesHandlingController(){
    findController.text = findControllerText.value;
  }

  void deleteById(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }
    Place data = Place(
      id: obId, name: '',
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

    Place data = Place(
      id: obId,
      name: name.toUpperCase(),
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.insert(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      Place c = responseApi.data;
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
    Place data = Place(
      name: name, id: null,
    );

    placesResults.clear();
    isLoading.value = true;
    ResponseApi responseApi = await provider.findByName(data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){

      List<Place> list = responseApi.data;
      print('list.length ${list.length}');
      if(list.isNotEmpty){
        print('list ${list[0].toJson()}');
        placesResults.addAll(list);
        if(placesResults.length==1){
          setData(placesResults[0]);
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
    Place data = Place(
      id: obId,
      name: name.toUpperCase(),
    );
    isLoading.value = true;
    ResponseApi responseApi = await provider.updateData(context,data);
    isLoading.value = false;
    if(responseApi.success!=null && responseApi.success!){
      showSuccessMessages(responseApi.message ?? Messages.UPDATE);
      // Find the index of the element to replace
      int index = placesResults.indexWhere((element) => element.id == data.id);
      if (index != -1) {
        // Replace the element at the found index
        placesResults[index] = data;
      }
      idPlacesResult.value = data.id.toString();
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
  void setData(Place? data){
    placesResult = data ;

    if(data==null){
      return;
    }
    print(placesResult!.toJson());
    idPlacesResult.value = data.id.toString();
    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    update();
  }

  void clearForm(){
    findController.text = findControllerText.value;
    idController.text= '' ;
    nameController.text='';
    findControllerText.value = '';
    placesResults.clear();
    idPlacesResult.value ='';
    placesResult = null;
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