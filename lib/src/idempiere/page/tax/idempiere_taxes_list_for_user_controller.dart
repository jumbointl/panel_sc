

import '../../../models/idempiere/idempiere_object.dart';
import '../../../models/idempiere/idempiere_tax.dart';
import '../../common/idempiere_objects_list_controller_model.dart';

class IdempiereTaxesListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereTaxesListForUserController(){
    List<IdempiereTax> list = getSavedIdempiereTaxesList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}