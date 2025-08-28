import '../../../models/idempiere/idempiere_user.dart';
import 'idempiere_home_controller_model.dart';
class IdempiereHomeController2 extends IdempiereHomeControllerModel {

  late IdempiereUser user ;

  IdempiereHomeController2(){
    user = getSavedIdempiereUser();
  }





}