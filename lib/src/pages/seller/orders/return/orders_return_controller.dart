import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';

import '../../../../data/memory.dart';
import '../../../../models/document_item.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';

abstract class OrdersReturnController extends ControllerModel {

  List<DocumentItem> selectedDocumentItems = <DocumentItem>[].obs;
  var total = 0.0.obs;
  //SellerProductsListController productsListController = Get.put(SellerProductsListController());
  List<TextEditingController> quantityController = <TextEditingController>[];
  late Order returnOrder ;
  OrdersProvider ordersProvider = OrdersProvider();

  OrdersReturnController() {
     returnOrder = getSavedReturnOrder();
    if (returnOrder.id != null && returnOrder.documentItems!=null) {
      selectedDocumentItems.addAll(returnOrder.documentItems!);
      for (var documentItem in selectedDocumentItems) {
        TextEditingController t = TextEditingController();
        documentItem.quantityReturned = documentItem.quantity;
        t.text = documentItem.quantityReturned.toString();
        quantityController.add(t);

      }

      getTotal();

    }
  }


  void getTotal() {
    total.value = 0.0;
    for (var product in selectedDocumentItems) {

      total.value = total.value + (product.quantityReturned! * product.price!);
    }
    update();
  }




  void allItem(DocumentItem product, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    /*
    double? d = double.tryParse(quantityController[i].text);
    if(d==null  || products.quantity ==null || d >= products.quantity!){
      showErrorMessages(Messages.QUANTITY);
      return;
    }

    int index = selectedDocumentItems.indexWhere((p) => p.id == products.id);
    selectedDocumentItems.remove(products);
    if(products.quantityReturned==d){
      products.quantityReturned = products.quantityReturned! + 1;
    } else {
      products.quantityReturned = d;
    }

     */

    int index = selectedDocumentItems.indexWhere((p) => p.id == product.id);
    selectedDocumentItems.remove(product);
    product.quantityReturned = product.quantity;
    quantityController[i].text = product.quantityReturned.toString();
    selectedDocumentItems.insert(index, product);
    print('SELECT DOCUMENT LENG ${selectedDocumentItems.length} , order ducments lengt ${returnOrder.documentItems!.length}');

    GetStorage().write(Memory.KEY_RETURN_ITEM_LIST, selectedDocumentItems);
    getTotal();

  }
  void setItem(DocumentItem product, int i, String string) {
    if(string.isEmpty){
      return;
    }
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    double? d = double.tryParse(string);
    if(d==null || d<0 || product.quantity ==null || d > product.quantity!){
      showErrorMessages(Messages.QUANTITY);
      return;
    }

    int index = selectedDocumentItems.indexWhere((p) => p.id == product.id);
    selectedDocumentItems.remove(product);
    product.quantityReturned = d;
    quantityController[i].text = product.quantityReturned.toString();
    selectedDocumentItems.insert(index, product);
    print('SELECT DOCUMENT LENG ${selectedDocumentItems.length} , order ducments lengt ${returnOrder.documentItems!.length}');
    GetStorage().write(Memory.KEY_RETURN_ITEM_LIST, selectedDocumentItems);
    getTotal();

  }

  void removeItem(DocumentItem product, int i) {
    if(i<0){
      showErrorMessages(Messages.INDEX);
      return;
    }
    /*
    double? d = double.tryParse(quantityController[i].text);
    if(d==null || d<=0 || products.quantity ==null || d > products.quantity!){
      showErrorMessages(Messages.QUANTITY);
      return;
    }
    if(products.quantityReturned==d){

      if(d < 1){
        showErrorMessages(Messages.QUANTITY);
        return;
      }
      products.quantityReturned = products.quantityReturned! - 1;

    } else {
      products.quantityReturned = d;
    }


     */
    product.quantityReturned = 0;
    quantityController[i].text = product.quantityReturned.toString();
    int index = selectedDocumentItems.indexWhere((p) => p.id == product.id);
    selectedDocumentItems.remove(product);
    selectedDocumentItems.insert(index, product);
    print('SELECT DOCUMENT LENG ${selectedDocumentItems.length} , order ducments lengt ${returnOrder.documentItems!.length}');
    GetStorage().write(Memory.KEY_RETURN_ITEM_LIST, selectedDocumentItems);
    getTotal();

  }
  Future<void> updateOrderToTotalReturned(BuildContext context) async {
    returnOrder.setOrderStatus(Memory.returnedOrderStatus);
    returnOrder.documentItems = selectedDocumentItems;
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateOrderToTotalReturnedStatus(context,returnOrder);
    isLoading.value = false;
    if (responseApi.success == true) {
      showSuccessMessages(responseApi.message!);
      Get.offNamedUntil(Memory.PAGE_TO_RETURN_FROM_ORDERS_RETURN_PAGE, (route) => false);
    } else {
      showErrorMessages(responseApi.message!);
    }

  }
  Future<void> updateOrderToPartialReturned(BuildContext context) async {
    returnOrder.setOrderStatus(Memory.returnedOrderStatus);
    returnOrder.documentItems = selectedDocumentItems;
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateOrderToPartiallyReturnedStatus(context,returnOrder);
    isLoading.value = false;
    if (responseApi.success == true) {
      showSuccessMessages(responseApi.message!);
      Get.offNamedUntil(Memory.PAGE_TO_RETURN_FROM_ORDERS_RETURN_PAGE, (route) => false);
    } else {
      showErrorMessages(responseApi.message!);
    }

  }


}