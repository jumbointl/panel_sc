import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/attendance/register/register_attendance_page.dart';
import 'package:solexpress_panel_sc/src/pages/panel_sc_home/panel_sc_home_page.dart';
import '../idempiere/page/configuration/idempiere_configuration_page.dart';
import '../pages/attendance/admin/admin_attendance_page.dart';
import '../pages/attendance/show/event_config_page.dart';
import '../pages/attendance/show/show_attendance_live_page.dart';
import '../pages/attendance/show/show_attendance_page.dart';
import '../pages/panel_sc_calling/panel_sc_calling_page.dart';
import '../pages/panel_sc_login/panel_sc_login_page.dart';
import '../pages/panel_sc_roles/panel_sc_roles_page.dart';
import '../pages/video/video_download_screen.dart';
import '../pages/web/web_page.dart';
import 'memory.dart';

class PanelScRoutes {
  static final int seconds = Memory.DURATION_TRANSITION_SECUNDS ;
  static final int milliSeconds = Memory.DURATION_TRANSITION_MILLI_SECUNDS ;
  static final int shortSeconds = Memory.DURATION_TRANSITION_SHORT_SECUNDS ;
  static final List<GetPage> pages = [
  GetPage(name: Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, page: ()=>PanelScLoginPage(),
  transition: Transition.zoom ,
  transitionDuration: Duration(milliseconds: milliSeconds),),
  GetPage(name: Memory.ROUTE_IDEMPIERE_CONFIGURATION_PAGE, page: ()=>IdempiereConfigurationPage()
  ,transition: Transition.zoom ,
  transitionDuration: Duration(milliseconds: milliSeconds),),
  GetPage(name: Memory.ROUTE_IDEMPIERE_HOME_PAGE, page: ()=>PanelScHomePage(),
  transition: Transition.circularReveal ,
  transitionDuration: Duration(seconds: shortSeconds),),

    GetPage(name: Memory.ROUTE_PANEL_SC_VIDEO_DOWNLOAD_PAGE, page: ()=>VideoDownloadScreen(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: shortSeconds),),

  GetPage(name: Memory.ROUTE_PANEL_SC_CALLING_PAGE, page: ()=>PanelScCallingPage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
  GetPage(name: Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE, page: ()=>ShowAttendanceLivePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
  GetPage(name: Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE, page: ()=>ShowAttendancePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),

  GetPage(name: Memory.ROUTE_PANEL_SC_REGISTER_ATTENDANCE_PAGE, page: ()=>RegisterAttendancePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),

  GetPage(name: Memory.ROUTE_PANEL_ADMIN_ATTENDANCE_PAGE, page: ()=>AdminAttendancePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: shortSeconds),),
  GetPage(name: Memory.ROUTE_PANEL_EVENT_CONFIG_PAGE, page: ()=>EventConfigPage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),


  GetPage(name: Memory.ROUTE_IDEMPIERE_ROLES_PAGE, page: () => PanelScRolesPage(),
  transition: Transition.circularReveal ,
  transitionDuration: Duration(seconds: seconds),),

    GetPage(
      name: Memory.ROUTE_WEB_VIEW_PAGE, // Or AppRoutes.webViewPage
      page: () {
        // 1. Retrieve the URL from arguments
        final dynamic arguments = Get.arguments;
        String urlToLoad = Memory.WEB_URL; // Default or error URL

        if (arguments is String) {
          urlToLoad = arguments;
        } else if (arguments is Map<String, dynamic> && arguments.containsKey('url')) {
          // If you prefer passing arguments as a map: Get.toNamed(..., arguments: {'url': 'your_url'})
          urlToLoad = arguments['url'] as String;
        } else {
          // Handle the case where the URL is not provided or in an unexpected format
          // You could navigate to an error page, show a default page, or throw an error.
          print("Error: URL not provided or in incorrect format for web view page.");
          // For simplicity, returning a GetWebPage with a default/error URL.
          // In a real app, you might want to return a dedicated error widget/page.
          return WebPage(url: 'about:blank'); // Or some error indication page
        }

        if (urlToLoad.isEmpty || !Uri.tryParse(urlToLoad)!.isAbsolute) {
          print("Error: Invalid URL provided: $urlToLoad");
          return Scaffold(
            appBar: AppBar(title: Text("Invalid URL")),
            body: Center(child: Text("The URL '$urlToLoad' is not valid.")),
          );
        }

        // 2. Return your GetWebPage widget, passing the URL
        return WebPage(url: urlToLoad);
      },
      transition: Transition.cupertino, // Or your preferred transition
      transitionDuration: Duration(milliseconds: seconds),
      // Optional: Define bindings if your WebPageController needs specific setup
      // that isn't handled by Get.put within GetWebPage itself.
      // binding: BindingsBuilder(() {
      //   // Get.lazyPut<WebPageController>(() => WebPageController(initialUrl: Get.arguments as String? ?? 'about:blank'), tag: Get.arguments as String?);
      // })
    ),
  ];






}