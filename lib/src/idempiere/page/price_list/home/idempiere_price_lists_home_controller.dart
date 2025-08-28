
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_filter_create_controller_model.dart';
import 'package:solexpress_panel_sc/src/idempiere/environment/Idempiere_rest_command.dart';
import '../../../../data/memory.dart';
import '../../../../models/idempiere/idempiere_price_list.dart';
import '../../../../models/idempiere/idempiere_query_result.dart';
import '../../../../models/idempiere/idempiere_sql_query_condition.dart';


class IdempierePriceListsHomeController extends IdempiereFilterCreateControllerModel{






  List<IdempierePriceList> results = <IdempierePriceList>[].obs;


  IdempierePriceListsHomeController(){
    endPoint = Memory.IDEMPIERE_ENDPOINT_PRICE_LIST;
    routePageDestination = Memory.ROUTE_IDEMPIERE_PRICE_LISTS_LIST_PAGE;
    getStorageSaveKey = Memory.KEY_IDEMPIERE_PRICE_LISTS_LIST;
    fields = IdempiereRestCommand.fieldsOfPriceLists.obs;
    bottomNavigationBarColor = Colors.cyan[200]!;
    title = Messages.PRICE_LISTS;


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
      if(endPoint==null){
        showErrorMessages('${Messages.ERROR}: ${Messages.END_POINT_IS_NULL}');
        return ;
      }

      IdempiereSqlQueryCondition condition = IdempiereSqlQueryCondition(idempiereFilters: idempiereFilters);
      print('-----------------------condition: ${condition.getFilter()}');
      isLoading.value = true;
      results.clear();
      IdempiereQueryResult? fromJson = await findIdempiereObjectByCondition(context, endPoint);
      isLoading.value = false;
      if (fromJson == null ||  fromJson.records == null || fromJson.records is! List) return ;

      print('-----------------------------------------------------------------');
      print('----------------------------page row count: ${fromJson.rowCount}');
      print('----------------------------records.length: ${fromJson.records?.length ?? 0}');

      for(var item in fromJson.records!){
        IdempierePriceList data = IdempierePriceList.fromJson(item);
        results.add(data);
      }
      print('------------------------------result.length: ${results.length}');
      saveIdempierePriceListsList(results);
      if(routePageDestination!=null){
        Get.toNamed(routePageDestination!,arguments:{ getStorageSaveKey :results});
      }


  }






}