
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_filter_create_controller_model.dart';
import 'package:solexpress_panel_sc/src/idempiere/environment/Idempiere_rest_command.dart';
import 'package:solexpress_panel_sc/src/idempiere/provider/idempiere_products_provider.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import '../../../../data/memory.dart';
import '../../../../models/idempiere/idempiere_product.dart';
import '../../../../models/idempiere/idempiere_query_result.dart';
import '../../../../models/idempiere/idempiere_sql_query_condition.dart';


class IdempiereProductsHomeController extends IdempiereFilterCreateControllerModel{






  List<IdempiereProduct> products = <IdempiereProduct>[].obs;



  IdempiereProductsHomeController({super.title,super.endPoint}){
    super.title = Messages.PRODUCTS;
    super.endPoint = Memory.IDEMPIERE_ENDPOINT_PRODUCTS;
    fields = IdempiereRestCommand.fieldsOfProducts.obs;
    bottomNavigationBarColor = Colors.cyan[200]!;
    title = Messages.PRODUCTS;


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

      IdempiereProductsProvider productsProvider = IdempiereProductsProvider();
      IdempiereSqlQueryCondition condition = IdempiereSqlQueryCondition(idempiereFilters: idempiereFilters);
      print('-----------------------------------------------------------------------------------');
      print('----condition: ${condition.getFilter()}');
      print('-----------------------------------------------------------------------------------');
      isLoading.value = true;
      products.clear();
      ResponseApi responseApi = await productsProvider.findByCondition(endPoint,condition.getFilter());
      isLoading.value = false;
      if(responseApi.success==null || !responseApi.success!){
        showErrorMessages(responseApi.message ?? Messages.ERROR);
        return ;
      } else {

        IdempiereQueryResult? fromJson = responseApi.data;
        if (fromJson == null ||  fromJson.records == null || fromJson.records is! List) return ;

        print('---------------------------------------------page count: ${fromJson.pageCount}');
        print('---------------------------------------------page array count: ${fromJson.arrayCount}');
        print('---------------------------------------------page skip: ${fromJson.skipRecords}');
        print('---------------------------------------------page record size: ${fromJson.recordsSize}');


        List<IdempiereProduct> productRecords = IdempiereProduct.fromJsonList(fromJson.records); // Pass the 'records' list to fromJsonList
        print('-----------------------------------------------------------------------------------');
        print('---------------------------------------------page row count: ${fromJson.rowCount}');
        print('---------------------------------------------records.length: ${fromJson.records?.length ?? 0}');
        print('-----------------------------------------productList.length: ${productRecords.length}');
        print('-----------------------------------------------------------------------------------');

        for(var item in fromJson.records!){
          IdempiereProduct product = IdempiereProduct.fromJson(item);
          products.add(product);
        }
        saveClientProductsList(products, getSavedIdempiereUser().userId ?? 0);
        Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_LIST_PAGE,arguments:{Memory.KEY_CLIENT_PRODUCTS_LIST:products});
      }


  }



}