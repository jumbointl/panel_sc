
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/sol_express_event.dart';
import '../../data/memory.dart';
import '../../models/host.dart';
import '../../models/idempiere/idempiere_user.dart';
import '../../models/panel_sc_config.dart';
import '../../models/pos.dart';
import '../attendance/common/panel_controller_model.dart';


class PanelScLoginController extends PanelControllerModel{

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController panelIdController = TextEditingController();
  TextEditingController posIdController = TextEditingController();
  TextEditingController fontSizeAdjustmentController = TextEditingController();
  TextEditingController logoSizeAdjustmentController = TextEditingController();
  TextEditingController clockRightMarginAdjustmentController = TextEditingController();
  var showPassword = false.obs;
  var isTestMode = false.obs;
  var rememberMe = true.obs;

  var autoLogin = false.obs;

  var idHost = '1'.obs;
  var idFileHost = '1'.obs;
  var idFunction = MemoryPanelSc.getDefaultFunction().id.toString().obs;

  var onlyTv = false.obs;
  var attendancePanel = Memory.TYPE_OF_PANEL == Memory.EVENT_PANEL ? true.obs : false.obs;

  PanelScLoginController(){
    MemoryPanelSc.panelScConfig = PanelScConfig();
    MemoryPanelSc.pos = Pos();
    MemoryPanelSc.event = SolExpressEvent();

    userNameController.text = MemoryPanelSc.defaultUserName;
    passwordController.text = MemoryPanelSc.defaultPassword;
    panelIdController.text = MemoryPanelSc.defaultPanelId;

    fontSizeAdjustmentController.text = MemoryPanelSc.defaultFontSizeAdjustment;
    logoSizeAdjustmentController.text = MemoryPanelSc.defaultLogoSizeAdjustment;
    clockRightMarginAdjustmentController.text = MemoryPanelSc.defaultClockRightMarginAdjustment;

    isLoading.value = false;
    Host host = getSavedHost();
    if(host.id==null){
      setHost(null,'1');
    } else {
      setHost(null,host.id.toString());
    }

    var fileHost = GetStorage().read(Memory.KEY_APP_FILE_HOST_WITH_HTTP);
    if(fileHost==null){
      setFileHost(null, MemoryPanelSc.productionHost1.id.toString());
    } else {
      Host host = Host.fromGetStorage(fileHost);
      if(host.id!=null){
        int? aux =int.tryParse(host.id.toString());
        if(aux!= null && aux>3){
          host = MemoryPanelSc.productionHost1;
        } else if(host.url!=null && host.id==3){
          GetStorage().write(Memory.KEY_COSTUM_URL, host);
        }
        if(host.url!=null){
          MemoryPanelSc.fileHost1St = host.url!;
        }
        idFileHost.value = host.id.toString();
      }
    }

    var v2 = GetStorage().read(Memory.KEY_AUTO_LOGIN);
    if(v2!=null && v2 is bool){
      autoLogin.value = v2;

    }
    var v3 = GetStorage().read(Memory.KEY_TEST_MODE);
    if(v3!=null && v3 is bool){
      isTestMode.value = v3;
    }

    IdempiereUser user =getSavedIdempiereUser();
    if(user.userName !=null){
      userNameController.text = user.userName!;
    }
    if(user.password !=null){
      passwordController.text = user.password!;
    }
    String panelId = GetStorage().read(Memory.KEY_ID) ?? '';
    if(panelId.isNotEmpty){
      panelIdController.text = panelId;
    }
    String posId = GetStorage().read(Memory.KEY_POS_ID) ?? MemoryPanelSc.defaultPosId;
    if(posId.isNotEmpty){
      posIdController.text = posId.toUpperCase();
    }

    String aux = GetStorage().read(Memory.KEY_FONT_SIZE_ADJUSTMENT) ?? '';
    if(aux.isNotEmpty){
      fontSizeAdjustmentController.text = aux;
    }

    aux = GetStorage().read(Memory.KEY_LOGO_SIZE_ADJUSTMENT) ?? '';
    if(aux.isNotEmpty){
      logoSizeAdjustmentController.text = aux;
    }


    aux = GetStorage().read(Memory.KEY_CLOCK_RIGHT_MARGIN_ADJUSTMENT) ?? '';
    if(aux.isNotEmpty){
      clockRightMarginAdjustmentController.text = aux;
    }



    onlyTv.value = GetStorage().read(Memory.KEY_ONLY_TV) ?? false;

    int functionId = GetStorage().read(Memory.KEY_FUNCTION) ?? 0;
    if(functionId>1){

      if(!MemoryPanelSc.isValidFunctionId(functionId)){
        functionId = MemoryPanelSc.getDefaultFunction().id!;
      }

      idFunction.value = functionId.toString();
      if(functionId==MemoryPanelSc.showAttendanceFunctionPanelSc.id ||
       functionId==MemoryPanelSc.registerAttendanceFunctionPanelSc.id){
        attendancePanel.value = true;
        autoLogin.value = true;
      }
    }


  }


