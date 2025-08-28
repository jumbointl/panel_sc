import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:solexpress_panel_sc/src/idempiere/provider/idempiere_rest_provider.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_session.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_user.dart';

import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_query_result.dart';
import '../../models/response_api.dart';

class IdempiereProviderModel extends GetConnect{
  ProgressDialog? progressDialog;
  Color backGroundColor = Colors.blue;
  int showMessageInSeconds = 3;
  BuildContext? context;
  late String urlApp ;
  late String urlAppWithoutHttp ;
  bool showProgress = false;
  final Completer<bool> completer = Completer();
  IdempiereProviderModel(){
    urlApp = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
    urlAppWithoutHttp = GetStorage().read(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP) ?? Memory.APP_HOST_NAME_WITHOUT_HTTP;
  }
  Future<bool> isInternetAvailable() async {
    final bool isConnected = await InternetConnectionChecker.instance.hasConnection;
    if (!isConnected) {
      showErrorMessages(Messages.NO_INTERNET_CONNECTION);
      return false;
    } else {
      return true;
    }
  }
  Future<bool> showProgressDialog(BuildContext? context) async {
    if(context==null || !context.mounted || !showProgress){
      print('context == null');
      return true;
    }


    late Timer timer2;
    await Get.showOverlay(asyncFunction: ()
    async {
      timer2 = Timer(Duration(seconds: 1), () {
        print('--------------------------timer2--refresh');
        completer.complete(true);
      });
      await completer.future;
    },
        loadingWidget: Material(
          color: Colors.transparent,
          type: MaterialType.transparency,
          elevation: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'working on...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Sans',
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              CircularProgressIndicator(color: Colors.blue),
              ElevatedButton(
                onPressed: () {
                  timer2.cancel();
                  completer.complete(true);
                },
                child: Text("cancel"),
              )
            ],
          ),
        ));



    this.context = context;
    progressDialog = ProgressDialog(context: context);
    progressDialog?.show(
      max: 100,
      msg: Messages.IN_UPDATE,

    );
    return true;
  }
  void closProgressDialog(){
    if(progressDialog!=null){
      progressDialog?.close();
      progressDialog = null;
    }

  }
  void showErrorMessages(String message){
    Fluttertoast.showToast(
      msg: '${Messages.ERROR} : $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[300],
      textColor: Colors.black,
      fontSize: 16.0,);

  }
  void showSuccessMessages(String message){
    Fluttertoast.showToast(
      msg: '${Messages.SUCCESS} : $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.lightBlue[300],
      textColor: Colors.black,
      fontSize: 16.0,);

  }

  void closeDialogWithSuccessMessages(String? message){
    if(progressDialog!=null){
      progressDialog?.close();
      progressDialog = null;
    }
    if(message==null) {
      showSuccessMessages(Messages.SUCCESS);
    }else {
      showSuccessMessages(message);
    }
  }

  void closeDialogWithErrorMessages(String message){
    if(progressDialog!=null){
      progressDialog?.close();
      progressDialog = null;
    }
    showErrorMessages(message);

  }
  void closeDialog(){
    if(progressDialog!=null){
      progressDialog?.close();
      progressDialog = null;
    }

  }


  String? getExtension(String? name){
    if(name==null){
      return null;
    }
    return path.extension(name);
  }
  IdempiereUser getSavedIdempiereUser(){
    return Memory.getSavedIdempiereUser();

  }
  void saveIdempiereUser(var data){
    if(data is ResponseApi){
      GetStorage().write(Memory.KEY_USER,data.data);
    } else if(data is IdempiereUser) {
      GetStorage().write(Memory.KEY_USER,data.toJson());
    } else {
      return;
    }
  }
  Future<IdempiereUser?> doRefreshWhenNeed(IdempiereUser user) async {

    if(user.needDoRefresh() && user.canDoRefresh()) {
      IdempiereSession session = await IdempiereRESTProvider().refresh(
          Memory.IDEMPIERE_ENDPOINT_AUTH_REFRESH, user);
      if(session.token!=''){
        user.token = session.token;
      }
      if(session.refreshToken!=''){
        user.refreshToken = session.refreshToken;
      }
      print('------------------new---user.token ${user.token ?? ''}');
      print('------------------new---user.refreshToken ${user.refreshToken ?? ''}');

    } else {
      print('-----------------no refresh---user.refreshToken ${user.refreshTokenExpireInMinutes()}');
      print('-----------------no refresh---user.tokenExpireInMinutes ${user.tokenExpireInMinutes()}');

    }
    saveIdempiereUser(user);
    return user;

  }
  Future<ResponseApi> refresh(IdempiereUser user) async {
    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url


    try {
      var session = await IdempiereRESTProvider().refresh(
          Memory.IDEMPIERE_ENDPOINT_AUTH_REFRESH, user);

      if (user.token == null || user.token!.isEmpty) {
        responseApi.success = false;
        showErrorMessages(Messages.REFRESH_FAILED);
        return responseApi;
      } else {
        responseApi.success = true;
        responseApi.data = session;
        user.token = session.token;
        String? date = DateTime.now().toIso8601String();
        user.tokenCreatedAt = date;
        user.refreshToken = session.refreshToken;
        user.refreshTokenCreatedAt = date;
        responseApi.data = user;
        return responseApi;
      }
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(Messages.TIME_OUT);
      print(err);
      return responseApi;
    } catch (e) {
      showErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return responseApi;
    }
  }
  Future<bool> logOut(IdempiereUser user) async {

    // instantiate the singleton idempiere client with the API url


    try {


      var result = await IdempiereRESTProvider().logOut(
          Memory.IDEMPIERE_ENDPOINT_AUTH_LOGOUT, user);

      if (!result) {
        showErrorMessages(Messages.LOGOUT_FAILED);
        return false;
      } else {
        return true;
      }
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(Messages.TIME_OUT);
      print(err);
      return false;
    } catch (e) {
      showErrorMessages(Messages.ERROR_HTTP);
      print(e);
      return false;
    }
  }
  Future<ResponseApi> findByCondition(String? endPoint,String query) async{
    if(endPoint==null){
      showErrorMessages('${Messages.ERROR}: ${Messages.END_POINT_IS_NULL}');
      return ResponseApi();
    }

    ResponseApi responseApi = ResponseApi();
    // instantiate the singleton idempiere client with the API url
    if(query.isEmpty){
      query = endPoint;
    } else {
      query ='$endPoint?\$filter=$query';

    }


    print('-----------------------------------------------------------------------------------');
    print('----query: $query');
    print('-----------------------------------------------------------------------------------');
    responseApi.success = false ;
    try {
      IdempiereUser? user = getSavedIdempiereUser();
      user = await doRefreshWhenNeed(user);
      if(user==null || user.token==null || user.token!.isEmpty){
        showErrorMessages(Messages.REFRESH_FAILED);
        Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false);
      }

      IdempiereQueryResult? queryResult = await IdempiereRESTProvider().getIdempiereLists(query);
      responseApi.data = queryResult;
      if(queryResult == null){
        return responseApi;
      } else {
        responseApi.success = true;
        return responseApi;
      }

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

}