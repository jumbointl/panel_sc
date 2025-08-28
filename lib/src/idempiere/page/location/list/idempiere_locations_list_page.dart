import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_objects_list_page_model.dart';
import '../../../../data/messages.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../../models/object_with_name_and_id.dart';
import 'idempiere_locations_list_for_user_controller.dart';
class IdempiereLocationsListPage extends IdempiereObjectsListPageModel{

  IdempiereLocationsListForUserController controller = Get.put(IdempiereLocationsListForUserController());
  IdempiereLocationsListPage({super.key});



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
  String getTitle() { return Messages.LOCATIONS;}
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
