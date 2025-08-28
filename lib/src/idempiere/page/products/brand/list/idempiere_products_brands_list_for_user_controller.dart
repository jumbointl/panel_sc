

import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_product_brand.dart';

import '../../../../../models/idempiere/idempiere_object.dart';
import '../../../../common/idempiere_objects_list_controller_model.dart';

class IdempiereProductsBrandsListForUserController extends IdempiereObjectsListControllerModel {



  IdempiereProductsBrandsListForUserController(){
    List<IdempiereProductBrand> list = getSavedIdempiereProductsBrandsList();
    if(list.isNotEmpty){
     for(int i=0; i<list.length;i++){
       var item = list[i];
       objectsList.add(item as IdempiereObject);


     }
    }

  }

}