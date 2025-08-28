


import '../../../../models/idempiere/idempiere_tenant_with_detail.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereTenantWithDetailsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereTenantWithDetailsListForUserController(){
    List<IdempiereTenantWithDetail> list = getSavedIdempiereTenantWithDetailsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}