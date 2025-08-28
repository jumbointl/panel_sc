import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_object.dart';
import 'idempiere_controller_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class IdempiereObjectsListControllerModel extends IdempiereControllerModel {
  var indexTab = 0.obs;
  List<ObjectWithNameAndId> categories =<ObjectWithNameAndId>[].obs;
  RxString idObject = ''.obs;
  TextEditingController findByObjectNameController= TextEditingController();
  bool showNavigateBottom = false;
  List<IdempiereObject> selectedObjects = [];
  List<IdempiereObject> objectsList = <IdempiereObject>[];
  var items = 0.obs;

  var objectName = ''.obs;
  Timer? searchOnStoppedTyping;

  IdempiereObjectsListControllerModel(){

      isLoading.value = false;
      selectedObjects = getSavedIdempiereObjectList();
      if(selectedObjects.isNotEmpty){
        items.value = selectedObjects.length;
      }
  }


  Future<List<IdempiereObject>> getObjectsByCategory(int categoryId) async{
    ObjectWithNameAndId category = ObjectWithNameAndId(id: Memory.ALL_CATEGORIES_ID, name: Messages.ALL_CATEGORIES);

    List<IdempiereObject> list = [];
    for(int i=0; i<objectsList.length;i++){
      if(objectsList[i].category == null){
        objectsList[i].category = category;
      }
      if(categoryId==Memory.ALL_CATEGORIES_ID){
        list.add(objectsList[i]);
      } else if(objectsList[i].category?.id == categoryId){
        list.add(objectsList[i]);
      }
    }
    return list;
  }



  void goToIdempiereObjectDetailPage(IdempiereObject object){
    saveIdempiereObject(object);
    Get.toNamed(Memory.ROUTE_IDEMPIERE_OBJECT_DETAIL_PAGE,arguments:{Memory.KEY_IDEMPIERE_OBJECT:object});
  }

  void openBottomSheet(BuildContext context, IdempiereObject object) async{
    //child: IdempiereObjectDetailPage(idempiereObject: object),
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,

        child: Container(
          margin: EdgeInsets.all(20),
          color: Colors.white,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: Column(
              children: object.getOtherDataToDisplay().map((e) => Text(e)).toList()),

        ),
      ),

    );

  }
  @override
  buttonBackPressed() {
    // TODO: implement buttonBackPressed
    Get.back();
  }

}