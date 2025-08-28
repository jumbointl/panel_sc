import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/data_for_renew_user.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:solexpress_panel_sc/src/providers/provider_model.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import 'dart:convert';
import 'package:path/path.dart';
class UsersProvider extends ProviderModel{

  Future<ResponseApi> create(BuildContext context,User user) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_USER_REGISTER}';
    //print('user to json ${user.toJson()}');
    print('route $route');
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi();
    try {
    Response response = await post(
            route,
            user.toJson(),
            headers: Memory.getHeadersWithoutToken(),
    );
    if (response.body == null || response.statusCode == 401){
      closeDialogWithErrorMessages(Messages.LOGIN_FAILED);
      return ResponseApi();
    }

    responseApi = ResponseApi.fromJson(response.body);
    saveUser(responseApi);
    closeDialogWithSuccessMessages(responseApi.message);
    return responseApi;

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(  Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      closeDialogWithErrorMessages(  Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }
  }
  Future<ResponseApi> login(BuildContext context, String email, String password) async{
    ResponseApi responseApi = ResponseApi();
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      String route = '$urlApp${Memory.NODEJS_ROUTE_USER_LOGIN}';
      print('route $route');
      Response response = await post(route,
        {"email":email,"password":password},
        headers: Memory.getHeadersWithoutToken(),
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages(  Messages.LOGIN_FAILED);
        return ResponseApi();
      }
      //print(response.body);
      responseApi = ResponseApi.fromJson(response.body);
      closeDialogWithSuccessMessages(responseApi.message);
      return responseApi;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      closeDialogWithErrorMessages(  Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      closeDialogWithErrorMessages(  Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }

  }
  /*
  * GET X
   */
  Future<ResponseApi> createUserWithImageGetX(BuildContext context, User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      Memory.KEY_USER: json.encode(user)
    });
    ResponseApi responseApi = ResponseApi();
    Response response;
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
       response = await post('$urlApp${Memory.NODEJS_ROUTE_USER_REGISTER_WITH_IMAGE}', form)
      .timeout(const Duration(seconds: Memory.TIME_OUT_SECOND));
       if (response.body == null || response.statusCode == 401) {
         closeDialogWithErrorMessages(  Messages.ERROR_IN_UPDATE);
         return responseApi;
       }
       responseApi = ResponseApi.fromJson(response.body);
       closeDialogWithSuccessMessages(responseApi.message);
       return responseApi;
    } on TimeoutException catch (err) {
    /// here is the response if api call time out
    /// you can show snackBar here or where you handle api call
    closeDialogWithErrorMessages(  Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      closeDialogWithErrorMessages(  Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }




  }

  Future<ResponseApi> createWithImage(BuildContext context, User user, File image) async {
    ResponseApi responseApi =ResponseApi();
    if(! await showProgressDialog(context)){
      return ResponseApi();
    }
    try {
      Uri uri = Uri.http(urlAppWithoutHttp, Memory.NODEJS_ROUTE_USER_REGISTER_WITH_IMAGE);
      final request = http.MultipartRequest('POST', uri);
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(image.openRead().cast()),
          await image.length(),
          filename: basename(image.path)
      ));
      request.fields[Memory.KEY_USER] = json.encode(user);
      final response = await request.send();
      Stream stream = response.stream.transform(utf8.decoder);
      stream.listen((res){
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
      closeDialog();
      print(err);
      return ResponseApi();
    }catch(e){
      closeDialog();
      print(e);
      return ResponseApi();
    }

  }

  Future<Stream?> updateWithImage(BuildContext context, User user, File image) async {
    Uri uri = Uri.http(urlAppWithoutHttp, Memory.NODEJS_ROUTE_USER_UPDATE_WITH_IMAGE);
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization']=Memory.getSessionToken();

    request.files.add(http.MultipartFile(
        'image',
        http.ByteStream(image.openRead().cast()),
        await image.length(),
        filename: basename(image.path)
    ));
    request.fields[Memory.KEY_USER] = json.encode(user);
    if(! await showProgressDialog(context)){
      return null;
    }
    try {
      final response = await request.send();
      closeDialog();
      return response.stream.transform(utf8.decoder);
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      //showErrorMessages(  Messages.TIME_OUT);
      closeDialog();
      print(err);
      return null;
    }catch(e){
      //showErrorMessages(  Messages.ERROR_HTTP);
      closeDialog();
      print(e);
      return null;
    }
  }

  Future<ResponseApi> updateWithoutImage(User user) async {
    ResponseApi responseApi = ResponseApi();
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    try {
      String route = '$urlApp${Memory.NODEJS_ROUTE_USER_UPDATE_WITHOUT_IMAGE}';

      print('route $route');
      Response response = await put(
        route,
        user.toJson(),
        headers: headers,
      );
      if (response.body == null || response.statusCode == 401){
        closeDialogWithErrorMessages( Messages.ERROR_IN_UPDATE);
        return ResponseApi();
      }

      responseApi = ResponseApi.fromJson(response.body);
      return responseApi;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(  Messages.TIME_OUT);
      print(err);
      return responseApi;
    }catch(e){
      showErrorMessages(  Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }

  }

  Future<List<User>?> findDeliveryMen() {

    return getUsersByRol(null,Memory.ROL_DELIVERY_MAN.id!);
  }
  Future<List<User>?> getUsersByRol(BuildContext? context,int idRol) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_USER_GET_USERS_BY_ROL}/$idRol';
    print(route);
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return [];
    }
    print(headers);
    ResponseApi responseApi = ResponseApi();
    showProgressDialog(context);
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
      //print(response.body);
      // los datos esta en responseApi.data

      if(responseApi.data is String){
        print(responseApi.data);
        if(context!=null){
          showErrorMessages(responseApi.data);
          closProgressDialog();
          return [];
        }
      }
      List<User> newList = User.fromJsonList(responseApi.data);

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

  Future<ResponseApi> updateNotificationToken(User user) async {
    String route = '$urlApp${Memory.NODEJS_ROUTE_USER_UPDATE_NOTIFICATION_TOKEN}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return ResponseApi();
    }
    print('route $route');

    try {
      Response response = await put(
          route,
          user.toJson(),
          headers: headers,
      ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

      if (response.body == null || response.statusCode == 401) {
        closeDialogWithErrorMessages(Messages.ERROR_IN_UPDATE);
        return ResponseApi();
      }

      

      ResponseApi responseApi = ResponseApi.fromJson(response.body);


      if(responseApi.success!= null && responseApi.success!){
        user.ntfTokenCreatedAt = responseApi.data;
        saveUser(user);
        print('save user');
      }

      return responseApi;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      print(err);
      return ResponseApi();
    }catch(e){
      print(e);
      return ResponseApi();
    }
  }

  Future<DataForRenewUser> updatePassword(BuildContext context, DataForRenewUser user) async{
    String route = '$urlApp${Memory.NODEJS_ROUTE_USER_UPDATE_PASSWORD}';
    Map<String,String> headers = Memory.getHeaders();
    if(headers.isEmpty){
      showErrorMessages(Messages.ERROR_TOKEN_NOT_SAVED);
      return DataForRenewUser();
    }
    print('route $route');
    showProgressDialog(context);
    try {
      Response response = await put(
        route,
        user.toJson(),
        headers: headers,
      ); // ESPERAR HASTA QUE EL SERVIDOR NOS RETORNE LA RESPUESTA

      if (response.body == null || response.statusCode == 401) {
        closeDialogWithErrorMessages(Messages.ERROR);
        return DataForRenewUser();
      }
    

      ResponseApi responseApi = ResponseApi.fromJson(response.body);
      if(responseApi.success!= null && responseApi.success!){
        if(responseApi.data!= null){
          DataForRenewUser res = DataForRenewUser.fromJson(responseApi.data);
          if(res.newPassword!=null){
            saveUser(user);
            print('password renew success');
            closeDialogWithSuccessMessages(responseApi.message);
            return res;
          }
        }

      }
      closeDialogWithErrorMessages(responseApi.message ?? '');
      return DataForRenewUser();
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      print(err);
      closeDialogWithErrorMessages(Messages.TIME_OUT);
      return DataForRenewUser();
    }catch(e){
      print(e);
      closeDialogWithErrorMessages(Messages.ERROR);
      return DataForRenewUser();
    }

  }

}