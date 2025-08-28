import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/payment.dart';
import '../models/response_api.dart';
class PaymentsProvider extends ProviderModel{


  Future<ResponseApi> create(BuildContext context,Payment payment) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_PAYMENTS_CREATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Response response = await post(
        route,
        payment.toJson(),
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


  Future<ResponseApi> update(Payment payment) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_PAYMENTS_UPDATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    Response response = await put(
      route,
      payment.toJson(),
      headers: headers,
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