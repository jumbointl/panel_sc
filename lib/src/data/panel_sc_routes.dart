import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/attendance/register/register_attendance_page.dart';
import 'package:solexpress_panel_sc/src/pages/panel_sc_home/panel_sc_home_page.dart';
import '../idempiere/page/configuration/idempiere_configuration_page.dart';
import '../pages/attendance/show/show_attendance_page.dart';
import '../pages/panel_sc_calling/panel_sc_calling_page.dart';
import '../pages/panel_sc_login/panel_sc_login_page.dart';
import '../pages/panel_sc_roles/panel_sc_roles_page.dart';
import '../pages/video/video_download_screen.dart';
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
  GetPage(name: Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE, page: ()=>ShowAttendancePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),

  GetPage(name: Memory.ROUTE_PANEL_SC_REGISTER_ATTENDANCE_PAGE, page: ()=>RegisterAttendancePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_ROLES_PAGE, page: () => PanelScRolesPage(),
  transition: Transition.circularReveal ,
  transitionDuration: Duration(seconds: seconds),),];






}