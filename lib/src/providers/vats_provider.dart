import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/vat.dart';
class VatsProvider extends ProviderModel{

  Future<List<Vat>?> getAll(BuildContext? context) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_VAT_GET_ALL_ACTIVE}';
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
      List<Vat> newList = Vat.fromJsonList(responseApi.data);
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


  Future<ResponseApi> create(BuildContext context,Vat vat) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_VAT_CREATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return responseApi;
    }
    try {
      Response response = await post(
        route,
        vat.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.LOGIN_FAILED);
        return ResponseApi();
      }

      responseApi = ResponseApi.fromJson(response.body);
      closeDialogWithSuccessMessages(responseApi.message);
      return responseApi;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }
  }


  Future<ResponseApi> update(Vat vat) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_VAT_UPDATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return responseApi;
    }
    try {
      Response response = await post(
        route,
        vat.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.LOGIN_FAILED);
        return ResponseApi();
      }

      responseApi = ResponseApi.fromJson(response.body);
      closeDialogWithSuccessMessages(responseApi.message);
      return responseApi;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }
  }


}