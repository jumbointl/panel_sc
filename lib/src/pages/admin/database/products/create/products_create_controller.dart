import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/pages/common/active_dropdown.dart';
import 'package:solexpress_panel_sc/src/pages/common/sql_buttons_controller.dart';

import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/category.dart';
import '../../../../../models/product.dart';
import '../../../../../providers/categories_provider.dart';
import '../../../../../providers/products_provider.dart';
import '../../../../../providers/societies_provider.dart';
import '../../../../../utils/image/tool/image_tool_page.dart';
import '../../../../common/controller_model.dart';


class ProductsCreateController extends ControllerModel implements SqlButtonsController{
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  TextEditingController barcodeController= TextEditingController();
  CategoriesProvider categoriesProvider =  CategoriesProvider();
  SocietiesProvider societiesProvider =  SocietiesProvider();
  ProductsProvider provider =  ProductsProvider();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  RxString idCategory = ''.obs;
  List<Category> categories =<Category>[].obs;
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;


  ProductsCreateController(){
    getCategories();

  }

  void getCategories() async {

    var result = await categoriesProvider.getAll(null) ;
      categories.clear();
      categories.add(Category(id:0,name: Messages.SELECT_A_CATEGORY));
      idCategory.value ='0';
    if(result!=null){
      categories.addAll(result);

    }

  }



  Future<void> createWithImage(BuildContext context) async {
    String description = descriptionController.text.trim();
    String  name = nameController.text.trim();
    int? category = int.tryParse(idCategory.value);
    int? active = int.tryParse(isActive.value);
    String barcode = barcodeController.text.trim();
    List<File> images =<File>[];
    if(name.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.NAME);
      return;
    }
    if(description==''){
      Get.snackbar(Messages.ERROR, Messages.DESCRIPTION);
      return;
    }
    if(category == null || category ==0){
      Get.snackbar(Messages.ERROR, Messages.CATEGORIES);
      return;
    }
    if(imageFile1 == null){
      Get.snackbar(Messages.ERROR, '${Messages.IMAGE}1');

      return;
    } else {
      images.add(imageFile1!);
    }

    if(imageFile2 != null){
      images.add(imageFile2!);
    }
    if(imageFile3 != null){
      images.add(imageFile3!);
    }

    if(active == null){
      Get.snackbar(Messages.ERROR, Messages.SOCIETY);
      return;
    }

    Product data = Product(
      name: name,
      description:  description,
      idCategory: category,
      active: active,
      image1: imageFile1?.path,
      extensionImage1: getExtension(imageFile1?.path),
      image2: imageFile2?.path,
      extensionImage2: getExtension(imageFile2?.path),
      image3: imageFile3?.path,
      extensionImage3: getExtension(imageFile3?.path),
      barcode: barcode,
    );
    ResponseApi responseApi = await provider.create(context, data,images);
    if (responseApi.success!=null && responseApi.success == true) {
      Product d = Product.fromJson(responseApi.data);
      idController.text = d.id.toString() ;
      update();

    }


  }
  void getImage(int index) async {
    switch(index){
      case 2:
        if(imageFile1==null){
          String m = Messages.IMAGE_EMPTY ;
          showErrorMessages('$m : 1');
          return;
        }
        break;

      case 3:
        if(imageFile1==null || imageFile2==null){
          showErrorMessages(Messages.IMAGE_EMPTY_1_OR_2);
          return;
        }
        break;
    }



    File? image = await Get.to(ImageToolPage(title: Messages.IMAGE_TOOL,));

    if(image!=null){
      switch(index){
        case 1:
          imageFile1= image;
          break;
        case 2:
          imageFile2= image;
          break;
        case 3:
          imageFile3= image;
          break;
      }
      update();
    }
  }
  void clearForm(){
    idController.text= '' ;
    nameController.text='';
    descriptionController.text='';
    isActive.value ='1';
    idCategory.value ='0';
    barcodeController.text ='';
  }
  void setDatas(Product data){
    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    descriptionController.text=data.description ?? '';
    barcodeController.text=data.barcode ?? '';
    //data.image1 ?? '';
    //data.image2 ?? '';
    //data.image3 ?? '';
    isActive.value = data.active.toString();
    idCategory.value =data.idCategory.toString();

  }

  @override
  void updateButtomPressed(BuildContext context){

  }
  @override
  void createButtomPressed(BuildContext context){
        createWithImage(context);
  }
  @override
  void deleteButtomPressed(BuildContext context){

  }
  @override
  void findButtomPressed(BuildContext context){

  }
  @override
  void clearButtomPressed(BuildContext context){
    clearForm();
  }
  @override
  SqlButtonsController getButtonBarController(BuildContext context){
        return this;
  }
  @override
  void setButtonBarController(SqlButtonsController controller){

  }





}