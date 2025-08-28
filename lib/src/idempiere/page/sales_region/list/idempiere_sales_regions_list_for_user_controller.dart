


import '../../../../models/idempiere/idempiere_object.dart';
import '../../../../models/idempiere/idempiere_sales_region.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereSalesRegionsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereSalesRegionsListForUserController(){
    List<IdempiereSalesRegion> list = getSavedIdempiereSalesRegionsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}