

import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_products_list_controller_model.dart';

import '../../../../data/memory.dart';

class IdempiereProductsListForUserController extends IdempiereProductsListControllerModel {



  IdempiereProductsListForUserController(){
    productsList = Get.arguments[Memory.KEY_CLIENT_PRODUCTS_LIST] ?? [];
    categories.clear();
    //IdempiereProductCategory category = IdempiereProductCategory(id: Memory.ALL_CATEGORIES_ID, name: Messages.ALL_CATEGORIES);
    //categories.add(category);
    extractCategoriesFromProductsList(productsList,categories);

  }

}