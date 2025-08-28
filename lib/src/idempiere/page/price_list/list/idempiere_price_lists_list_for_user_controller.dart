


import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';
import '../../../../models/idempiere/idempiere_price_list.dart';

class IdempierePriceListsListForUserController extends IdempiereObjectsListControllerModel {



  IdempierePriceListsListForUserController(){
    List<IdempierePriceList> list = getSavedIdempierePriceListsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}