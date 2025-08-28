import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/warehouse.dart';
class WarehousesProvider extends ProviderModel{

  Future<List<Warehouse>?> getById(BuildContext? context,int idWarehouse) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_WAREHOUSE_GET_WAREHOUSE_BY_ID}/$idWarehouse';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return [];
    }
    try {
      Response response = await get(
        route,
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
       closeDialogWithErrorMessages(Messages.ERROR_DATABASE_QUERY);
        return [];
      }
      responseApi = ResponseApi.fromJson(response.body);
      List<Warehouse> newList = Warehouse.fromJsonList(responseApi.data);
      if(context!=null){
        closeDialogWithSuccessMessages(responseApi.message);
      }
      return newList;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(Messages.TIME_OUT);
      print(err);
      return [];
    }catch(e){
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return [];
    }
  }





}