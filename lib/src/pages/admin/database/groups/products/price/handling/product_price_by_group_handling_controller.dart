import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/models/search_result_list.dart';
import 'package:solexpress_panel_sc/src/models/sql_query_condition.dart';
import 'package:solexpress_panel_sc/src/providers/products_provider.dart';

import '../../../../../../../data/memory.dart';
import '../../../../../../../data/messages.dart';
import '../../../../../../../models/active.dart';
import '../../../../../../../models/category.dart';
import '../../../../../../../models/group.dart';
import '../../../../../../../models/product_price_by_group.dart';
import '../../../../../../../providers/categories_provider.dart';
import '../../../../../../../providers/groups_provider.dart';
import '../../../../../../common/active_dropdown.dart';
import '../../../../../../common/controller_model.dart';


class ProductPriceByGroupHandlingController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController findByGroupNameController= TextEditingController();
  TextEditingController findByProductNameController= TextEditingController();
  ProductsProvider productsProvider =  ProductsProvider();
  GroupsProvider groupsProvider =  GroupsProvider();
  CategoriesProvider categoriesProvider =  CategoriesProvider();
  RxString idCategory = ''.obs;
  RxString idGroup = ''.obs;
  List<Category> categoriesList =<Category>[].obs ;
  List<Group> groupsList =<Group>[].obs ;
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  RxString idProductPrice = ''.obs;
  List<ProductPriceByGroup> productsList =<ProductPriceByGroup>[].obs;
  bool showNavigateBottom = false;
  bool productsListIsEmpty = true;
  bool categoriesListIsEmpty = true;
  bool groupsListIsEmpty = true;

  ProductPriceByGroup? productWithPriceResult;

  ProductPriceByGroupHandlingController(){
    sqlSearchResult = SqlSerchResult();
    getCategories();
    //getGroups();
  }
  void getCategories() async {
    categoriesListIsEmpty =true;
    var result = await categoriesProvider.getAll(null);

    categoriesList.clear();
    categoriesList.add(Category(id:0,name: Messages.SELECT_A_CATEGORY));
    idCategory.value ='0';
    if(result!=null){
      categoriesListIsEmpty =false;
      categoriesList.addAll(result);

    }

  }

  void _getGroupsByCondition(BuildContext context, SqlQueryCondition sql) async {

    var result = await groupsProvider.getGroupByCondition(context,sql);

    groupsList.clear();
    //groupsList.add(Group(id:0,name: Messeges.SELECT_A_GROUP));
    idGroup.value ='';
    if(result!=null){
      groupsListIsEmpty = false;
      groupsList.addAll(result);
    }
    if(groupsList.isEmpty){
      groupsListIsEmpty =true;
      groupsList.add(Group(id:0,name: Messages.NO_DATA_FOUND));
      idGroup.value ='0';
    } else if(groupsList.length==1)  {
      idGroup.value = groupsList[0].id.toString();
      groupsListIsEmpty = false;
    }  else {
      String aux = '(${groupsList.length})${Messages.REGISTERS}';
      showNavigateBottom = true;
      groupsList.insert(0,Group(id:0,name: aux));
      groupsListIsEmpty = false;
    }

  }
  void _getProductsWithPriceByCondition(BuildContext context, SqlQueryCondition condition) async {

    showNavigateBottom = false;
    productsListIsEmpty = true;
    List<ProductPriceByGroup>? result = await groupsProvider.getProductsWithPriceByCondition(context, condition);
    productsList.clear();
    if(result!=null){
      productsListIsEmpty = false;
      productsList.addAll(result);
    }
    if(productsList.isEmpty){
      productsList.add(ProductPriceByGroup(id:0,name: Messages.NO_DATA_FOUND));
      idProductPrice.value ='0';
    } else if(productsList.length==1)  {
      idProductPrice.value = productsList[0].id.toString();
      showNavigateBottom = true ;
    }  else {
      String aux = '(${productsList.length})${Messages.REGISTERS}';
      showNavigateBottom = true;
      productsList.insert(0,ProductPriceByGroup(id:0,name: aux));
      idProductPrice.value ='0';
    }
  }


  void priceUpdate(BuildContext context) async {

    int?  group = int.tryParse(idGroup.value);
    if(group==null || group==0){
      showErrorMessages('${Messages.GROUP} : $group');
      return;
    }
    int?  id = int.tryParse(idController.text);
    if(id==null || id==0){
      showErrorMessages('${Messages.PRODUCT} : $id');
      return;
    } else {
      if(productWithPriceResult == null || productWithPriceResult?.id == null
          || productWithPriceResult!.id !=id){
        showErrorMessages('${Messages.ID} : $id');
        return;
      }
    }
    double? price = double.tryParse(priceController.text);
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : null');
      return;
    }
    ProductPriceByGroup data = ProductPriceByGroup(
      id: productWithPriceResult!.id,
      idGroup: productWithPriceResult!.idGroup,
      idProduct: productWithPriceResult!.idProduct,
      name: productWithPriceResult!.name,
      active: active,
      price: price,

    );

    ResponseApi responseApi = await groupsProvider.priceUpdate(context,data,);
    print('Response api ${responseApi.data}');
    if(responseApi.success==null || !responseApi.success!){
      showErrorMessages(responseApi.message ?? Messages.EMPTY);
    } else {
      showSuccessMessages(Messages.DATA_UPDATE);
      setData(ProductPriceByGroup.fromJson(responseApi.data));
    }
  }

  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }

  Future<void> findProductswithPriceBySqlCondition(BuildContext context) async {

    int?  group = int.tryParse(idGroup.value);
    if(group==null || group==0){
      showErrorMessages('${Messages.GROUP} : $group');
      return;
    }


    String  condition = findByProductNameController.text.trim();

    if(condition==''){
      showErrorMessages(Messages.CONDITION);
      return;
    }
    //find by name sql sentence
    String where ='where id_group=${idGroup.value}';
    if(idCategory.value!='' && idCategory.value !='0'){
      where = ' $where and id_category =${idCategory.value}';
    }
    if(condition=='%'){
      condition ='$where order by name';
    } else {
      condition ='$where and name like "$condition" order by name';
    }
    print(condition);
    SqlQueryCondition sql= SqlQueryCondition(
      whereAndOrderby: condition,
    );
    _getProductsWithPriceByCondition(context,sql);

  }
  Future<void> findGroupsBySqlCondition(BuildContext context) async {
    String  condition = findByGroupNameController.text.trim();

    if(condition==''){
      showErrorMessages(Messages.CONDITION);
      return;
    }
    //find by name sql sentence

    if(condition=='%'){
      condition =' order by name';
    } else {
      condition ='where name like "$condition" order by name';

    }

    print(condition);
    SqlQueryCondition sql= SqlQueryCondition(
      whereAndOrderby: condition,
    );
    _getGroupsByCondition(context,sql);



  }
  void setData(ProductPriceByGroup? data) {
    productWithPriceResult = data;
    if (data == null) {
      return;
    }
    idController.text = data.id.toString();
    idGroup.value = data.idGroup.toString();
    isActive.value = data.active.toString();
    priceController.text = data.price.toString();
    update();
  }

  void clearForm(){
    productWithPriceResult = ProductPriceByGroup();
    idController.text= '' ;
    findByGroupNameController.text='';
    idGroup.value='0';
    priceController.text='';
    isActive.value ='1';
    idProductPrice.value ='';
    idCategory.value ='';
    showNavigateBottom = false;
    update();
  }

  void idProductChanged() {
    int? id = int.tryParse(idProductPrice.value.toString());
    if(id==null || id==0){
      return;
    }
    ProductPriceByGroup? data = getProductWithPriceById(productsList, id);
    if(data ==null){
      return;
    }
    setData(data);

  }




}