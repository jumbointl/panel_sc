import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/address.dart';
import '../models/society.dart';
import '../models/user.dart';
class AddressesProvider extends ProviderModel{

  Future<List<Address>> getByUserAndSocietyActive(User user,Society society, int active) async {
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    String r = '$urlApp${Memory.NODEJS_ROUTE_ADDRESS_GET_BY_SOCIETY_USER_AND_ACTIVE}';
    // /1 ==address avtive
    String route ='$r/${society.id}/${user.id}/$active';
    print('route $route');
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
      // los datos esta en responseApi.data
      List<Address> newList = Address.fromJsonList(responseApi.data);
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
  Future<List<Address>> getByUserAndSociety(User user,Society society) async {
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return[];
    }
    String r = '$urlApp${Memory.NODEJS_ROUTE_ADDRESS_GET_BY_SOCIETY_USER_AND_ACTIVE}';
    // /1 ==address avtive
    String route ='$r/${society.id}/${user.id}/-1';
    print('route $route');
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
      // los datos esta en responseApi.data
      List<Address> newList = Address.fromJsonList(responseApi.data);
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

  Future<ResponseApi> create(BuildContext context,Address address) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_ADDRESS_CREATE}';
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
        address.toJson(),
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


  Future<ResponseApi> update(Address address) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ADDRESS_UPDATE}';
    //print('address to json ${address.toJson()}');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      closeDialogWithErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    Response response = await put(
      route,
      address.toJson(),
      headers: headers,
      /*
        headers: {
          'Content-Type': 'application/json',
          'Authorization': address.sessionToken ?? ''
        }

       */
    );
    if (response.body == null || response.statusCode == 401){
      closeDialogWithErrorMessages(Messages.ERROR_IN_UPDATE);
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    closeDialogWithSuccessMessages(responseApi.message);
    return responseApi;
  }




}