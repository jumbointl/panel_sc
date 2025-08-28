


import '../../../../models/idempiere/idempiere_locator.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereLocatorsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereLocatorsListForUserController(){
    List<IdempiereLocator> list = getSavedIdempiereLocatorsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}