


import '../../../../models/idempiere/idempiere_currency.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereCurrenciesListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereCurrenciesListForUserController(){
    List<IdempiereCurrency> list = getSavedIdempiereCurrenciesList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}