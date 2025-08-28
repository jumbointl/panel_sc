


import '../../../../models/idempiere/idempiere_organization.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereOrganizationsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereOrganizationsListForUserController(){
    List<IdempiereOrganization> list = getSavedIdempiereOrganizationsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}