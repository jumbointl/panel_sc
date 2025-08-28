import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import 'package:solexpress_panel_sc/src/providers/societies_provider.dart';

import '../../../data/memory.dart';
import '../../../models/society.dart';
import '../../../models/user.dart';
import '../../common/controller_model.dart';



class SocietiesListController extends ControllerModel {

  List<Society>? societies = [];
  SocietiesProvider societyProvider  = SocietiesProvider();
  //OrdersProvider ordersProvider = OrdersProvider();
  late User user;
  Society? society ;
  OrdersProvider ordersProvider = OrdersProvider();
  RxString societyName = ''.obs ;
  var radioValue = 0.obs;
  bool societyListCalled = false;



  var isDebitTransaction = true.obs;

  SocietiesListController() {
    //print('LA DIRECCION DE SESION ${GetStorage().read(Memory.SOCIETY)}');
    //User user =  Memory.getSavedUser();
    user = getSavedUser();

    //getSocieties();

  }
  @override
  void onInit() {

    // Here you can fetch you products from server

    isLoading.value = true ;
    super.onInit();

  }
  @override
  void onReady() {
    super.onReady();
    isLoading.value = false ;
  }

  Future<List<Society>> getSocieties() async {
    if(societyListCalled){
        isLoading.value = false;
        return societies ?? [];
    }

    societies = getSavedSocietiesList();
    if(!societyListCalled || societies==null){
      isLoading.value = true;
      List<Society>? societiesAux = await societyProvider.getAllActiveWithoutSeller();
      societyListCalled = true;
      isLoading.value = false;
      if(societiesAux!=null){
        societies = societiesAux;
        saveSocietiesList(societiesAux);
      } else {
        societies = [];
      }
    }

    saveSocietiesList(societies!);
    society = getSavedClientSociety();
    int lastId = Memory.DEFAULT_SOCIETY_NO_NAME_ID ;
    if(society!=null && society!.id !=null){
      lastId = society!.id!;
    }
    int index = societies!.indexWhere((ad) => ad.id == lastId);

    if (index != -1) { // LA DIRECCION DE SESION COINCIDE CON UN DATOS DE LA LISTA DE DIRECCIONES
      radioValue.value = index;
      society = societies![index];
      saveClientSociety(society!);
    } else {
      radioValue.value = 0;

    }
    Society s =  societies![radioValue.value];
    if(s.id!=null ){
      if(s.name!=null){
        societyName.value = s.name!;
      }
      saveClientSociety(s);
    }
    isLoading.value = false;
    return societies ?? [];
  }
  void goToSellerHomePage(){
    Get.toNamed(Memory.ROUTE_SELLER_HOME_PAGE);
  }
  void createOrder(BuildContext context) async {
    removeShoppingBag();
    removeSavedAddress();
    late Society society;
    if(radioValue.value<0){
      showErrorMessages(Messages.SOCIETY);
      return;
    } else {
      society = societies![radioValue.value];
      if(society.id==null){
        showErrorMessages(Messages.SOCIETY);
        return;
      }
      saveClientSociety(society);
    }
    Memory.clientProductsList = null;
    Memory.clientCategoriesList = null;
    removeSavedClientCategoriesList(society.id!);
    removeSavedClientProductsList(society.id!);
    Get.offNamedUntil(Memory.ROUTE_CLIENT_PRODUCTS_LIST_PAGE,(route)=>false,arguments: {
      Memory.KEY_IS_DEBIT_TRANSACTION :isDebitTransaction.value,
      Memory.KEY_CLIENT_SOCIETY:society});
  }


  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    society = societies![value];
    if(society!=null) {
      societyName.value = societies![value].name ?? '';
      saveClientSociety(societies![value]);
    }

    update();
  }

  void setIsDebitTransaction(bool newValue) {
    isDebitTransaction.value = newValue;
    update();
  }
  @override
  buttonReloadPressed() {
    // TODO: implement buttonReloadPressed
    societyListCalled = false;
    isLoading.value = true;
    getSocieties();
    isLoading.value = false;
  }
  @override
  buttonUpPressed() {
    Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE, (route)=>false);
  }
}