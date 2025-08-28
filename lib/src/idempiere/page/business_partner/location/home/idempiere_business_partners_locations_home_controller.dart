
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_filter_create_controller_model.dart';
import 'package:solexpress_panel_sc/src/idempiere/environment/Idempiere_rest_command.dart';
import '../../../../../data/memory.dart';
import '../../../../../models/idempiere/idempiere_business_partner_location.dart';
import '../../../../../models/idempiere/idempiere_query_result.dart';
import '../../../../../models/idempiere/idempiere_sql_query_condition.dart';


class IdempiereBusinessPartnerLocationsHomeController extends IdempiereFilterCreateControllerModel{






  List<IdempiereBusinessPartnerLocation> businessPartnerLocations = <IdempiereBusinessPartnerLocation>[].obs;



  IdempiereBusinessPartnerLocationsHomeController(){
    routePageDestination = Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_LIST_PAGE;
    getStorageSaveKey = Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LOCATIONS_LIST;
    endPoint = Memory.IDEMPIERE_ENDPOINT_BUSINESS_PARTNER_LOCATION;

    fields = IdempiereRestCommand.fieldsOfBusinessPartnerLocation.obs;
    bottomNavigationBarColor = Colors.cyan[200]!;
    title = Messages.BUSINESS_PARTNER_LOCATION;


  }



  @override
  void goToHomePage(){
  }
  void goToUserRolHomePage(String page){
  }
  @override
  void goToRolesPage(){
  }
  void goToClientHomePage(){
  }
  bool isValidForm(String name, String password){
    if(name.isEmpty){
      showErrorMessages(Messages.EMAIL);
      return false;
    }
    return true;
  }

  Future<void> findByCondition(BuildContext context) async {

      IdempiereSqlQueryCondition condition = IdempiereSqlQueryCondition(idempiereFilters: idempiereFilters);
      print('-----------------------condition: ${condition.getFilter()}');
      isLoading.value = true;
      businessPartnerLocations.clear();
      IdempiereQueryResult? fromJson = await findIdempiereObjectByCondition(context, endPoint);
      isLoading.value = false;
      if (fromJson == null ||  fromJson.records == null || fromJson.records is! List) return ;

      List<IdempiereBusinessPartnerLocation> businessPartnerLocationRecords = IdempiereBusinessPartnerLocation.fromJsonList(fromJson.records); // Pass the 'records' list to fromJsonList
      print('-----------------------------------------------------------------');
      print('----------------------------page row count: ${fromJson.rowCount}');
      print('----------------------------records.length: ${fromJson.records?.length ?? 0}');

      for(var item in fromJson.records!){
        IdempiereBusinessPartnerLocation businessPartnerLocation = IdempiereBusinessPartnerLocation.fromJson(item);
        businessPartnerLocations.add(businessPartnerLocation);
      }
      print('---------------result.length: ${businessPartnerLocations.length}');
      saveIdempiereBusinessPartnerLocationsList(businessPartnerLocations);
      if(routePageDestination!=null){
        Get.toNamed(routePageDestination!,arguments:{ getStorageSaveKey :businessPartnerLocations});
      }



  }






}