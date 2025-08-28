


import '../../../../models/idempiere/idempiere_city.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereCitiesListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereCitiesListForUserController(){
    List<IdempiereCity> list = getSavedIdempiereCitiesList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}