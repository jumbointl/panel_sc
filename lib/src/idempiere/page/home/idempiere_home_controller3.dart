import '../../../models/idempiere/idempiere_user.dart';
import 'idempiere_home_controller_model.dart';
class IdempiereHomeController3 extends IdempiereHomeControllerModel {

  late IdempiereUser user ;

  IdempiereHomeController3(){
    user = getSavedIdempiereUser();
  }









}