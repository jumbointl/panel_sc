import '../../../models/idempiere/idempiere_user.dart';
import 'idempiere_home_controller_model.dart';
class IdempiereHomeController1 extends IdempiereHomeControllerModel {

  late IdempiereUser user ;

  IdempiereHomeController1(){
    user = getSavedIdempiereUser();
  }











}