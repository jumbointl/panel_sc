import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/category.dart';
import '../models/product_price_by_group.dart';
import '../models/response_api.dart';
import '../models/group.dart';
import '../models/sql_query_condition.dart';
class GroupsProvider extends ProviderModel{
  Future<List<Group>?> getAllActive(BuildContext? context) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_GET_ALL_ACTIVE}';
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
      // los datos esta en responseApi.data
      List<Group> newList = Group.fromJsonList(responseApi.data);
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


  Future<ResponseApi> create(BuildContext context,Group group) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_CREATE}';
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
        group.toJson(),
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


  Future<ResponseApi> update(Group group) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_UPDATE}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
    Response response = await put(
      route,
      group.toJson(),
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
    }catch(e) {
      closeDialogWithErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return ResponseApi();
    }
  }


  Future<List<Group>?> getGroupByCondition(BuildContext context, SqlQueryCondition condition) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_GET_BY_CONDITION}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('header $headers');
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
      List<Group> newList = Group.fromJsonList(responseApi.data);

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
  Future<List<ProductPriceByGroup>?> priceGetAll(BuildContext? context) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_GET_ALL}';
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
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
    Response response = await put(
      route,
      price.toJson(),
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
  Future<List<Category>> getGroupsCategoriesAllActive(BuildContext? context, int idGroup) async{
    if(idGroup==0){
      return [];
    }
    if(! await showProgressDialog(context)){
      return [];
    }
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_CATEGORIES_GET_ACTIVE_BY_CONDITION}';
    print('route ---- 1 $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return[];
    }

    int aux = Memory.DEFAULT_GROUP_ID ;
    String  whereAndOrderBy =' where id_group in($aux,$idGroup)  group by id  order by name';
    if(aux==idGroup){
      whereAndOrderBy =' where id_group  =$idGroup order by name';
    }


    SqlQueryCondition condition =SqlQueryCondition(whereAndOrderby: whereAndOrderBy);
    print('condition : ${condition.whereAndOrderby}');
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
      closeDialog();
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
  Future<List<Category>?> getGroupsCategoriesAll(BuildContext? context, int idGroup) async{
    if(idGroup==0){
      return [];
    }
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_CATEGORIES_GET_BY_CONDITION}';
    print('route ----  $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('header $headers');
    int aux = Memory.DEFAULT_GROUP_ID ;
    String  whereAndOrderby =' where id_group in($aux,$idGroup) order by name';
    SqlQueryCondition condition =SqlQueryCondition(whereAndOrderby: whereAndOrderby);
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
  Future<List<Category>?> getGroupsCategoriesByCondition(BuildContext context,SqlQueryCondition condition) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_CATEGORIES_GET_BY_CONDITION}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('header $headers');
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
  Future<List<ProductPriceByGroup>?> getProductsWithPriceByCondition(BuildContext context, SqlQueryCondition condition) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_BY_CONDITION}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print('header $headers');
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
      print(response.body);
      // los datos esta en responseApi.data
      print(responseApi.data);
      List<ProductPriceByGroup> newList = ProductPriceByGroup.fromJsonList(responseApi.data);

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
}