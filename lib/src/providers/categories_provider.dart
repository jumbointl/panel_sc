import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:solexpress_panel_sc/src/models/sql_query_condition.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import 'dart:io';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/category.dart';
import 'package:http/http.dart' as http;

class CategoriesProvider extends ProviderModel {

  CategoriesProvider(){
    Memory.getHeaders();
  }

  Future<List<Category>?> getAll(BuildContext? context) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_CATEGORY_GET_ALL}';
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    if(! await showProgressDialog(context)){
      return [];
    }
    try {

      Response response = await get(
        route,
        headers: headers,
      );
      closProgressDialog();
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.ERROR_DATABASE_QUERY);
        return [];
      }

      responseApi = ResponseApi.fromJson(response.body);
      List<Category> newList = Category.fromJsonList(responseApi.data);
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
  Future<List<Category>?> getCategoryByCondition(BuildContext context, SqlQueryCondition condition) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_CATEGORY_GET_BY_CONDITION}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    try {
      if(! await showProgressDialog(context)){
      return [];
    }
      Response response = await post(
        route,
        condition.toJson(),
        headers: headers,

      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.ERROR_DATABASE_QUERY);
        return [];
      }

      responseApi = ResponseApi.fromJson(response.body);
      // los datos esta en responseApi.data
      List<Category> newList = Category.fromJsonList(responseApi.data);

      closeDialogWithSuccessMessages(responseApi.message);
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


  Future<ResponseApi> create(BuildContext context, Category category) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_CATEGORY_CREATE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    ResponseApi responseApi = ResponseApi();
    try {
      if(! await showProgressDialog(context)){
      return responseApi;
    }
      Response response = await post(
        route,
        category.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.LOGIN_FAILED);
        return ResponseApi();
      }
      //print(response.body);

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


  Future<ResponseApi> updateWithoutImage(BuildContext context, Category category) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_CATEGORY_UPDATE_WITHOUT_IMAGE}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');
    try {
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    Response response = await put(
      route,
      category.toJson(),
      headers: headers,
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

  Future<ResponseApi> updateWithImage(BuildContext context, Category data, File image,) async {
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }

    try {
      if(! await showProgressDialog(context)){
        return ResponseApi();
      }
      Uri uri = Uri.http(urlAppWithoutHttp, Memory.NODEJS_ROUTE_CATEGORY_UPDATE_WITH_IMAGE);
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = Memory.getSessionToken();
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
      ));
      request.fields['category'] = json.encode(data);

      final response = await request.send();
      ResponseApi responseApi = ResponseApi();
      Stream? stream = response.stream.transform(utf8.decoder);
      stream.listen((res){
        if(res==null){
          responseApi = ResponseApi(success: false, message: Messages.ERROR, data:null);
          closeDialogWithErrorMessages(responseApi.message ?? Messages.EMPTY);
        } else {
          responseApi = ResponseApi.fromJson(json.decode(res));
          closeDialogWithSuccessMessages(responseApi.message ?? Messages.EMPTY);
        }

      });



      closeDialogWithSuccessMessages(null);
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
  Future<ResponseApi> createWithImage(BuildContext context, Category category, File image,) async {
    try {
      if(! await showProgressDialog(context)){
        return  ResponseApi();
      }
      Uri uri = Uri.http(urlAppWithoutHttp, Memory.NODEJS_ROUTE_CATEGORY_CREATE_WITH_IMAGE);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = Memory.getSessionToken();
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
      ));
      request.fields['category'] = json.encode(category);
      ResponseApi responseApi =ResponseApi();

      final response = await request.send();
      Stream? stream = response.stream.transform(utf8.decoder);
      stream.listen((res){
        if(res==null){
          responseApi = ResponseApi(success: false, message: Messages.ERROR, data:null);
          closeDialogWithErrorMessages(responseApi.message ?? Messages.EMPTY);
        } else {
          responseApi = ResponseApi.fromJson(json.decode(res));
          closeDialogWithSuccessMessages(responseApi.message ?? Messages.EMPTY);
        }


      });


      return responseApi ;



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