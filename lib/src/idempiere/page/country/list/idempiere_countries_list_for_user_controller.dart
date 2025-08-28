


import '../../../../models/idempiere/idempiere_country.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereCountriesListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereCountriesListForUserController(){
    List<IdempiereCountry> list = getSavedIdempiereCountriesList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}