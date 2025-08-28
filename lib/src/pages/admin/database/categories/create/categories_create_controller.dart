import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/response_api.dart';

import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/category.dart';
import '../../../../../models/vat.dart';
import '../../../../../providers/categories_provider.dart';
import '../../../../../providers/vats_provider.dart';
import '../../../../../utils/image/tool/image_tool_page.dart';
import '../../../../common/active_dropdown.dart';
import '../../../../common/controller_model.dart';


class CategoriesCreateController extends ControllerModel {
  TextEditingController idController= TextEditingController();
  TextEditingController nameController= TextEditingController();
  TextEditingController activeController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  CategoriesProvider provider =  CategoriesProvider();
  VatsProvider vatsProvider =  VatsProvider();
  RxString idVat = ''.obs;
  List<Vat> vatsList =<Vat>[].obs ;
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;
  String? httpImageFile ;
  CategoriesCreateController(){
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
  void getImage() async {
    File? image = await Get.to(ImageToolPage(title: Messages.IMAGE_TOOL,));
    if(image!=null){
      imageFile= image;
      update();
    }
  }

  Future<void> createWithImage(BuildContext context) async {
    String  name = nameController.text.trim();
    String  description = descriptionController.text.trim();
    if(name.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.NAME);
      return;
    }
    if(description.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.DESCRIPTION);
      return;
    }
    if(imageFile==null){
      Get.snackbar(Messages.ERROR, Messages.IMAGE);
      return;
    }
    int? vatId = int.tryParse(idVat.value.toString());

    if(vatId == null || vatId==0){
      Get.snackbar(Messages.ERROR, Messages.VAT);
      return;
    }
    int? active = int.tryParse(isActive.value.toString());

    if(active == null ){
      Get.snackbar(Messages.ERROR, Messages.ACTIVE);
      return;
    }


    Category data = Category(
      name: name,
      image: imageFile!.path,
      description: description,
      active: active,
      idVat: vatId,
      extensionImage: getExtension(imageFile!.path),
    );
    ResponseApi responseApi = await provider.createWithImage(context, data, imageFile!);
    if(responseApi.success!=null && responseApi.success!){
      Category c = Category.fromJson(responseApi.data);
      idController.text = c.id.toString() ;
      update();

    }
  }

  void clearForm() {
    idController.text= '' ;
    nameController.text='';
    idVat.value='0';
    activeController.text='';
    descriptionController.text='';
    httpImageFile ='';

  }

  void setDatas(Category data){
    idController.text= data.id.toString() ;
    nameController.text=data.name ?? '';
    idVat.value = data.idVat.toString();
    activeController.text=data.active.toString();
    descriptionController.text=data.description ?? '';
    httpImageFile =data.image?? '';
    update();
  }





}