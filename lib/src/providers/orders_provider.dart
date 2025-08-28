import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/order.dart';
import '../models/user.dart';
class OrdersProvider extends ProviderModel{

  Future<List<Order>> getClientOrderByStatus(BuildContext? context,int idOrderStatus) async{
    int idSociety = 0;
    User? user = Memory.getSavedUser();
    if(user.idSociety!=null){
      idSociety = user.idSociety!;
    }
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    int idUser = user.id! ;
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDER_GET_CLIENT_ORDER_BY_ORDER_STATUS}/$idSociety/$idUser/$idOrderStatus';
    print(route);
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
      List<Order> newList = Order.fromJsonList(responseApi.data);
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
  Future<List<Order>?> getSellerOrderByStatus(BuildContext? context,int idOrderStatus) async{

    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDER_GET_SELLER_ORDER_BY_ORDER_STATUS}/$idOrderStatus';
    ResponseApi responseApi = ResponseApi();
    print('route 1 $route');
    Map<String,String> headers = Memory.getHeaders();
    print('headers $headers');
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
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.ERROR_DATABASE_QUERY);
        return [];
      }

      responseApi = ResponseApi.fromJson(response.body);
      List<Order> newList = Order.fromJsonList(responseApi.data);
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
  Future<List<Order>?> getByDeliveryAndStatus(BuildContext? context,int idDelivery
      , int idOrderStatus) async{

    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDER_GET_BY_DELIVERY_AND_STATUS}/$idDelivery/$idOrderStatus';
    print(route);
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
      List<Order> newList = Order.fromJsonList(responseApi.data);
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


  Future<ResponseApi> create(BuildContext context,Order order) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_CREATE}';

    print('route $route');
    ResponseApi responseApi = ResponseApi();
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Response response = await post(
        route,
        order.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.CREATE_ORDER);
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
  Future<ResponseApi> createCreditOrder(BuildContext context,Order order) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_CREATE_CREDIT_ORDER}';

    print('route $route');
    ResponseApi responseApi = ResponseApi();
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Response response = await post(
        route,
        order.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(Messages.CREATE_CREADIT_ORDERS);
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


  Future<ResponseApi> update(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE}';
    print('order to json ${order.toJson()}');
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
      order.toJson(),
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

  Future<ResponseApi> updateOrderStatus(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_ORDER_STATUS}';
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
        order.toJson(),
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
  Future<ResponseApi> updateOrderStatusToDeliveredWithInvoice(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_ORDER_STATUS_TO_DELIVERED_WITH_INVOICE}';
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
        order.toJson(),
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
  Future<ResponseApi> updateToPaidAndSetDeliveryIdNull(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_PAID_AND_DELIVERY_ID_NULL}';
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
        order.toJson(),
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

  Future<ResponseApi> updateLatLng(Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_LAT_LNG}';
    print('route $route');
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }

    if(! await isInternetAvailable()){

      return ResponseApi();
    }
    try {
      Response response = await put(
        route,
        order.toJson(),
        headers: headers,

      );

      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      //closeDialogWithSuccessMessages(responseApi.message);


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

  Future<ResponseApi> updateToPrepared(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_PREPARED}';
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
        order.toJson(),
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

    Future<ResponseApi> updateToShipped(BuildContext context,Order order) async {
      Map<String,String> headers = Memory.getHeaders();
      if(headers.isEmpty){
        showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
        return ResponseApi();
      }
      String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_SHIPPED}';
      print('route $route');
      if(! await showProgressDialog(context)){
      return ResponseApi();
    }
      try {
        Response response = await put(
          route,
          order.toJson(),
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

  Future<ResponseApi> updateOrderToTotalReturnedStatus(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_TOTAL_RETURNED_STATUS}';
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
        order.toJson(),
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
  Future<ResponseApi> updateOrderToPartiallyReturnedStatus(BuildContext context,Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_PATRIALLY_RETURNED_STATUS}';
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
        order.toJson(),
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


  Future<List<Order>>  getOrderBySocietyAndStatus(BuildContext? context,int idSociety
      , int idOrderStatus) async{

    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDER_GET_BY_SOCIETY_AND_STATUS}/$idSociety/$idOrderStatus';
    print(route);
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
      List<Order> newList = Order.fromJsonList(responseApi.data);
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
  Future<List<Order>>  getOrderForAccountingBySocietyAndStatus(BuildContext? context,int idSociety, int idUser
      , int idOrderStatus) async{

    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDER_GET_FOR_ACCOUNTING_BY_SOCIETY_AND_STATUS}/$idSociety/$idUser/$idOrderStatus';
    print(route);
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
      List<Order> newList = Order.fromJsonList(responseApi.data);
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

  Future<ResponseApi> updateOrderToSettlement(BuildContext context, Order order) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_ORDERS_UPDATE_TO_SETTLEMENT}';
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
    order.toJson(),
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



}