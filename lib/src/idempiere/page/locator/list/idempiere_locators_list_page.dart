import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_objects_list_page_model.dart';
import '../../../../data/messages.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../../models/object_with_name_and_id.dart';
import 'idempiere_locators_list_for_user_controller.dart';
class IdempiereLocatorsListPage extends IdempiereObjectsListPageModel{

  IdempiereLocatorsListForUserController controller = Get.put(IdempiereLocatorsListForUserController());
  IdempiereLocatorsListPage({super.key});



  @override
  RxBool getIsLoadingObs() {
    return controller.isLoading;
  }
  @override
  double getMarginsForMaximumColumns(BuildContext context) {
    return controller.getMarginsForMaximumColumns(context);
  }
  @override
  double getMaximumInputFieldWidth(BuildContext context) {
    return controller.getMaximumInputFieldWidth(context);
  }

  @override
  String getTitle() { return Messages.LOCATORS;}
  @override
  Widget getBottomActionButton() {
    return Container();
  }

  @override
  List<Widget> getActionButton() {
    return <Widget>[controller.buttonBack(),controller.popUpMenuButton()];
  }
  @override
  Future<List<IdempiereObject>> getObjects(BuildContext context, ObjectWithNameAndId category) async {
    return controller.getObjectsByCategory(category.id ?? -1);
  }



}
