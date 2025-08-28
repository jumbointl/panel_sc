import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/utils/relative_time_util.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../models/society.dart';
import '../../products/list/client_products_list_controller.dart';

class ClientOrdersCreateController extends ControllerModel {

  TextEditingController dateController = TextEditingController();
  Rx<DateTime> date = Memory.getDateTimeNowLocal().obs;
  var dateInString =''.obs;
  late DateTime minDay ;
  late DateTime maxDay ;
  late DateTime today ;
  List<Product> selectedProducts = <Product>[].obs;
  var total = 0.0.obs;
  ClientProductsListController productsListController = Get.find();
  List<TextEditingController> quantityController = <TextEditingController>[];
  late Society clientSociety;
  var isDebitTransaction = false.obs;

  var deliveredOrder = false.obs;
  var showDeliveredOption = true.obs;
  var colorButtonPanel = 0.obs;

  ClientOrdersCreateController() {
    var b = Get.arguments[Memory.KEY_IS_DEBIT_TRANSACTION] ?? false;
    if(b is bool){
      isDebitTransaction.value = b;
    }
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
      DateTime now = Memory.getDateTimeNowLocal();

      print('Hour Local--- ${now.day}/${now.month}/${now.year}. ${now.hour}:${now.minute}');
      maxDay = DateTime(now.year+1, now.month, now.day,now.hour,0);
      minDay = DateTime(now.year-1, now.month, now.day,now.hour,0);
      today  = DateTime(now.year, now.month, now.day,now.hour,0);
      date.value = today;
      dateInString.value =   date.value.toString().split(' ').first;
      dateController.text = dateInString.value;

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
  void setItem(Product product, int i, String string) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    double? d = double.tryParse(string);
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
    Get.toNamed(Memory.ROUTE_ADDERESS_LIST_PAGE,arguments: {
      Memory.KEY_IS_DELIVERED_ORDER:deliveredOrder.value,
      Memory.KEY_DELIVERY_DATE:date.value,
      Memory.KEY_IS_DEBIT_TRANSACTION:isDebitTransaction.value});
  }

  void setDate(DateTime? data) {
    if(data==null){
      return;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    now;
    date.value = DateTime(data.year, data.month, data.day,now.hour,0);
    Memory.deliveryDateLocal = date.value;
    print('Local--- ${date.value.day}/${date.value.month}/${date.value.year}. ${date.value.hour}:${date.value.minute}');
    String s = data.toString().split(' ').first;
    if(s.isEmpty){
      return;
    }
    int days = RelativeTimeUtil.differenceToToday(date.value);
    colorButtonPanel.value = days;
    deliveredOrder.value = false;
    if(days>0){
      deliveredOrder.value = true;
    } else {
      deliveredOrder.value = false;
    }
    if(days==0){
      showDeliveredOption.value = true ;
    } else {
      showDeliveredOption.value = false ;
    }

    dateInString.value = s;
    dateController.text = dateInString.value;


  }

  void setIsDeliveredOrder(bool newValue) {
      deliveredOrder.value = newValue;
      Memory.isDeliveredOrder = newValue;
      update();
    }



}