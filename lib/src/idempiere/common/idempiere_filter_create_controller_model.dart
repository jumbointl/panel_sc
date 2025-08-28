import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/idempiere/environment/Idempiere_rest_command.dart';
import 'package:solexpress_panel_sc/src/idempiere/provider/idempiere_provider_model.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_filter.dart';

import '../../data/memory.dart';
import '../../models/idempiere/idempiere_query_result.dart';
import '../../models/idempiere/idempiere_sql_query_condition.dart';
import '../../models/response_api.dart';
import 'idempiere_controller_model.dart';

class IdempiereFilterCreateControllerModel extends IdempiereControllerModel {

  List<IdempiereFilter> idempiereFilters = <IdempiereFilter>[].obs;

  List<TextEditingController> valueControllers = <TextEditingController>[].obs;
  TextEditingController valueController = TextEditingController();
  //List<String> from IdempiereRESTCommand;
  List<String> operators = IdempiereRestCommand.operators.obs;
  // change per table
  List<String> fields = <String>[].obs;
  List<String> values = IdempiereRestCommand.values.obs;
  List<String> images = IdempiereRestCommand.images.obs;
  List<String> conjunctions = IdempiereRestCommand.conjunctions.obs;
  Color bottomNavigationBarColor = Colors.cyan[200]!;
  RxBool showInputText = false.obs;
  var field = ''.obs;
  var operator = ''.obs;
  var value = ''.obs;
  var conjunction = ''.obs;
  String? title = '';
  String? endPoint = '';
  String? getStorageSaveKey = '';
  String? routePageDestination = '';
  IdempiereFilterCreateControllerModel({this.title,this.endPoint}) {
    if (GetStorage().read(Memory.KEY_IDEMPIERE_FILTERS) != null) {

      if (GetStorage().read(Memory.KEY_IDEMPIERE_FILTERS) is List<IdempiereFilter>) {
        var result = GetStorage().read(Memory.KEY_IDEMPIERE_FILTERS);
        idempiereFilters.clear();
        idempiereFilters.addAll(result);
      }
      else {
        var result = IdempiereFilter.fromJsonList(GetStorage().read(Memory.KEY_IDEMPIERE_FILTERS));
        idempiereFilters.clear();
        idempiereFilters.addAll(result);
      }
      for (var idempiereFilter in idempiereFilters) {
        TextEditingController t = TextEditingController();
        t.text = idempiereFilter.value;
        valueControllers.add(t);

      }
      
    }
  }
 

  void deleteItem(IdempiereFilter idempiereFilter,int i) {
    idempiereFilters.remove(idempiereFilter);
    valueControllers.removeAt(i);
    GetStorage().write(Memory.KEY_IDEMPIERE_FILTERS, idempiereFilters);
  }

  void addItem(IdempiereFilter idempiereFilter, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    idempiereFilters.add(idempiereFilter);
  }
  void setItem(IdempiereFilter idempiereFilter, int i, String string) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    if(idempiereFilter.value==string){
      return ;
    } else {
      idempiereFilter.value = string;
    }
    int index = idempiereFilters.indexWhere((p) => p.id == idempiereFilter.id);
    idempiereFilters.remove(idempiereFilter);
    valueControllers[i].text = idempiereFilter.value;
    idempiereFilters.insert(index, idempiereFilter);
    GetStorage().write(Memory.KEY_IDEMPIERE_FILTERS, idempiereFilters);

  }

  void removeItem(IdempiereFilter idempiereFilter, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    idempiereFilters.remove(idempiereFilter);
    GetStorage().write(Memory.KEY_IDEMPIERE_FILTERS, idempiereFilters);

  }

  Future<IdempiereQueryResult?> findIdempiereObjectByCondition(BuildContext context, String? endPoint) async {
    if(endPoint==null){
      showErrorMessages('${Messages.ERROR}: ${Messages.END_POINT_IS_NULL}');
      return  null;
    }

    IdempiereProviderModel provider = IdempiereProviderModel();
    IdempiereSqlQueryCondition condition = IdempiereSqlQueryCondition(idempiereFilters: idempiereFilters);
    print('-----------------------------------------------------------------------------------');
    print('----condition: ${condition.getFilter()}');
    print('-----------------------------------------------------------------------------------');
    isLoading.value = true;
    ResponseApi responseApi = await provider.findByCondition(endPoint,condition.getFilter());
    isLoading.value = false;
    if(responseApi.success==null || !responseApi.success!){
      showErrorMessages(responseApi.message ?? Messages.ERROR);
      return  null;
    } else {

      IdempiereQueryResult? fromJson = responseApi.data;
      return fromJson;

    }


  }


}