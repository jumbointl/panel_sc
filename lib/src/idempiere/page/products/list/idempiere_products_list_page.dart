import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_products_list_page_model.dart';
import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/idempiere/idempiere_product.dart';
import '../../../../models/idempiere/idempiere_product_category.dart';
import 'idempiere_products_list_for_user_controller.dart';
class IdempiereProductsListPage extends IdempiereProductsListPageModel{

  IdempiereProductsListForUserController controller = Get.put(IdempiereProductsListForUserController());
  IdempiereProductsListPage({super.key});



  @override
  Future<List<IdempiereProduct>> getProducts(BuildContext context, IdempiereProductCategory category) async {
    List<IdempiereProduct> list = [];
    for(int i=0; i<controller.productsList.length;i++){
      if(category.id == Memory.ALL_CATEGORIES_ID){
        list.add(controller.productsList[i]);
      } else if(controller.productsList[i].mProductCategoryID?.id == category.id!){
        list.add(controller.productsList[i]);
      }
    }
    return list;
  }
  @override
  RxBool getIsLoadingObs() {
    return controller.isLoading;
  }
  @override
  double getMarginsForMaximumColumns(BuildContext context) {
    return controller.getMarginsForMaximumColumns(context);
  }
  @override
  double getMaximumInputFieldWidth(BuildContext context) {
    return controller.getMaximumInputFieldWidth(context);
  }
  @override
  List<IdempiereProductCategory> getCategories() {
    return controller.categories;
  }
  @override
  String getTitle() { return Messages.PRODUCTS;}
  @override
  Widget getBottomActionButton() {
    return Container();
  }

  @override
  List<Widget> getActionButton() {
    return <Widget>[controller.buttonBack(),controller.popUpMenuButton()];
  }
  @override
  void goToIdempiereProductDetailPage(IdempiereProduct idempiereProduct) {

  }
  @override
  void buttonShoppingBagPressed() {

  }

  @override
  int getItemsValue() {
    return controller.items.value;
  }

}
