import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/society.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../client/products/list/client_products_list_controller.dart';

class SellerOrdersCreateController extends ControllerModel {

  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  ClientProductsListController productsListController = Get.find();
  List<TextEditingController> quantityController = <TextEditingController>[];
  late Society clientSociety ;


  SellerOrdersCreateController() {
    clientSociety = getSavedClientSociety();
    if (GetStorage().read(Memory.KEY_SHOPPING_BAG) != null) {

      if (GetStorage().read(Memory.KEY_SHOPPING_BAG) is List<Product>) {
        var result = GetStorage().read(Memory.KEY_SHOPPING_BAG);
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      else {
        var result = Product.fromJsonList(GetStorage().read(Memory.KEY_SHOPPING_BAG));
        selectedProducts.clear();
        selectedProducts.addAll(result);
      }
      for (var product in selectedProducts) {
        TextEditingController t = TextEditingController();
        t.text = product.quantity.toString();
        quantityController.add(t);

      }
      Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = Memory.ROUTE_SELLER_HOME_PAGE;
      getTotal();

    }
  }

  void getTotal() {
    total.value = 0.0;
    for (var product in selectedProducts) {
      total.value = total.value + (product.quantity! * product.price!);
    }
  }

  void deleteItem(Product product,int i) {
    selectedProducts.remove(product);
    quantityController.removeAt(i);
    GetStorage().write(Memory.KEY_SHOPPING_BAG, selectedProducts);
    getTotal();

    productsListController.items.value = 0;
    if (selectedProducts.isEmpty) {
      productsListController.items.value = 0;
    }
    else {
      for (var p in selectedProducts) {
        productsListController.items.value = productsListController.items.value + p.quantity!;
      }
    }
  }

  void addItem(Product product, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    double? d = double.tryParse(quantityController[i].text);
    if(d==null || d<=0){
      showErrorMessages(Messages.QUANTITY);
      return;
    }

    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    if(product.quantity==d){
      product.quantity = product.quantity! + 1;
    } else {
      product.quantity = d;
    }
    quantityController[i].text = product.quantity.toString();
    selectedProducts.insert(index, product);
    GetStorage().write(Memory.KEY_SHOPPING_BAG, selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    for (var p in selectedProducts) {
      productsListController.items.value = productsListController.items.value + p.quantity!;
    }
  }
  void setItem(Product product, int i,String string) {
    if(string.isEmpty){
      return;
    }
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    double? d = double.tryParse(quantityController[i].text);
    if(d==null || d<=0){
      showErrorMessages(Messages.QUANTITY);
      return;
    }


    if(product.quantity==d){
      return ;
    } else {
      product.quantity = d;
    }
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    quantityController[i].text = product.quantity.toString();
    selectedProducts.insert(index, product);
    GetStorage().write(Memory.KEY_SHOPPING_BAG, selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    for (var p in selectedProducts) {
      productsListController.items.value = productsListController.items.value + p.quantity!;
    }
  }

  void removeItem(Product product, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    double? d = double.tryParse(quantityController[i].text);
    if(d==null || d<=0){
      showErrorMessages(Messages.QUANTITY);
      return;
    }
    if(product.quantity==d){

      if(d < 1){
        showErrorMessages(Messages.QUANTITY);
        return;
      }
      product.quantity = product.quantity! - 1;
    } else {
      product.quantity = d;
    }
    quantityController[i].text = product.quantity.toString();
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    selectedProducts.remove(product);
    selectedProducts.insert(index, product);
    GetStorage().write(Memory.KEY_SHOPPING_BAG, selectedProducts);
    getTotal();
    productsListController.items.value = 0;
    for (var p in selectedProducts) {
      productsListController.items.value = productsListController.items.value + p.quantity!;
    }

  }


  void goToAddressListPage() {
    Get.toNamed(Memory.ROUTE_ADDERESS_LIST_PAGE);
  }
}