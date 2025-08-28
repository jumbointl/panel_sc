import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/providers/groups_provider.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/idempiere/idempiere_product.dart';
import '../../models/idempiere/idempiere_product_category.dart';
import 'idempiere_controller_model.dart';
import '../../models/idempiere/idempiere_user.dart';
import '../../models/product.dart';
import '../../pages/client/products/detail/client_products_detail_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


class IdempiereProductsListControllerModel extends IdempiereControllerModel {
  var indexTab = 0.obs;
  //RxString idCategory = ''.obs;
  List<IdempiereProductCategory> categories =<IdempiereProductCategory>[].obs;
  RxString idProduct = ''.obs;
  TextEditingController findByProductNameController= TextEditingController();
  bool showNavigateBottom = false;
  Product productSelected =  Product();
  List<IdempiereProduct> selectedProducts = [];
  List<IdempiereProduct> productsList = <IdempiereProduct>[];

  String selectedCategory ='';
  late IdempiereUser user ;
  GroupsProvider groupsProvider = GroupsProvider();
  int defaultCategoryIndex = 1;
  String tipForPrice = Messages.PRICE_NOT_INCLUDING_VAT;
  var items = 0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;
  int listTypeOfSocieties = 1;
  Rx<Color> shoppingBagColor = Colors.white.obs;
  bool listOfProductsExtracted = false;
  bool listOfCategoriesExtracted = false;
  var isDebitTransaction = true.obs;

  IdempiereProductsListControllerModel(){

       isLoading.value = false;

      user = getSavedIdempiereUser();

      selectedProducts = getSavedShoppingBag();
      if(selectedProducts.isNotEmpty){
        items.value = selectedProducts.length;
      }
  }


  Future<List<IdempiereProduct>> getProductsByCategory(int category) async{

    List<IdempiereProduct> list = [];
    for(int i=0; i<productsList.length;i++){
      if(productsList[i].mProductCategoryID?.id == category){

        list.add(productsList[i]);
      }
    }
    return list;
  }


  void goToOrderCreatePage(){


  }
  void goToProductDetailPage(IdempiereProduct product){

    saveCurrentProduct(product);
    Get.toNamed(Memory.ROUTE_CLIENT_PRODUCTS_DETAIL_PAGE,arguments:{});
  }

  void openBottomSheet(BuildContext context, Product product) async{

    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => ClientProductsDetailPage(product: product)
    );
  }
  @override
  buttonBackPressed() {
    // TODO: implement buttonBackPressed

  }

}