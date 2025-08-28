


import '../../../../../models/idempiere/idempiere_business_partner_location.dart';
import '../../../../../models/idempiere/idempiere_object.dart';
import '../../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereBusinessPartnerLocationsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereBusinessPartnerLocationsListForUserController(){
    List<IdempiereBusinessPartnerLocation> list = getSavedIdempiereBusinessPartnerLocationsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}