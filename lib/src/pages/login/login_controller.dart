
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import '../../data/memory.dart';
import '../../models/host.dart';
import '../../models/rol.dart';
import '../../models/user.dart';
import '../../providers/users_provider.dart';


class LoginController extends ControllerModel{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController panelIdController = TextEditingController();
  var showPassword = false.obs;
  var isTestMode = false.obs;

  var autoLogin = false.obs;

  var idHost = '1'.obs;
  LoginController(){
    isLoading.value = false;
    Host host = getSavedHost();
    if(host.id==null){
      setHost('1');
    } else {
      setHost(host.id.toString());
    }

    /*
    var v = GetStorage().read(Memory.KEY_IS_USING_LOCAL_HOST);
    if(v!=null && v is bool){
      isTestMode.value = v;
    }
    */
    var v2 = GetStorage().read(Memory.KEY_AUTO_LOGIN);
    print('var value ${v2 ?? 'null'}');
    if(v2!=null && v2 is bool){
      autoLogin.value = v2;
    }

    User user = getSavedUser();
    if(user.email !=null){
      emailController.text = user.email!;
    }
    if(user.password !=null){
      passwordController.text = user.password!;
    }

  }


  void goToRegisterPage(){
    Get.toNamed(Memory.ROUTE_REGISTER_PAGE);
  }

  @override
  void setRols(User myUser) {
    if (myUser.roles!.length > 1) {
      for(int i=0; i < myUser.roles!.length; i++){

        switch ( myUser.roles![i].id) {
          case 1:
            myUser.roles![i] = Memory.ROL_ADMIN;
            break;
          case 2:
            myUser.roles![i] = Memory.ROL_DELIVERY_MAN;
            break;
          case 3:
            myUser.roles![i] = Memory.ROL_CLIENT;
            break;
          case 4:
            myUser.roles![i] = Memory.ROL_ORDERSPICKER;
            break;
          case 5:
            myUser.roles![i] = Memory.ROL_SELLER;
            break;

        }

      }
    } else { // SOLO UN ROL
      myUser.roles = <Rol>[Memory.ROL_CLIENT];
    }

  }
 Future<void>  login(BuildContext context) async{
    autoLogin.value = false;

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if(isValidForm(email, password)){

        String appHost = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
        String appHostName = GetStorage().read(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP) ?? '';
        if(appHost=='' || appHostName==''){
          setHost('1');
        }
        /*
        if(appHost=='' || appHostName==''){
          setTestMode(isTestMode.value);
        }

         */

        UsersProvider usersProvider = UsersProvider();
        isLoading.value = true;
        ResponseApi responseApi = await usersProvider.login(context,email, password);
        isLoading.value = false;
        if(responseApi.success==null || !responseApi.success!){
          showErrorMessages(responseApi.message ?? '');
        } else {

          saveUser(responseApi,password);
          User myUser = getSavedUser();

          goToPanelScHomePage();

          /*if (myUser.roles!.length > 1) {
            goToRolesPage();
          } else if (myUser.roles!.length ==1 && myUser.roles![0].route !=null ){ // SOLO UN ROL
            goToUserRolHomePage(myUser.roles![0].route!);
          }*/
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
  bool isValidForm(String email, String password){
    if(email.isEmpty || !GetUtils.isEmail(email)){
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

  void setHost(String string) {
    idHost.value = string;
    Host host = getHostFromId(Memory.listHost, int.tryParse(string));
    if(host.url!=null){
      String url = host.url!;
      String urlWithoutHttp = url.replaceAll('http://', '');
      Memory.APP_HOST_NAME_WITHOUT_HTTP = urlWithoutHttp;
      Memory.APP_HOST_WITH_HTTP = url;
      saveHost(host);
      GetStorage().write(Memory.KEY_APP_HOST_WITH_HTTP, url);
      GetStorage().write(Memory.KEY_APP_HOST_NAME_WITHOUT_HTTP, urlWithoutHttp);

    }
    update();

  }

  void goToPanelScHomePage() {
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);

  }



}