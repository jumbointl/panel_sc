import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/order.dart';
import '../../../../models/payment.dart';
import '../../../../models/payment_type.dart';
import '../../../../models/response_api.dart';
import '../../../../models/society.dart';
import '../../../../models/user.dart';
import '../../../../providers/payments_provider.dart';
import '../../../common/controller_model.dart';

class ClientPaymentsCreateController extends ControllerModel {

  List<PaymentType> payments = Memory.paymentsAvailable;
  //OrdersProvider ordersProvider = OrdersProvider();
  User user =  Memory.getSavedUser();
  Society? clientSociety ;
  PaymentsProvider paymentsProvider = PaymentsProvider();

  var radioValue = 0.obs;
  Payment? payment;

  ClientPaymentsCreateController() {
    //print('LA DIRECCION DE SESION ${GetStorage().read(Memory.ADDRESS)}');
      clientSociety = getSavedClientSociety();
  }







  void handleRadioValueChange(int? value) {
    radioValue.value = value!;
    savePaymentType(payments[value]);
    update();
  }



  Future<List<PaymentType>> getPayments() async {

    return payments;
  }
  void createPayment(BuildContext context) async {

    if(radioValue<-1){
      showErrorMessages(Messages.PAYMENTS_TYPE);
      return;
    }
    Order order = getSavedOrder();
    PaymentType type = payments[radioValue.value];
    Payment payment = Payment(idOrder: order.id,idUser: user.id,amount: order.total );
    payment.setPaymentType(type);
    if (!payment.isValid()){
      showErrorMessages(Messages.PAYMENTS);
      return;
    }
    isLoading.value = true;
    ResponseApi responseApi = await paymentsProvider.create(context, payment);
    isLoading.value = false;
    if (responseApi.success == true) {
      int? id  = responseApi.data;
      payment.id = id;
      savePayment(payment);
      order.payment = payment;
      order.idPayment = id;
      saveOrder(order);
      Get.offNamedUntil(Memory.PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE,(route)=>false);


    } else {
      showErrorMessages(responseApi.message ?? '');
    }

  }


}