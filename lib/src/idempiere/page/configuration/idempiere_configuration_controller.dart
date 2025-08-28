import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/memory.dart';
import '../../../models/host.dart';
import '../../common/idempiere_controller_model.dart';
class IdempiereConfigurationController extends IdempiereControllerModel {
  TextEditingController urlController = TextEditingController();



  IdempiereConfigurationController(){
    Host host = getSavedUserHost();
    if(host.id!=null){
      urlController.text = host.url!;
    }

  }


  void goToBusinessPartnerHomePage() {
      Get.toNamed(Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNERS_HOME_PAGE);
  }

  void saveConfiguration() {
    Host host = Host();
    host.url = urlController.text;
    saveUserHost(host);
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false);

  }



}