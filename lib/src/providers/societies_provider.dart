import 'dart:async';

import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';

import '../models/society.dart';
class SocietiesProvider extends ProviderModel{
  Future<List<Society>?> getAll() async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_SOCIETY_GET_ALL}';
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
      if (response.body == null || response.statusCode == 401) {
        closeDialogWithErrorMessages(Messages.ERROR_DATABASE_QUERY);
        return [];
      }

      responseApi = ResponseApi.fromJson(response.body);
      List<Society> newList = Society.fromJsonList(responseApi.data);

      return newList;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages( Messages.TIME_OUT);
      print(err);
      return [];
    } catch (e) {
      showErrorMessages( Messages.ERROR_HTTP);
      print(e);
      return [];
    }
  }

  Future<List<Society>?> getAllActiveWithoutSeller() async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_SOCIETY_GET_ALL}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(null)){
      return [];
    }
    try {
      Response response = await get(
        route,
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401) {
        closeDialogWithErrorMessages( Messages.ERROR_DATABASE_QUERY);
        return [];
      }

      responseApi = ResponseApi.fromJson(response.body);
      List<Society> newList = Society.fromJsonList(responseApi.data);


      return newList;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages( Messages.TIME_OUT);
      print(err);
      return [];
    } catch (e) {
      showErrorMessages( Messages.ERROR_HTTP);
      print(e);
      return [];
    }
  }


}