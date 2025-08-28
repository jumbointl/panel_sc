

import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_price_list_version.dart';

import '../../../../../models/idempiere/idempiere_object.dart';
import '../../../../common/idempiere_objects_list_controller_model.dart';

class IdempierePriceListVersionsListForUserController extends IdempiereObjectsListControllerModel {



  IdempierePriceListVersionsListForUserController(){
    List<IdempierePriceListVersion> list = getSavedIdempierePriceListVersionList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}