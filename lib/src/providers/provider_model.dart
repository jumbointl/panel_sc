import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:path/path.dart' as path;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/memory.dart';
import '../data/messages.dart';
import '../models/response_api.dart';
import '../models/user.dart';

class ProviderModel extends GetConnect{
  ProgressDialog? progressDialog;
  Color backGroundColor = Colors.blue;
  int showMessageInSeconds = 3;
  BuildContext? context;
  late String urlApp ;
  late String urlAppWithoutHttp ;
  bool showProgress = false;
  final Completer<bool> completer = Completer();
  ProviderModel(){
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
  User getSavedUser(){
    return Memory.getSavedUser();


  }
  void saveUser(var data){
    if(data is ResponseApi){
      GetStorage().write(Memory.KEY_USER,data.data);
    } else if(data is User) {
      GetStorage().write(Memory.KEY_USER,data.toJson());
    } else {
      return;
    }



    Memory.getHeaders();
  }


}