


import '../../../../models/idempiere/idempiere_user_with_detail.dart';
import '../../../../models/idempiere/idempiere_object.dart';
import '../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereUserWithDetailsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereUserWithDetailsListForUserController(){
    List<IdempiereUserWithDetail> list = getSavedIdempiereUserWithDetailsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}