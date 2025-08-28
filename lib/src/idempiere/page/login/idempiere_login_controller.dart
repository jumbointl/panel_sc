
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idempiere_rest/idempiere_rest.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import '../../../data/memory.dart';
import '../../../models/host.dart';
import '../../../models/idempiere/idempiere_user.dart';
import '../../common/idempiere_controller_model.dart';
import '../../provider/idempiere_rest_provider.dart';
import '../../provider/idempiere_users_provider.dart';


class IdempiereLoginController extends IdempiereControllerModel{

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var showPassword = false.obs;
  var isTestMode = false.obs;
  var rememberMe = true.obs;

  var autoLogin = false.obs;

  var idHost = '1'.obs;
  IdempiereLoginController(){
    isLoading.value = false;
    Host host = getSavedHost();
    if(host.id==null){
      setHost('1');
    } else {
      setHost(host.id.toString());
    }

    var v2 = GetStorage().read(Memory.KEY_AUTO_LOGIN);
    print('var value ${v2 ?? 'null'}');
    if(v2!=null && v2 is bool){
      autoLogin.value = v2;
    }

    IdempiereUser user =getSavedIdempiereUser();
    if(user.userName !=null){
      userNameController.text = user.userName!;
    }
    if(user.password !=null){
      passwordController.text = user.password!;
    }

  }


  void goToSetUrlPage(){
    Get.toNamed(Memory.ROUTE_IDEMPIERE_CONFIGURATION_PAGE);
  }

 Future<void>  login(BuildContext context) async{
    autoLogin.value = false;

    String userName = userNameController.text.trim();
    String password = passwordController.text.trim();

    if(isValidForm(userName, password)){

        String appHost = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
        String appHostName = GetStorage().read(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP) ?? '';

        print('----------------------login----url $appHost');
        print('----------------------login----url $appHostName');

        if(appHost=='' || appHostName==''){
          setHost('1');
        }
        /*
        if(appHost=='' || appHostName==''){
          setTestMode(isTestMode.value);
        }

         */
        //IdempiereClient().setBaseUrl(Memory.APP_HOST_WITH_HTTP);
        IdempiereRESTProvider().setBaseUrl(Memory.APP_HOST_WITH_HTTP);

        IdempiereUsersProvider usersProvider = IdempiereUsersProvider();
        isLoading.value = true;
        IdempiereUser user = IdempiereUser(userName: userName, password: password, name: userName);
        ResponseApi responseApi = await usersProvider.login(user);
        isLoading.value = false;

        if(responseApi.success==null || !responseApi.success!){
          return ;
        } else {
          LoginResponse login = responseApi.data;

          user.setClientsFromLoginRequest1(login.clients);
          user.token =login.token;
          saveIdempiereUser(user);
          Get.toNamed(Memory.ROUTE_IDEMPIERE_ROLES_PAGE,arguments:{Memory.KEY_USER:user});
        }
        /*


         */

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
  bool isValidForm(String email, String password){
    if(email.isEmpty){
      showErrorMessages(Messages.EMAIL);
      return false;
    }
    if(password.isEmpty){
      showErrorMessages(Messages.PASSWORD);
      return false;
    }
    return true;
  }


  void setShowPassword(bool newValue) {
    showPassword.value = newValue;
    update();
  }
  /*
  void setTestMode(bool newValue) async{
    isTestMode.value = newValue;
    GetStorage().write(Memory.KEY_IS_USING_LOCAL_HOST, newValue);
    if(isTestMode.value){
      Memory.APP_HOST_WITH_HTTP = Memory.APP_HOST_WITH_HTTP_TEST;
      Memory.APP_HOST_NAME_WITHOUT_HTTP = Memory.APP_HOST_NAME_WITHOUT_HTTP_TEST;
      GetStorage().write(Memory.KEY_APP_HOST_WITH_HTTP, Memory.APP_HOST_WITH_HTTP_TEST);
      GetStorage().write(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP, Memory.APP_HOST_NAME_WITHOUT_HTTP_TEST);
    } else {
      Memory.APP_HOST_NAME_WITHOUT_HTTP = Memory.APP_HOST_NAME_WITHOUT_HTTP_PRODUCTION;
      Memory.APP_HOST_WITH_HTTP = Memory.APP_HOST_WITH_HTTP_PRODUCTION;
      GetStorage().write(Memory.KEY_APP_HOST_WITH_HTTP, Memory.APP_HOST_WITH_HTTP_PRODUCTION);
      GetStorage().write(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP, Memory.APP_HOST_NAME_WITHOUT_HTTP_PRODUCTION);
    }
    update();
  }
  */
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

  void setHost(String string) {
    idHost.value = string;
    Host host = getHostFromId(Memory.listHost, int.tryParse(string));
    if(host.id!= null && host.id! ==3){
      Host h =getSavedUserHost();
      if(h.url!=null && Memory.customHost!=null){
        host.url = h.url;
      }
      saveUserHost(host);
    }
    print('--------------------------host ${host.toJson()}');
    if(host.url!=null){
      String url = host.url!;
      String urlWithoutHttp = url.replaceAll('http://', '');
      Memory.APP_HOST_NAME_WITHOUT_HTTP = urlWithoutHttp;
      Memory.APP_HOST_WITH_HTTP = url;
      print('--------------------------url $url');

      saveHost(host);
      GetStorage().write(Memory.KEY_APP_HOST_WITH_HTTP, url);
      GetStorage().write(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP, urlWithoutHttp);

    }
    update();

  }



}