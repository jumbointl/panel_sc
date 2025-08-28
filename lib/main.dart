import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/data/panel_sc_routes.dart';
import 'package:solexpress_panel_sc/src/models/user.dart';



void main() async{
  await GetStorage.init();


  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late User userSession ;
  Color primaryColor = Memory.PRIMARY_COLOR;

  get pushNotificationsProvider => null;
  @override
  initState() {
    // TODO: implement initState
    Get.testMode = true;
    super.initState();
    userSession = Memory.getSavedUser();
    if(userSession.roles !=null && userSession.roles![0].id !=null &&
        userSession.roles![0].id == Memory.ROL_WAREHOUSE.id){
      Memory.THEME = Memory.THEME_WAREHOUSE;
    }
    Memory.checkExternalMediaPermission();
  }
  @override
  Widget build(BuildContext context) {


    String? home =Memory.ROUTE_IDEMPIERE_LOGIN_PAGE;
    //String? home =MemorySol.ROUTE_VIDEO_PLAY_LIST_PAGE;
    String appTitle =Messages.IDEMPIERE_APP_NAME;
    return GetMaterialApp(
      title: Messages.APP_NAME,
      debugShowCheckedModeBanner: false,
      initialRoute: home,
      getPages: PanelScRoutes.pages,
      theme: Memory.THEME,
      //navigatorKey: Get.key,
    );

  }

}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}