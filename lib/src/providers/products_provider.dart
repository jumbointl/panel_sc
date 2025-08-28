import 'dart:async';

import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solexpress_panel_sc/src/models/sql_query_condition.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/product.dart';
import '../models/product_sql.dart';
import '../models/response_api.dart';
import 'dart:convert';
import 'package:path/path.dart';

class ProductsProvider extends ProviderModel{



  Future<List<Product>?> getAll(BuildContext context) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_PRODUCT_GET_ALL_BY_USER_ID}';
    print('route $route');
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
      // los datos esta en responseApi.data
      List<Product> newList = Product.fromJsonList(responseApi.data);

      closeDialogWithSuccessMessages(responseApi.message);
      return newList;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(Messages.TIME_OUT);
      print(err);
      return [];
    }catch(e){
      showErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return [];
    }
  }
  Future<ResponseApi> create(BuildContext context, Product product, List<File> images) async {
    String route = Memory.NODEJS_ROUTE_PRODUCT_CREATE_WITH_1_IMAGE;
    String token = Memory.getSessionToken();
    if(token==''){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();

    }
    int i = images.length;
    switch(i){
      case 1:
        route = Memory.NODEJS_ROUTE_PRODUCT_CREATE_WITH_1_IMAGE;
        break;
      case 2:
        route = Memory.NODEJS_ROUTE_PRODUCT_CREATE_WITH_2_IMAGE;
        break;
      case 3:
        route = Memory.NODEJS_ROUTE_PRODUCT_CREATE_WITH_3_IMAGE;
        break;
    }

    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Uri uri = Uri.http(urlAppWithoutHttp, route);

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = Memory.getSessionToken();
      for(int i=0;i<images.length;i++){
        request.files.add(http.MultipartFile(
            'image',
            http.ByteStream(images[i].openRead().cast()),
            await images[i].length(),
            filename: basename(images[i].path),

        ));
      }
      request.fields['products'] = json.encode(product);
      final response = await request.send();

      Stream stream = response.stream.transform(utf8.decoder);
      ResponseApi responseApi = ResponseApi();
      stream.listen((res) {
        if(res==null){
          responseApi = ResponseApi(success: false, message: Messages.ERROR, data:null);
          closeDialogWithErrorMessages(responseApi.message ?? Messages.EMPTY);
        } else {
          responseApi = ResponseApi.fromJson(json.decode(res));
          closeDialogWithSuccessMessages(responseApi.message ?? Messages.EMPTY);
        }

      });
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
  Future<ResponseApi> updateWithImage(BuildContext context, ProductSql product, List<File> images) async {
    String token = Memory.getSessionToken();
    if(token==''){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();

    }
    String route = Memory.NODEJS_ROUTE_PRODUCT_UPDATE_WITH_1_IMAGE;
    int i = images.length;
    switch(i){
      case 1:
        route = Memory.NODEJS_ROUTE_PRODUCT_UPDATE_WITH_1_IMAGE;
        break;
      case 2:
        route = Memory.NODEJS_ROUTE_PRODUCT_UPDATE_WITH_2_IMAGE;
        break;
      case 3:
        route = Memory.NODEJS_ROUTE_PRODUCT_UPDATE_WITH_3_IMAGE;
        break;
    }

    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Uri uri = Uri.http(urlAppWithoutHttp, route);

      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = token;
      for(int i=0;i<images.length;i++){
        request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path),

        ));
      }
      request.fields['product_sql'] = json.encode(product);
      final response = await request.send();
      Stream stream = response.stream.transform(utf8.decoder);
      ResponseApi responseApi = ResponseApi();
      stream.listen((res) {
        if(res==null){
          responseApi = ResponseApi(success: false, message: Messages.ERROR, data:null);
          closeDialogWithErrorMessages(responseApi.message ?? Messages.EMPTY);
        } else {
          responseApi = ResponseApi.fromJson(json.decode(res));
          closeDialogWithSuccessMessages(responseApi.message ?? Messages.EMPTY);
        }

      });
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

  Future<ResponseApi> updateWithoutImage(BuildContext context, Product data) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_USER_UPDATE_WITHOUT_IMAGE}';
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
        data.toJson(),
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
      return  ResponseApi();
    }catch(e){
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return ResponseApi();
    }
  }


  Future<List<Product>?> getProductByCondition(BuildContext context, SqlQueryCondition condition) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_PRODUCT_GET_BY_CONDITION}';
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
      List<Product> newList = Product.fromJsonList(responseApi.data);

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

  Future<List<Product>?> getProductWithPriceActiveByCondition(BuildContext context, SqlQueryCondition condition) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_ACTIVE_BY_CONDITION}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    ResponseApi responseApi = ResponseApi();
    try {
      if(! await showProgressDialog(null)){
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
      List<Product> newList = Product.fromJsonList(responseApi.data);

      //closeDialogWithSuccessMessages(responseApi.message);
      return newList;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      //closeDialogWithErrorMessages(Messeges.TIME_OUT);
      showErrorMessages(Messages.TIME_OUT);

      print(err);
      return [];
    }catch(e){
      //closeDialogWithErrorMessages(Messeges.ERROR_HTTP);
      showErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return [];
    }

  }


  Future<List<Product>?> getProductsWithPriceByCategoryAndGroup(BuildContext? context, String params) async {
    String aux = '$urlApp${Memory.NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_ACTIVE_BY_CATEGORY_AND_GROUP}';

    String route = '$aux$params';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    ResponseApi responseApi = ResponseApi();
    try {
      if(context!=null){
        if(! await showProgressDialog(context)){
      return [];
    }
      }

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
      List<Product> newList = Product.fromJsonList(responseApi.data);

      //closeDialogWithSuccessMessages(responseApi.message);
      return newList;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      //closeDialogWithErrorMessages(Messeges.TIME_OUT);
      showErrorMessages(Messages.TIME_OUT);

      print(err);
      return [];
    }catch(e){
      //closeDialogWithErrorMessages(Messeges.ERROR_HTTP);
      showErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return [];
    }

  }
}