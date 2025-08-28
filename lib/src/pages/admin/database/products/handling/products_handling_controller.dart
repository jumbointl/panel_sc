import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/product_sql.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';
import 'package:solexpress_panel_sc/src/pages/common/active_dropdown.dart';
import 'package:solexpress_panel_sc/src/pages/common/sql_buttons_controller.dart';

import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/category.dart';
import '../../../../../models/product.dart';
import '../../../../../models/sql_query_condition.dart';
import '../../../../../providers/categories_provider.dart';
import '../../../../../providers/products_provider.dart';
import '../../../../../providers/societies_provider.dart';
import '../../../../../utils/image/tool/image_tool_page.dart';
import '../../../../common/controller_model.dart';


class ProductsHandlingController extends ControllerModel implements SqlButtonsController{
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  TextEditingController barcodeController= TextEditingController();
  CategoriesProvider categoriesProvider =  CategoriesProvider();
  SocietiesProvider societiesProvider =  SocietiesProvider();
  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  RxString idCategory = ''.obs;
  List<Category> categories =<Category>[].obs;
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  RxString idProduct = ''.obs;
  TextEditingController findByProductNameController= TextEditingController();
  List<Product> productsList =<Product>[].obs;
  bool productsListIsEmpty = true;
  bool showNavigateBottom = false;
  ProductsProvider productsProvider =  ProductsProvider();
  Product productSelected =  Product();
  int defaultCategoryIndex = 1;
  ProductsHandlingController(){
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
  void _getProductsByCondition(BuildContext context, SqlQueryCondition condition) async {
    showNavigateBottom = false;
    productsListIsEmpty = true;
    List<Product>? result = await productsProvider.getProductByCondition(context, condition);

    productsList.clear();

    if(result!=null){
      productsListIsEmpty = false;
      productsList.addAll(result);


    }

    if(productsList.isEmpty){

      productsList.add(Product(id:0,name: Messages.NO_DATA_FOUND));
      idProduct.value ='0';
    } else if(productsList.length==1)  {
      idProduct.value = productsList[0].id.toString();
      setDatas(productsList[0]);
      showNavigateBottom = true ;
    }  else {
      String aux = '(${productsList.length})${Messages.REGISTERS}';
      showNavigateBottom = true;
      productsList.insert(0,Product(id:0,name: aux));
      idProduct.value ='0';
    }


  }


  Future<void> updateWithImage(BuildContext context, List<File> images, ProductSql data) async {
    String description = descriptionController.text.trim();
    String  name = nameController.text.trim();
    int? category = int.tryParse(idCategory.value);
    int? active = int.tryParse(isActive.value);
    String barcode = barcodeController.text.trim();

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

    if(active == null){
      Get.snackbar(Messages.ERROR, Messages.SOCIETY);
      return;
    }

    data.id = productSelected.id ;
    data.name= name;
    data.description=  description;
    data.idCategory= category;
    data.active= active;
    data.image1= productSelected.image1;
    data.extensionImage1= getExtension(imageFile1?.path);
    data.image2= productSelected.image2;
    data.extensionImage2= getExtension(imageFile2?.path);
    data.image3= productSelected.image3;
    data.extensionImage3= getExtension(imageFile3?.path);
    data.barcode= barcode;
    ResponseApi responseApi = await productsProvider.updateWithImage(context,data,images);
        if (responseApi.success!=null && responseApi.success == true) {
          //clearForm();
          Product data = Product.fromJson(responseApi.data);
          setDatas(data);
          update();

        }

  }
  Future<void> updateWithoutImage(BuildContext context) async {
    String description = descriptionController.text.trim();
    String  name = nameController.text.trim();
    int? category = int.tryParse(idCategory.value);
    int? active = int.tryParse(isActive.value);
    String barcode = barcodeController.text.trim();
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

    if(active == null){
      Get.snackbar(Messages.ERROR, Messages.SOCIETY);
      return;
    }

    Product data = Product(
      id: productSelected.id,
      name: name,
      description:  description,
      idCategory: category,
      active: active,
      image1: productSelected.image1,
      image2: productSelected.image2,
      image3: productSelected.image3,
      barcode: barcode,
    );
    ResponseApi responseApi = await productsProvider.updateWithoutImage(context,data);
    if (responseApi.success == true) {
      //clearForm();
      Product data= Product.fromJson(responseApi.data);
      setDatas(data);
      update();

    }

  }
  void getImage(int index) async {
    switch(index){
      case 2:
        if(imageFile1==null && productSelected.image1==null){
          String m = Messages.IMAGE_EMPTY ;
          showErrorMessages('$m : 1');
          return;
        }
        break;

      case 3:

        if(imageFile1==null && productSelected.image1==null){
          showErrorMessages(Messages.IMAGE_EMPTY_1_OR_2 );
          return;
        }
        if(imageFile2==null && productSelected.image2==null){
          String m = Messages.IMAGE_EMPTY ;
          showErrorMessages('$m : 2');
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
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    productSelected = Product();
    productsList.clear();
    productsListIsEmpty = true ;
  }
  void setDatas(Product data){
    productSelected = data;

    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    descriptionController.text=data.description ?? '';
    barcodeController.text=data.barcode ?? '';
    imageFile1 = null;
    imageFile2 = null;
    imageFile3 = null;
    //data.image1 ?? '';
    //data.image2 ?? '';
    //data.image3 ?? '';
    isActive.value = data.active.toString();
    idCategory.value =data.idCategory.toString();
    //replaceProductById(productsList, data);
    update();
  }

  @override
  void updateButtomPressed(BuildContext context){
    ProductSql product = ProductSql(positionImagesToDelete: [],
        imagesToDelete: [], extensionImagesToUpdate: []);

    List<File> images =<File>[];
    if(imageFile1 != null){
      images.add(imageFile1!);
      product.positionImagesToDelete!.add(1);
      String? s = getExtension(imageFile1!.path);
      product.extensionImagesToUpdate!.add(s);
      if(productSelected.image1!=null){
        product.imagesToDelete!.add(getFirebaseFileName(productSelected.image1!));
      }
    }
    if(imageFile2 != null){
      images.add(imageFile2!);
      product.positionImagesToDelete!.add(2);
      String? s = getExtension(imageFile2!.path);
      product.extensionImagesToUpdate!.add(s);
      if(productSelected.image2!=null){
        product.imagesToDelete!.add(getFirebaseFileName(productSelected.image2!));
      }
    }
    if(imageFile3 != null){
      images.add(imageFile3!);
      product.positionImagesToDelete!.add(3);
      String? s = getExtension(imageFile3!.path);
      product.extensionImagesToUpdate!.add(s);
      if(productSelected.image3!=null){
        product.imagesToDelete!.add(getFirebaseFileName(productSelected.image3!));
      }

    }
    if(images.isEmpty){
      updateWithoutImage(context);
    } else {
      updateWithImage(context, images,product);
    }

  }
  @override
  void createButtomPressed(BuildContext context){
  }
  @override
  void deleteButtomPressed(BuildContext context){

  }
  @override
  void findButtomPressed(BuildContext context){
    findProductsBySqlCondition(context);
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