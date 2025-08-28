import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/document_item.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import 'package:solexpress_panel_sc/src/utils/relative_time_util.dart';

import '../../../../data/memory.dart';
import '../../../../models/address.dart';
import '../../../../models/order.dart';
import '../../../../models/product.dart';
import '../../../../models/response_api.dart';
import '../../../../models/society.dart';
import '../../../../models/user.dart';
import '../../../../providers/addresses_provider.dart';
import '../../../common/controller_model.dart';

class ClientAddressListController extends ControllerModel {

  List<Address> addresses = [];
  AddressesProvider addressProvider = AddressesProvider();
  User user =  Memory.getSavedUser();
  Society clientSociety = Society();
  OrdersProvider ordersProvider = OrdersProvider();
  RxString addressName = ''.obs;
  late int deliveryDate;
  bool testMode = false;

  var radioValue = 0.obs;
  Address? address;
  var isDebitTransaction = false.obs;
  bool isDeliveredOrder = false;

  ClientAddressListController() {
    //print('LA DIRECCION DE SESION ${GetStorage().read(Memory.ADDRESS)}');
    var b = Get.arguments[Memory.KEY_IS_DEBIT_TRANSACTION] ?? false;
    if(b is bool){
      isDebitTransaction.value = b;
    }
    var b2 = Get.arguments[Memory.KEY_IS_DELIVERED_ORDER] ?? false;
    if(b2 is bool){
      isDeliveredOrder = b2;
    }


      clientSociety = getSavedClientSociety() ;
      if(Get.arguments[Memory.KEY_DELIVERY_DATE]!=null){
        var data = Get.arguments[Memory.KEY_DELIVERY_DATE];
        if(data is int){
          deliveryDate = data;
        } else if(data is DateTime){
          deliveryDate = data.microsecondsSinceEpoch;
        }
      }
  }

  Future<List<Address>> getAddresses() async {

    int active =1;
    isLoading.value = true;
    addresses = await addressProvider.getByUserAndSocietyActive(user,clientSociety,active);
    isLoading.value = false;
    //Address? a = Memory.lastCreatedAddress;
    if(addresses.isEmpty){
      return [];
    }
    Address a = getSavedAddress() ;  //DIRECCION SELECCIONADA POR EL USUARIO
    int index = addresses.indexWhere((ad) => ad.id == a.id);

    if (index != -1) { // LA DIRECCION DE SESION COINCIDE CON UN DATOS DE LA LISTA DE DIRECCIONES
      radioValue.value = index;

    } else {
      radioValue.value = 0;
    }
    a = addresses[radioValue.value];
    if(a.name!=null){
      addressName.value = a.name!;
    }
    if(a.id!=null){
      GetStorage().write(Memory.KEY_ADDRESS, a);
    }

    return addresses;
  }


  void createOrder(BuildContext context) async {
    if(clientSociety.id==null){
      clientSociety = getSavedClientSociety();
    }

    int isVatIncludedOnPrice = 0;
    if(clientSociety.id ==null || clientSociety.priceIncludingVat == null){
      showErrorMessages(Messages.SOCIETY);
      return;
    } else {
      isVatIncludedOnPrice = clientSociety.priceIncludingVat!;
    }
    Address a = getSavedAddress() ;
    if(a.id==null){
      showErrorMessages(Messages.ADDRESS);
      return;
    }
    Order order = Order(idIssuer: Memory.ID_ISSUER,isDebitDocument:1,active:1,
        idAddress: a.id, address: a, priceIncludingVat:  isVatIncludedOnPrice);
    List<Product> products =[];
    if (GetStorage().read(Memory.KEY_SHOPPING_BAG) is List<Product>) {
      products = GetStorage().read(Memory.KEY_SHOPPING_BAG);
    } else {
      products =Product.fromJsonList(GetStorage().read(Memory.KEY_SHOPPING_BAG));
    }
    for (var product in products) {
      DocumentItem d = DocumentItem();
      d.setProduct(product,order.priceIncludingVat!);
      order.addDocumentItem(d);
      //items.add(d);
    }

    order.setUserAccount(user);
    order.setSociety(clientSociety);
    order.setPaymentType(Memory.undefinedPayment);
    if(clientSociety.isHasCredit()==1){
      order.setOrderStatus(Memory.paidApprovedOrderStatus);
      order.isCashSale = 0 ;
    } else {
      order.isCashSale = 1;
      order.setOrderStatus(Memory.createOrderStatus);
    }
    DateTime? deliveryDateLocal = Memory.deliveryDateLocal;
    DateTime orderCreatePageOpenedAtLocal = Memory.orderCreatePageOpenedAtDateTimeLocal;
    order.deliveredTime = RelativeTimeUtil.getStringFromLocalTimeForSql(deliveryDateLocal);

    if(isDeliveredOrder){
      order.idDelivery = Memory.DEFAULT_DELIVERY_MAN_ID;
      order.idWarehouse = Memory.DEFAULT_WAREHOUSE_ID;
      order.setOrderStatus(Memory.deliveredOrderStatus);
      if(testMode){
        showSuccessMessages('order delivered  ${order.deliveredTime ??''}');
      }
    } else {
      if(testMode){
        showErrorMessages('order not delivered  ${order.deliveredTime ??''}');
      }
      // para implementar despues devolucion pregramada/controlada , entonce aqui dejar null
      /*
      order.idDelivery = Memory.DEFAULT_DELIVERY_MAN_ID;
      order.idWarehouse = Memory.DEFAULT_WAREHOUSE_ID;
      order.setOrderStatus(Memory.deliveredOrderStatus);

       */

    }
    if(testMode){
      return;
    }
    order.notificationToken = user.notificationToken;
    order.setCurrency(Memory.defaultCurrency);
    ResponseApi responseApi = ResponseApi();
    isLoading.value = true;
    if(isDebitTransaction.value==true){
      responseApi = await ordersProvider.create(context, order);
    } else {
      responseApi = await ordersProvider.createCreditOrder(context, order);
    }
    isLoading.value = false;
    if (responseApi.success == true) {
      Order a = Order.fromJson(responseApi.data);
      order.id = a.id;
      GetStorage().write(Memory.KEY_ORDER, order.toJson());
      GetStorage().write(Memory.KEY_LAST_ORDER, order.toJson());


      removeKeysAfterOrderCreate(order);


      if(clientSociety.isHasCredit()==1 || order.idOrderStatus==Memory.deliveredOrderStatus.id){
        Get.toNamed(Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT);
      } else {
        Get.toNamed(Memory.PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITHOUT_CREDIT,arguments:{Memory.KEY_ORDER,order.toJson()});
      }

    } else {
      showErrorMessages(responseApi.message ?? '');
    }

  }

  void handleRadioValueChange(int? value) {
    if(value==null){
      return;
    }
    radioValue.value = value;
    if(addresses[value].name!=null){
      addressName.value = addresses[value].name!;

    }
    saveAddress(addresses[value]);
    update();
  }

  void goToAddressCreate() {
    Get.toNamed(Memory.ROUTE_CLIENT_ADDRESS_CREATE_PAGE);
  }

}