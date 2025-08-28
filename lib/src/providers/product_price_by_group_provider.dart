import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/product_price_by_group.dart';
import '../models/response_api.dart';
class ProductPriceByGroupProvider extends ProviderModel{
  Future<List<ProductPriceByGroup>?> getPriceAll(BuildContext? context) async{

    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_GET_ALL}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('header $headers');
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
      print(response.body);
      // los datos esta en responseApi.data
      print(responseApi.data);
      List<ProductPriceByGroup> newList = ProductPriceByGroup.fromJsonList(responseApi.data);
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


  Future<ResponseApi> priceCreate(BuildContext context,ProductPriceByGroup price) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_CREATE}';

    print('route price_list $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Response response = await post(
        route,
        price.toJson(),
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


  Future<ResponseApi> priceUpdate(BuildContext context,ProductPriceByGroup price) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_UPDATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Response response = await put(
        route,
        price.toJson(),
        headers: headers,
        /*
          headers: {
            'Content-Type': 'application/json',
            'Authorization': vat.sessionToken ?? ''
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
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(Messages.TIME_OUT);
      print(err);
      return ResponseApi();
    }catch(e){
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return ResponseApi();
    }
  }


}