  void goToSetUrlPage(){
    Get.toNamed(Memory.ROUTE_IDEMPIERE_CONFIGURATION_PAGE);
  }

 Future<void>  login(BuildContext context) async{

    String panelId = panelIdController.text.trim();
    if(panelId.isEmpty){
      showErrorMessages(Messages.ID);
      return ;
    }
    int? aux = int.tryParse(panelId);
    if(aux==null){
      showErrorMessages(Messages.ID);
      return ;
    }
    GetStorage().write(Memory.KEY_ID, panelId);
    GetStorage().write(Memory.KEY_EVENT_ID, panelId);


    autoLogin.value = false;
    if(attendancePanel.value){
      String posId = posIdController.text.trim();
      if(posId.isNotEmpty){
        int? aux = int.tryParse(posId);
        if(aux==null){
          showErrorMessages(Messages.POS);
          return ;
        }
        GetStorage().write(Memory.KEY_POS_ID, posId);
      }
      setAdjustment();
      if(panelId.isEmpty){
        showErrorMessages(Messages.ID);
        return ;
      }
      int? aux = int.tryParse(panelId);
      if(aux==null){
        showErrorMessages(Messages.ID);
        return ;
      }
      GetStorage().write(Memory.KEY_ID, panelId);
      Memory.DB_NAME = MemoryPanelSc.DB_NAME;
      isLoading.value = true;
      bool b = await connectToPostgresAttendance();
      isLoading.value = false;

      if(!b){
        showErrorMessages(Messages.LOGIN);
        return;
      }
      if(MemoryPanelSc.pos.functionId == null || MemoryPanelSc.pos.functionId! <= 0){
        DateTime now = DateTime.now();
        String date = now.toIso8601String().split('T')[0];
        String hint = '${Messages.ID} $posId $date ${Messages.NO_DATA_FOUND}';
        showErrorMessages('$hint ${Messages.REVIEW_DATA_IN_DATABASE}');
        return;
      }
      switch(MemoryPanelSc.pos.functionId){
        case MemoryPanelSc.FUNCTION_SHOW_ATTENDANCE:
          Get.toNamed(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE);
          break;
        case MemoryPanelSc.FUNCTION_REGISTER_ATTENDANCE:
          Get.toNamed(Memory.ROUTE_PANEL_SC_REGISTER_ATTENDANCE_PAGE);
          break;
        case MemoryPanelSc.FUNCTION_ADMIN_ATTENDANCE:
          Get.toNamed(Memory.ROUTE_PANEL_ADMIN_ATTENDANCE_PAGE);
          break;
        default:
          showErrorMessages('${Messages.FUNTION_NOT_ENABLED_YED} : ${Messages.POS} : ${MemoryPanelSc.pos.functionId!}');
          return;

      }

      return;


    }

        /*if(idFunction.value == MemoryPanelSc.showAttendanceFunctionPanelSc.id.toString()){
        setAdjustment();
        if(panelId.isEmpty){
          showErrorMessages(Messages.ID);
          return ;
        }
        int? aux = int.tryParse(panelId);
        if(aux==null){
          showErrorMessages(Messages.ID);
          return ;
        }
       GetStorage().write(Memory.KEY_ID, panelId);
       Memory.DB_NAME = MemoryPanelSc.DB_NAME;
       isLoading.value = true;
       bool b = await connectToPostgresAndLoadAttendance();
       isLoading.value = false;
       if(b){
         Get.toNamed(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE);
       }
       return;


    } else if(idFunction.value == MemoryPanelSc.registerAttendanceFunctionPanelSc.id.toString()){
      setAdjustment();
      Memory.DB_NAME = MemoryPanelSc.DB_NAME;
      if(panelId.isEmpty){
        showErrorMessages(Messages.ID);
        return ;
      }
      int? aux = int.tryParse(panelId);
      if(aux==null){
        showErrorMessages(Messages.ID);
        return ;
      }
      GetStorage().write(Memory.KEY_ID, panelId);
      isLoading.value = true;
      bool b = await connectToPostgresAndLoadAttendance();
      isLoading.value = false;
      if(b){
        Get.toNamed(Memory.ROUTE_PANEL_SC_REGISTER_ATTENDANCE_PAGE);
      }
      return;

    }*/


    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();


    if(isValidForm(userName, password,panelId)){

        String appHost = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
        String appHostName = GetStorage().read(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP) ?? '';

        print('----------------------login----url $appHost');
        print('----------------------login----url $appHostName');

        if(appHost=='' || appHostName==''){
          setHost(null, '1');
        }

        isLoading.value = true;
        IdempiereUser user = IdempiereUser(userName: userName, password: password, name: userName);
        saveIdempiereUser(user);
        await getPanelScConfiguration();
        bool success = await connectToPostgresAndLoadTicket(user);
        int selectedFuntion = int.tryParse(idFunction.value) ?? 1;
        isLoading.value = false;
        if(success){
          saveIdempiereUser(user);
          switch(selectedFuntion){

            case MemoryPanelSc.FUNCTION_CALLER:
              Get.toNamed(Memory.ROUTE_PANEL_SC_CALLING_PAGE,arguments:{Memory.KEY_IDEMPIERE_USER:user});
              break;
            default:
              Get.toNamed(Memory.ROUTE_PANEL_SC_VIDEO_DOWNLOAD_PAGE,arguments:{Memory.KEY_IDEMPIERE_USER:user});
              break;
          }

        }

    }
  }
  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }
  void goToUserRolHomePage(String page){
    Get.offNamedUntil(page,(route)=>false);
  }
  @override
  void goToRolesPage(){
    Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE,(route)=>false);
  }
  void goToClientHomePage(){
    Get.offNamedUntil(Memory.ROUTE_CLIENT_HOME_PAGE,(route)=>false);
  }
  bool isValidForm(String email, String password, String panelId){
    if(email.isEmpty){
      showErrorMessages(Messages.EMAIL);
      return false;
    }
    if(password.isEmpty){
      showErrorMessages(Messages.PASSWORD);
      return false;
    }
    if(panelId.isEmpty){
      showErrorMessages(Messages.ID);
      return false;
    }
    int? aux = int.tryParse(panelId);
    if(aux==null){
      showErrorMessages(Messages.ID);
      return false;
    }
    GetStorage().write(Memory.KEY_ID, panelId);
    return true;
  }


  void setShowPassword(bool newValue) {
    showPassword.value = newValue;
    update();
  }

  void setAutoLogin(bool newValue) {
    autoLogin.value = newValue;
    GetStorage().write(Memory.KEY_AUTO_LOGIN, newValue);
    update();
  }
  void setRememberMe(bool newValue) {
    rememberMe.value = newValue;
    GetStorage().write(Memory.KEY_REMEMBER_ME, newValue);
    update();
  }
  void setFunction(String string) {
    idFunction.value = string;
    int? aux = int.tryParse(string);
    if(aux==null){
      return;
    }
    GetStorage().write(Memory.KEY_FUNCTION, aux);
    if(aux==MemoryPanelSc.showAttendanceFunctionPanelSc.id ||
        aux==MemoryPanelSc.registerAttendanceFunctionPanelSc.id){
      attendancePanel.value = true;
    } else {
      attendancePanel.value = false;
    }


    update();

  }
  void setHost(BuildContext? context, String string) {
    idHost.value = string;
    Host host = getHostFromId(Memory.listHost, int.tryParse(string));
    if(host.id!= null){
      saveUserHost(host);
    }
    if(host.url!=null){
      String url = host.url!;
      String urlWithoutHttp = url.replaceAll('https://', '');
      urlWithoutHttp = url.replaceAll('http://', '');
      Memory.APP_HOST_NAME_WITHOUT_HTTP = urlWithoutHttp;
      Memory.APP_HOST_WITH_HTTP = url;

      saveHost(host);
      GetStorage().write(Memory.KEY_APP_HOST_WITH_HTTP, url);
      GetStorage().write(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP, urlWithoutHttp);

    }
    update();

  }

  Future<void> setFileHost(BuildContext? context, String string) async {

    if(string=='3' && context!=null){
      Host host = getHostFromId(MemoryPanelSc.listFileHost, int.tryParse(string));

      String? url = await showInputDialog(context, Messages.CUSTOM_URL,Messages.CUSTOM_URL,host.url!);
      if(url!=null && url.startsWith('http')){
        host.url = url;
        host.name = url ;
        GetStorage().write(Memory.KEY_COSTUM_URL, host);
        print('new file host : $url');
        Memory.APP_FILE_HOST_WITH_HTTP = url;
        GetStorage().write(Memory.KEY_APP_FILE_HOST_WITH_HTTP, host);
        idFileHost.value = string;
        update();
        return;
      }
    }

    idFileHost.value = string;

    Host host = getHostFromId(MemoryPanelSc.listFileHost, int.tryParse(string));

    if(host.url!=null){
      String url = host.url!;
      print('new file host : $url');
      Memory.APP_FILE_HOST_WITH_HTTP = url;
      GetStorage().write(Memory.KEY_APP_FILE_HOST_WITH_HTTP, host);

    }
    update();

  }


  void setOnlyTv(bool newValue) {
    onlyTv.value = newValue;
    GetStorage().write(Memory.KEY_ONLY_TV, newValue);
    update();

  }
  void setTestMode(bool newValue) {
    isTestMode.value = newValue;
    GetStorage().write(Memory.KEY_TEST_MODE, newValue);
    update();

  }

  void stopTimers() async{
    print('-------------------stop timers');
    if(MemoryPanelSc.registerAttendanceTimer!=null){
      print('-------------------stop registerAttendanceTimer');
      MemoryPanelSc.registerAttendanceTimer!.cancel();
      MemoryPanelSc.registerAttendanceTimer = null;
    }
    if(MemoryPanelSc.readAttendanceTimer!=null){
      print('-------------------stop readAttendanceTimer');
      MemoryPanelSc.readAttendanceTimer!.cancel();
      MemoryPanelSc.readAttendanceTimer = null;
    }
    if(MemoryPanelSc.panelScTimer!=null){
      print('-------------------stop panelScTimer');
      MemoryPanelSc.panelScTimer!.cancel();
      MemoryPanelSc.panelScTimer = null;
    }
    if(MemoryPanelSc.clockTimer!=null){
      print('-------------------stop clockTimer');
      MemoryPanelSc.panelScTimer!.cancel();
      MemoryPanelSc.panelScTimer = null;
    }

  }

  void setAdjustment() {
    if(fontSizeAdjustmentController.text.isNotEmpty){
      String aux = fontSizeAdjustmentController.text.trim();
      double? fontSizeAdjustment = double.tryParse(aux);
      if(fontSizeAdjustment!=null){
        GetStorage().write(Memory.KEY_FONT_SIZE_ADJUSTMENT, aux);
        MemoryPanelSc.fontSizeAdjustment = fontSizeAdjustment/100;
      }

    }
    if(logoSizeAdjustmentController.text.isNotEmpty){
      String aux = logoSizeAdjustmentController.text.trim();
      double? logoSizeAdjustment = double.tryParse(aux);
      if(logoSizeAdjustment!=null){
        GetStorage().write(Memory.KEY_LOGO_SIZE_ADJUSTMENT, aux);
        MemoryPanelSc.logoSizeAdjustment = logoSizeAdjustment/100;
      }
    }
    if(clockRightMarginAdjustmentController.text.isNotEmpty){
      String aux = clockRightMarginAdjustmentController.text.trim();
      double? clockRightMarginAdjustment = double.tryParse(aux);
      if(clockRightMarginAdjustment!=null){
        GetStorage().write(Memory.KEY_CLOCK_RIGHT_MARGIN_ADJUSTMENT, aux);
        MemoryPanelSc.clockRightMarginAdjustment = clockRightMarginAdjustment;
      }

    }

  }




}