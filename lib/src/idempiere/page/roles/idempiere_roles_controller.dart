import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_organization.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_rol.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_tenant.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_warehouse.dart';
import '../../../data/memory.dart';
import '../../../models/idempiere/idempiere_user.dart';
import '../../../models/response_api.dart';
import '../../common/idempiere_controller_model.dart';
import '../../provider/idempiere_users_provider.dart';
class IdempiereRolesController extends IdempiereControllerModel {
  IdempiereUsersProvider usersProvider = IdempiereUsersProvider();
  late IdempiereUser user ;
  List<IdempiereTenant> clients = <IdempiereTenant>[];
  RxList<IdempiereRol> roles = <IdempiereRol>[].obs;
  RxList<IdempiereOrganization> organizations = <IdempiereOrganization>[].obs;
  RxList<IdempiereWarehouse> warehouses = <IdempiereWarehouse>[].obs;

  var idClient =''.obs;
  var idRole =''.obs;
  var idOrganization =''.obs;
  var idWarehouse =''.obs;
  var showMoreData =false.obs;

  IdempiereRolesController(){
    user = getSavedIdempiereUser();
    print('user ${user.toJson()}');
    clients = user.clients ?? <IdempiereTenant>[];

  }
  void goToPageRol() {
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_HOME_PAGE, (route) => false);
  }

  void getRoles(int? id) async {


    if(id==null){
      return;
    }
    warehouses.clear();
    organizations.clear();
    roles.clear();
    idRole.value ='';
    idOrganization.value ='';
    idWarehouse.value ='';

    user.clientId = id ;
    isLoading.value = true;
    ResponseApi responseApi = await usersProvider.getRoles(user);
    isLoading.value = false;

    if(responseApi.success==null || !responseApi.success!){
      return ;
    } else {
      user.setRolesFromLoginRequest2(responseApi.data);
      saveIdempiereUser(user);
      roles.clear();
      for (var item in user.roles!) {
        roles.add(item);
      }
      //Get.toNamed(Memory.ROUTE_IDEMPIERE_ROLES_PAGE,arguments:{Memory.KEY_USER:user});
    }
    update();
  }
  void getWarehouses(int? organizationId) async {
    if(organizationId==null){
      return;
    }
    warehouses.clear();
    idWarehouse.value ='';
    user.organizationId = organizationId ;
    isLoading.value = true;
    ResponseApi responseApi = await usersProvider.getWarehouses(user);
    isLoading.value = false;

    if(responseApi.success==null || !responseApi.success!){
      return ;
    } else {
      user.setWarehouseFromLoginRequest4(responseApi.data);
      saveIdempiereUser(user);
      warehouses.clear();
      for (var item in user.warehouses!) {
        warehouses.add(item);
      }

      //Get.toNamed(Memory.ROUTE_IDEMPIERE_WAREHOUSEES_PAGE,arguments:{Memory.KEY_USER:user});
    }

  }
  void getOrganizations(int? roleId) async {
    if(roleId==null){
      return;
    }

    warehouses.clear();
    organizations.clear();
    idOrganization.value ='';
    idWarehouse.value ='';
    user.roleId = roleId ;
    isLoading.value = true;
    organizations.clear();
    ResponseApi responseApi = await usersProvider.getOrganizations(user);
    isLoading.value = false;

    if(responseApi.success==null || !responseApi.success!){
      return ;
    } else {
      user.setOrganizationFromRequest3(responseApi.data);
      saveIdempiereUser(user);
      for(var item in user.organizations!){
        organizations.add(item);
      }
      //Get.toNamed(Memory.ROUTE_IDEMPIERE_ORGANIZATIONES_PAGE,arguments:{Memory.KEY_USER:user});
    }

  }
  void initSession(int warehouseId) async {

    user.warehouseId = warehouseId ;
    isLoading.value = true;
    ResponseApi responseApi = await usersProvider.initSession(user);
    isLoading.value = false;

    if(responseApi.success==null || !responseApi.success!){
      return ;
    }
    user = responseApi.data;
    saveIdempiereUser(user);
    print('------------------------------------');
    print('clientId: ${user.clientId}');
    print('roleId: ${user.roleId}');
    print('organizationId: ${user.organizationId}');
    print('warehouseId: ${user.warehouseId}');
    print('token: ${user.token}');
    print('tokenCreatedAt: ${user.tokenCreatedAt}');
    print('refreshToken: ${user.refreshToken}');
    print('refreshTokenCreatedAt: ${user.refreshTokenCreatedAt}');
    print('userId: ${user.userId}');
    print('language: ${user.language}');
    print('------------------------------------success');
    Get.toNamed(Memory.ROUTE_IDEMPIERE_HOME_PAGE,arguments:{Memory.KEY_IDEMPIERE_USER:user});

  }

  void oneStepLogin(int roleId) async {
    user.roleId = roleId ;

    isLoading.value = true;
    ResponseApi responseApi = await usersProvider.oneStepLogin(user);
    isLoading.value = false;

    if(responseApi.success==null || !responseApi.success!){
      return ;
    }
    user = responseApi.data;
    saveIdempiereUser(user);
    print('------------------------------------');
    print('token: ${user.token}');
    print('tokenCreatedAt: ${user.tokenCreatedAt}');
    print('refreshToken: ${user.refreshToken}');
    print('refreshTokenCreatedAt: ${user.refreshTokenCreatedAt}');
    print('userId: ${user.userId}');
    print('language: ${user.language}');
    print('------------------------------------');
    Get.toNamed(Memory.ROUTE_IDEMPIERE_HOME_PAGE,arguments:{Memory.KEY_IDEMPIERE_USER:user});

  }

}