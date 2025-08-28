import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/models/search_result_list.dart';
import 'package:solexpress_panel_sc/src/models/sql_query_condition.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/category.dart';
import '../../../../../models/vat.dart';
import '../../../../../providers/categories_provider.dart';
import '../../../../../providers/vats_provider.dart';
import '../../../../../utils/image/tool/image_tool_page.dart';
import '../../../../common/active_dropdown.dart';
import '../../../../common/controller_model.dart';


class CategoriesHandlingController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController findController= TextEditingController();
  TextEditingController activeController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  CategoriesProvider provider =  CategoriesProvider();
  VatsProvider vatsProvider =  VatsProvider();
  RxString idVat = ''.obs;
  List<Vat> vatsList =<Vat>[].obs ;
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  RxString idCategoryResult = ''.obs;
  List<Category> categoriesResult =<Category>[].obs;
  Category? categoryResult;
  bool showNavigateBottom = false;
  CategoriesHandlingController(){
    sqlSearchResult = SqlSerchResult();
    getVats();
  }
  void getVats() async {

    var result = await vatsProvider.getAll(null);

    vatsList.clear();
    vatsList.add(Vat(id:0,name: Messages.SELECT_A_VAT));
    idVat.value ='0';
    if(result!=null){
      vatsList.addAll(result);

    }

  }
  void _getCategoriesByCondition(BuildContext context, SqlQueryCondition condition) async {
    showNavigateBottom = false;
    List<Category>? result = await provider.getCategoryByCondition(context, condition);

    categoriesResult.clear();

    if(result!=null){
      categoriesResult.addAll(result);
      sqlSearchResult!.setList(categoriesResult);

    }
    if(categoriesResult.isEmpty){
      categoriesResult.add(Category(id:0,name: Messages.NO_DATA_FOUND));
      idCategoryResult.value ='0';
    } else if(categoriesResult.length==1)  {
      categoryResult = categoriesResult[0];
      idCategoryResult.value = categoryResult!.id.toString();
      showNavigateBottom = true ;
    }  else {
      String aux = '(${categoriesResult.length})${Messages.REGISTERS}';
      showNavigateBottom = true;
      categoriesResult.insert(0,Category(id:0,name: aux));
      idCategoryResult.value ='0';
    }


  }

  void _updateWithImage(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }


    String  name = nameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messages.NAME} : $name');
      return;
    }
    String  description = descriptionController.text.trim();
    if(description.isEmpty){
      showErrorMessages('${Messages.DESCRIPTION} : $description');
      return;
    }
    int? vatId = int.tryParse(idVat.value);
    if(vatId==null ||vatId==0){
      showErrorMessages('${Messages.VAT} : $vatId');
      return;
    }
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }

    String? toDelete ;
    if(categoryResult!.image!=null){
      toDelete = getFirebaseFileName(categoryResult!.image!);
      //print('image to delete $toDelete');
    }

    Category data = Category(
      id: obId,
      name: name,
      description: description,
      idVat: vatId,
      active: active,
      imageToDelete: toDelete,
    );
    ResponseApi responseApi = await provider.updateWithImage(context,data, imageFile!);

    if(responseApi.success!=null && responseApi.success!){
      Category c = Category.fromJson(responseApi.data);
      idController.text = c.id.toString() ;
      update();
    }

  }
  void updateData(BuildContext context) async {
    if(categoryResult==null|| categoryResult!.id ==null){
      showErrorMessages('${Messages.CATEGORY} null');
      return;
    }
    imageFile==null ? _updateWithoutImage(context)
        : _updateWithImage(context);
  }
  void _updateWithoutImage(BuildContext context) async {

    String  id = idController.text.trim();
    int ? obId = int.tryParse(id);
    if(obId==null ||obId==0){
      showErrorMessages('${Messages.ID} : $id');
      return;
    }


    String  name = nameController.text.trim();
    if(name.isEmpty){
      showErrorMessages('${Messages.NAME} : $name');
      return;
    }
    String  description = descriptionController.text.trim();
    if(description.isEmpty){
      showErrorMessages('${Messages.DESCRIPTION} : $description');
      return;
    }
    int? vatId = int.tryParse(idVat.value);
    if(vatId==null ||vatId==0){
      showErrorMessages('${Messages.VAT} : $vatId');
      return;
    }
    int? active = int.tryParse(isActive.value);
    if(active==null){
      showErrorMessages('${Messages.ACTIVE} : $active');
      return;
    }

    Category data = Category(
      id: obId,
      name: name,
      description: description,
      idVat: vatId,
      active: active,
      image: categoryResult!.image,

    );

    ResponseApi responseApi = await provider.updateWithoutImage(context,data,);
    print('Response api ${responseApi.data}');
    if(responseApi.success==null || !responseApi.success!){
      showErrorMessages(responseApi.message ?? Messages.EMPTY);
    } else {
      showSuccessMessages(Messages.UPDATE_DATAS);
    }
  }

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

  Future<void> findCategoriesBySqlCondition(BuildContext context) async {
    String  condition = findController.text.trim();

    if(condition.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.CONDITION);
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
    _getCategoriesByCondition(context,sql);



  }

  void getImage() async {
    imageFile = await Get.to(ImageToolPage(title: Messages.IMAGE_TOOL,));
    if(imageFile!=null){
      print(imageFile!.path);
      update();
    }  else {
      print('Imagefile = null');
    }
  }
  void setDatas(Category? data){
    categoryResult = data ;

    if(data==null){
      return;
    }
    print(categoryResult!.toJson());
    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    //findController.text=data.name ?? Messeges.NO_DATA_FOUND;
    idVat.value = data.idVat.toString();
    activeController.text=data.active.toString();
    descriptionController.text=data.description ?? '';
    update();
  }

  void clearForm(){
    idController.text= '' ;
    nameController.text='';
    findController.text='';
    idVat.value='0';
    activeController.text='';
    descriptionController.text='';
    categoriesResult.clear();
    idCategoryResult.value ='';
    categoryResult = null;
    imageFile = null;
    showNavigateBottom = false;
    update();
  }




}