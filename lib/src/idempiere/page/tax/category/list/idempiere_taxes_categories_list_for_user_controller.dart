

import '../../../../../models/idempiere/idempiere_object.dart';
import '../../../../../models/idempiere/idempiere_tax_category.dart';
import '../../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereTaxesCategoriesListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereTaxesCategoriesListForUserController(){
    List<IdempiereTaxCategory> list = getSavedIdempiereTaxesCategoriesList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}