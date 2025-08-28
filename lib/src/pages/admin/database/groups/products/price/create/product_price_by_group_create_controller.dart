import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/product.dart';
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


class ProductPriceByGroupCreateController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController priceController= TextEditingController();
  TextEditingController findByGroupNameController= TextEditingController();
  TextEditingController findByProductNameController= TextEditingController();
  //TextEditingController activeController= TextEditingController();
  //TextEditingController idProductController= TextEditingController();
  ProductsProvider productsProvider =  ProductsProvider();
  GroupsProvider groupsProvider =  GroupsProvider();
  //ProductPriceByGroupProvider provider =  ProductPriceByGroupProvider();
  CategoriesProvider categoriesProvider =  CategoriesProvider();
  RxString idCategory = ''.obs;

  //RxString idProduct = ''.obs;
  List<Category> categoriesList =<Category>[].obs ;

  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  RxString idProduct = ''.obs;
  List<Product> productsList =<Product>[].obs;
  //Product? productResult;
  //bool showNavigateBottom = false;
  //bool productsListIsEmpty = true;
  //bool categoriesListIsEmpty = true;


  RxString idGroup = ''.obs;
  List<Group> groupsList =<Group>[].obs ;
  ProductPriceByGroup? productWithPriceResult;

  ProductPriceByGroupCreateController(){

    sqlSearchResult = SqlSerchResult();
    getCategories();

    //
  }

  void getCategories() async {
    
    
    var result = await categoriesProvider.getAll(null);

    categoriesList.clear();
    categoriesList.add(Category(id:0,name: Messages.SELECT_A_CATEGORY));
    idCategory.value ='0';
    if(result!=null){
      categoriesList.addAll(result);

    }

  }
  void getGroups() async {
    var result = await groupsProvider.getAllActive(null);

    groupsList.clear();
    groupsList.add(Group(id:0,name: Messages.SELECT_A_GROUP));
    idGroup.value ='0';
    if(result!=null){
      groupsList.addAll(result);

    }

  }
  void _getGroupsByCondition(BuildContext context, SqlQueryCondition sql) async {

    var result = await groupsProvider.getGroupByCondition(context,sql);

    groupsList.clear();
    //groupsList.add(Group(id:0,name: Messeges.SELECT_A_GROUP));
    idGroup.value ='';
    if(result!=null){
      groupsList.addAll(result);
    }
    if(groupsList.isEmpty){
      groupsList.add(Group(id:0,name: Messages.NO_DATA_FOUND));
      idGroup.value ='0';
    } else if(groupsList.length==1)  {
      idGroup.value = groupsList[0].id.toString();
    }  else {
      String aux = '(${groupsList.length})${Messages.REGISTERS}';
      groupsList.insert(0,Group(id:0,name: aux));
    }

  }
  void _getProductsByCondition(BuildContext context, SqlQueryCondition condition) async {
    List<Product>? result = await productsProvider.getProductByCondition(context, condition);

    productsList.clear();

    if(result!=null){
      productsList.addAll(result);


    }

    if(productsList.isEmpty){

      productsList.add(Product(id:0,name: Messages.NO_DATA_FOUND));
      idProduct.value ='0';
    } else if(productsList.length==1)  {
      idProduct.value = productsList[0].id.toString();
    }  else {
      String aux = '(${productsList.length})${Messages.REGISTERS}';
      productsList.insert(0,Product(id:0,name: aux));
      idProduct.value ='0';
    }


  }


  void priceCreate(BuildContext context) async {

    int?  group = int.tryParse(idGroup.value);
    if(group==null || group==0){
      showErrorMessages('${Messages.GROUP} : $group');
      return;
    }
    int?  product = int.tryParse(idProduct.value);
    if(product==null || product==0){
      showErrorMessages('${Messages.PRODUCT} : $product');
      return;
    }
    double? price = double.tryParse(priceController.text);
    if(price==null ||price==0){
      showErrorMessages('${Messages.PRICE} : $price');
      return;
    }
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : null');
      return;
    }
    ProductPriceByGroup data = ProductPriceByGroup(
      idGroup: group,
      idProduct: product,
      active: active,
      price: price,

    );

    ResponseApi responseApi = await groupsProvider.priceCreate(context,data,);
    if(responseApi.success==null || !responseApi.success!){
      showErrorMessages(responseApi.message ?? Messages.EMPTY);
    } else {
      showSuccessMessages(Messages.NEW_DATA);
      setData(ProductPriceByGroup.fromJson(responseApi.data));
    }
  }
  /*
  void update(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messeges.ID} : $id');
      return;
    }


    String  name = findByGroupNameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messeges.NAME} : $name');
      return;
    }
    String  description = idProductController.text.trim();
    if(description.isEmpty){
      showErrorMessages('${Messeges.DESCRIPTION} : $description');
      return;
    }
    int? vatId = int.tryParse(idProduct.value);
    if(vatId==null ||vatId==0){
      showErrorMessages('${Messeges.VAT} : $vatId');
      return;
    }
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messeges.ACTIVE} : $active');
      return;
    }

    ProductPriceByGroup data = ProductPriceByGroup(
      idGroup: 1,
      idProduct: 1,
      active: 1,

    );

    ResponseApi responseApi = await provider.create(context,data,);
    print('Response api ${responseApi.data}');
    if(responseApi.success==null || !responseApi.success!){
      showErrorMessages(responseApi.message ?? Messeges.EMPTY);
    } else {
      showSuccessMessages(Messeges.UPDATE_DATAS);
    }
  }
  */
  @override
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }
  bool isValidForm(){



    if(imageFile==null){
      return false;
    }
    return true;
  }

  Future<void> findProductsBySqlCondition(BuildContext context) async {
    String  condition = findByProductNameController.text.trim();

    if(condition==''){
      showErrorMessages(Messages.CONDITION);
      return;
    }
    //find by name sql sentence
    String where ='where';
    String and ='';
    if(idCategory.value!='' && idCategory.value !='0'){
      where = ' $where id_category =${idCategory.value}';
      and='and';
    }

    if(condition=='%'){
      if(where=='where'){
        condition =' order by name';
      } else {
        condition ='$where order by name';
      }

    } else {
      condition ='$where $and name like "$condition" order by name';

    }

    print(condition);
    SqlQueryCondition sql= SqlQueryCondition(
      whereAndOrderby: condition,
    );
    _getProductsByCondition(context,sql);



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
    update();
  }
  /*
  void setDatas(Product? data){
    productResult = data ;
    if(data==null){
      return;
    }
    idProduct.value = data.id.toString();
    //idProductController.text=data.id.toString();
    update();
  }

   */

  void clearForm(){
    idController.text= '' ;
    findByGroupNameController.text='';
    idGroup.value='0';
    //activeController.text='';
    //idProductController.text='';
    idProduct.value ='';
    idCategory.value ='';
    update();
  }




}