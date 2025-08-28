import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import 'package:solexpress_panel_sc/src/providers/societies_provider.dart';

import '../../../data/memory.dart';
import '../../../models/society.dart';
import '../../../models/user.dart';
import '../../common/controller_model.dart';



class AccountingHomeController extends ControllerModel {

  List<Society>? societies = [];
  SocietiesProvider societyProvider  = SocietiesProvider();
  late User user;
  Society? society ;
  OrdersProvider ordersProvider = OrdersProvider();
  RxString societyName = ''.obs ;
  var radioValue = 0.obs;

  AccountingHomeController() {
    user = getSavedUser();

  }
  @override
  void onInit() {
    // Here you can fetch you products from server
    super.onInit();

  }


  Future<List<Society>> getSocieties() async {
    if(dataLoaded){
      isLoading.value = false;
      return societies ?? [];
    }
    societies = getSavedSocietiesList();
    if(societies==null || societies!.isEmpty){
      isLoading.value = true ;
      societies = await societyProvider.getAllActiveWithoutSeller();
      isLoading.value = false ;
    }
    if(societies==null || societies!.isEmpty){
      showErrorMessages(Messages.SOCIETY);
      return [];
    }
    saveSocietiesList(societies!);
    dataLoaded = true;
    society = getSavedClientSociety();
    int lastId = Memory.DEFAULT_SOCIETY_NO_NAME_ID ;
    if(society!=null && society!.id !=null){
      lastId = society!.id!;
    }


    int index = societies!.indexWhere((ad) => ad.id == lastId);

    if (index != -1) { // LA DIRECCION DE SESION COINCIDE CON UN DATOS DE LA LISTA DE DIRECCIONES
      radioValue.value = index;
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

    return societies ?? [];
  }
  void goToSellerHomePage(){
    Get.toNamed(Memory.ROUTE_SELLER_HOME_PAGE);
  }
  void goToClientOrderList(BuildContext context) async {

    society = getSavedClientSociety();
    if(society?.id==null){
      showErrorMessages(Messages.SOCIETY);
      return;
    }

    Get.toNamed(Memory.ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_DELIVERED_PAGE);


  }
  @override
  buttonReloadPressed() {
    // TODO: implement buttonReturnPressed
    dataLoaded = false;
    getSocieties();
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



}