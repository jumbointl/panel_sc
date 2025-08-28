import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/product.dart';
import '../list/client_products_list_controller.dart';

class ClientProductsDetailController extends ControllerModel {

  List<Product> selectedProducts = [];
  ClientProductsListController productsListController = Get.find();
  String tipForPrice = Messages.PRICE_NOT_INCLUDING_VAT;


  final String shoppingCart =Memory.KEY_SHOPPING_BAG;
  
  bool checkIfProductsWasAdded(Product product, var price, var counter, TextEditingController quantity, RxBool paintButtonWithColorWhite) {
    price.value = product.price ?? 0.0;

    if (GetStorage().read(Memory.KEY_SHOPPING_BAG) != null) {

      if (GetStorage().read(Memory.KEY_SHOPPING_BAG) is List<Product>) {
        selectedProducts = GetStorage().read(Memory.KEY_SHOPPING_BAG);
      }
      else {
        selectedProducts = Product.fromJsonList(GetStorage().read(Memory.KEY_SHOPPING_BAG));
      }
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      // paintButtonWithColorWhite.value = true;
      if (index != -1 ) { // EL PRDOCUTO YA FUE AGREGADO
        counter.value = selectedProducts[index].quantity!;
        quantity.text  = selectedProducts[index].quantity!.toString();
        price.value = product.price! * counter.value;

        return true;
      }
      

    }
    return false;
  }

  void addToBag(Product product, var price, var counter, RxBool paintButtonWithColorWhite) {

    if (counter.value > 0) {
      // VALIDAR SI EL PRODUCTO YA FUE AGREGADO CON GETSTORAGE A LA SESION DEL DISPOSITIVO
      int index = selectedProducts.indexWhere((p) => p.id == product.id);
      bool added = false ;
      if (index == -1 ) { // NO HA SIDO AGREGADO
        if (product.quantity == null) {
          if (counter.value > 0) {
            product.quantity = counter.value;
          }
          else {
            product.quantity = 1;
          }
        }

        selectedProducts.add(product);

      }
      else { // YA HA SIDOO AGREGADO EN STORAGE
        selectedProducts[index].quantity = counter.value;
        added = true;
      }
      paintButtonWithColorWhite.value = true;
      GetStorage().write(Memory.KEY_SHOPPING_BAG, selectedProducts);
      String m = added ? Messages.DATA_UPDATED : Messages.PRODUCT_ADDED;
      showSuccessMessages(m);


      productsListController.items.value = 0.0;
      for (var p in selectedProducts) {
        productsListController.items.value = productsListController.items.value + p.quantity! ;
      }
      Get.back();
    }
    else {
      showErrorMessages(Messages.YOU_MUST_SELECT_AT_LEAST_ONE_ITEM_TO_ADD);
    }
  }

  void addItem(Product product, var price, var counter, quantityController, RxBool paintButtonWithColorWhite,int valueToIncrease) {
    double? q = double.tryParse(quantityController.text);
    if(q==null || q<0){
      q=0;
      //showErrorMessages(Messages.ERROR_QUANTITY);
      //return;

    }
    counter.value = q + valueToIncrease;
    paintButtonWithColorWhite.value = false ;
    price.value = product.price! * counter.value;
    quantityController.text = counter.value.toString();
  }
  void setItem(Product product, var price, var counter, TextEditingController quantityController, RxBool paintButtonWithColorWhite) {
    double? q = double.tryParse(quantityController.text);
    if(q==null || q<0){
      showErrorMessages(Messages.ERROR_QUANTITY);
      return;
    }
    //counter.value = counter.value + 1;
    counter.value = q;
    price.value = product.price! * counter.value;
    quantityController.text = counter.value.toString();
    paintButtonWithColorWhite.value = false ;

    //showSuccessMessages(Messages.QUANTITY);
    
  }
  void updateShoppingBagListIfAdded(Product product, var counter){
    int index = selectedProducts.indexWhere((p) => p.id == product.id);
    if(index>-1){
      selectedProducts[index].quantity = counter.value;
    }
  }

  void removeItem(Product product, var price, var counter, TextEditingController quantityController,
      RxBool paintButtonWithColorWhite, double valueToIncrease) {
    double? q = double.tryParse(quantityController.text);
    if(q==null || q<=0){
      showErrorMessages(Messages.ERROR_QUANTITY);
      return;
    }
    paintButtonWithColorWhite.value = false ;
    if(counter.value-valueToIncrease>0){
      counter.value = q -  valueToIncrease;
    } else {
      showErrorMessages(Messages.QUANTITY);
      return;
    }
    price.value = product.price! * counter.value;
    quantityController.text = counter.value.toString();
  }

  void goToOrderCreatePage(){
    Get.toNamed(Memory.ROUTE_CLIENT_ORDER_CREATE_PAGE);
  }
}