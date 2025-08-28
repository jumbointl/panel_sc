import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/groups_provider.dart';
import '../data/memory.dart';
import '../data/messages.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/society.dart';
import '../models/user.dart';
import '../pages/client/products/detail/client_products_detail_page.dart';
import '../providers/categories_provider.dart';
import '../providers/products_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../providers/societies_provider.dart';

class ProductsListController extends ControllerModel {
  var indexTab = 0.obs;
  CategoriesProvider categoriesProvider =  CategoriesProvider();
  RxString idCategory = ''.obs;
  List<Category> categories =<Category>[].obs;
  RxString idProduct = ''.obs;
  Society? clientSociety;
  SocietiesProvider societiesProvider = SocietiesProvider();
  TextEditingController findByProductNameController= TextEditingController();
  bool showNavigateBottom = false;
  ProductsProvider productsProvider =  ProductsProvider();
  Product productSelected =  Product();
  List<Product> selectedProducts = [];
  List<Product> productsList = <Product>[];

  String selectedCategory ='';
  late User user ;
  GroupsProvider groupsProvider = GroupsProvider();
  int defaultCategoryIndex = 1;
  String tipForPrice = Messages.PRICE_NOT_INCLUDING_VAT;
  var items = 0.0.obs;

  var productName = ''.obs;
  Timer? searchOnStoppedTyping;
  int listTypeOfSocieties = 1;
  Rx<Color> shoppingBagColor = Colors.white.obs;
  bool listOfProductsExtracted = false;
  bool listOfCategoriesExtracted = false;
  var isDebitTransaction = true.obs;

  ProductsListController({

    this.listTypeOfSocieties = 1,
} ){

       isLoading.value = true;
       var b = Get.arguments[Memory.KEY_IS_DEBIT_TRANSACTION] ?? true;
       if(b is bool){
         isDebitTransaction.value = b;
       }
       Society s = Get.arguments[Memory.KEY_CLIENT_SOCIETY] ??= {};
       if(s.name !=null ){
         clientSociety = s;
         saveClientSociety(s);
       }


      user = getSavedUser();
      if(clientSociety==null || clientSociety!.id ==null){

        showErrorMessages(Messages.SOCIETY);
        return;
      }

      if(clientSociety!.priceIncludingVat==1){
        tipForPrice = Messages.PRICE_INCLUDING_VAT ;
      } else {
        tipForPrice = Messages.PRICE_NOT_INCLUDING_VAT ;
      }
      selectedProducts = getSavedShoppingBag();
      if(selectedProducts.isNotEmpty){
        items.value = selectedProducts.length.toDouble();
      }
      _getData();

  }


  Future<void> _getData() async {
    categories.clear();
    if(clientSociety==null || clientSociety!.id==null || clientSociety!.idGroup==null){
      return ;
    }
    if(listOfCategoriesExtracted){
      return ;
    }
    //List<Category>? list = await getSavedClientCategoriesList(clientSociety!.id!);
    /*
    List<Category>? list = Memory.clientCategoriesList;
    if(list!=null){
      print('--------------------------saved Categories------------------------${clientSociety!.id!}');
      categories.addAll(list);
      defaultCategoryIndex = getPositionById(categories, Memory.DEFAULT_CATEGORY_ID);
      listOfCategoriesExtracted = true;
      return categories;
    }

     */


    listOfCategoriesExtracted = true;
    categories= await groupsProvider.getGroupsCategoriesAllActive(null, clientSociety!.idGroup!) ;
    defaultCategoryIndex =1;
    idCategory.value ='0';

    if(categories.isNotEmpty){
      int i = getPositionById(categories, Memory.DEFAULT_CATEGORY_ID);
      if(i>0){
        Category c = categories[i];
        categories.removeAt(i);
        categories.insert(0,c);
      }
    }


    //saveClientCategoriesList(categories,clientSociety!.id!);


    update();
    productsList = await getProductsWithPriceByCategoryAndGroup(null);



  }
  Future<List<Product>> getProductsByCategory(int category) async{

    List<Product> list = [];
    for(int i=0; i<productsList.length;i++){
      if(productsList[i].idCategory == category){

        list.add(productsList[i]);
      }
    }
    return list;
  }

  Future<List<Product>> getProductsWithPriceByCategoryAndGroup(String? findByName) async {



    if(clientSociety!.idGroup == null){
      showErrorMessages(Messages.GROUP);
      isLoading.value = false;
      return productsList;
    }

    if(findByName==null || findByName==''){
      findByName ='0';
      /*
      if(listOfProductsExtracted){
        isLoading.value = false;
        return productsList;
      }

       */
    }


    // pass all categories en String ()
    String allCategories = '(';
    for(int i=0; i<categories.length;i++){
      if(i<categories.length-1){
        allCategories = '$allCategories${categories[i].id},';
      } else {
        allCategories = '$allCategories${categories[i].id})';
      }

    }

    String  params = '/$allCategories/${clientSociety!.idGroup}/$findByName';
    showNavigateBottom = false;
    listOfProductsExtracted = true;
    List<Product>? list = await productsProvider.getProductsWithPriceByCategoryAndGroup(null,params);
    productsList.clear();
    if(list!=null && list.isNotEmpty){
      productsList.addAll(list);
    }
    isLoading.value = false;
    return productsList;
  }
  void goToOrderCreatePage(){
    if(clientSociety==null || clientSociety!.id==null){
      showErrorMessages(Messages.SOCIETY);
      return;
    }
    arguments: { }
    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_CREATE_PAGE,arguments: {
      Memory.KEY_CLIENT_SOCIETY:clientSociety!.toJson(),
      Memory.KEY_IS_DEBIT_TRANSACTION :isDebitTransaction.value});
  }
  void goToProductDetailPage(Product product){
    if(clientSociety==null || clientSociety!.id==null){
      showErrorMessages(Messages.SOCIETY);
      return;
    }
    saveCurrentProduct(product);
    Get.toNamed(Memory.ROUTE_CLIENT_PRODUCTS_DETAIL_PAGE,arguments:{
      Memory.KEY_CLIENT_SOCIETY,clientSociety!.toJson(),
      Memory.KEY_CURRENT_PROCUCT,product.toJson()} );
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
    Get.offNamedUntil(Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE, (route)=>false);
  }
  @override
  void buttonPdfPressed() {
    // TODO: implement buttonPdfPressed
    listOfCategoriesExtracted = false;
    listOfProductsExtracted = false;
    removeSavedClientCategoriesList(clientSociety!.id!);
    removeSavedClientProductsList(clientSociety!.id!);
    _getData();

  }






}