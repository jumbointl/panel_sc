import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import '../../models/idempiere/idempiere_object.dart';
import 'idempiere_controller_model.dart';


class IdempiereBusinessPartnersListControllerModel extends IdempiereControllerModel {
  var indexTab = 0.obs;
  List<ObjectWithNameAndId> categories =<ObjectWithNameAndId>[].obs;
  RxString idObject = ''.obs;
  TextEditingController findByObjectNameController= TextEditingController();
  bool showNavigateBottom = false;
  IdempiereObject objectSelected =  IdempiereObject();
  List<IdempiereObject> selectedObjects = [];
  List<IdempiereObject> objectsList = <IdempiereObject>[];
  String selectedCategory ='';
  var items = 0.obs;
  var objectName = ''.obs;
  Timer? searchOnStoppedTyping;

  IdempiereBusinessPartnersListControllerModel(){

       isLoading.value = false;

      selectedObjects = getSavedIdempiereObjectList();
      if(selectedObjects.isNotEmpty){
        items.value = selectedObjects.length;
      }
  }


  Future<List<IdempiereObject>> getObjectsByCategory(int category) async{

    List<IdempiereObject> list = [];
    for(int i=0; i<objectsList.length;i++){
      if(objectsList[i].category?.id == category){

        list.add(objectsList[i]);
      }
    }
    return list;
  }


  void goToOrderCreatePage(){


  }
  void goToIdempiereObjectDetailPage(IdempiereObject object){

    saveIdempiereObject(object);
  }

  void openBottomSheet(BuildContext context, Object object) async{
    /*
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClientObjectsDetailPage(object: object)
    );
    */

  }
  @override
  buttonBackPressed() {
    // TODO: implement buttonBackPressed

  }

}