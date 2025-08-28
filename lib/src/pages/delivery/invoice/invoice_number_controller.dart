import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/models/invoice_number.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';

import '../../../data/memory.dart';
import '../../../data/messages.dart';
import '../../../models/order.dart';
import '../../../models/response_api.dart';

class InvoiceNumberController extends ControllerModel {
  Order order = Order.fromJson(Get.arguments[Memory.KEY_ORDER]);
  late InvoiceNumber invoiceNumber;
  var number = 1.obs;
  var branch = 1.obs;
  var cashRegister = 1.obs;
  var invoiceNumberString =''.obs;
  Rx<DateTime> date = Memory.getDateTimeNowLocal().obs;
  var dateInString =''.obs;
  late DateTime minDay ;
  late DateTime maxDay ;
  late DateTime today ;
  NumberFormat formatter3 = NumberFormat("000");
  NumberFormat formatter7 = NumberFormat("0000000");
  TextEditingController numberController = TextEditingController();
  TextEditingController cashRegisterController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String formattedNumber = '';
  String formattedCashRegister = '';
  String formattedBranch = '';
  RxBool paintWithColorWhite =true.obs;
  InvoiceNumberController(){

    invoiceNumber = getSavedInvoiceUsed();
    if(invoiceNumber.branch!=null){
      branch.value = invoiceNumber.branch!;
      branchController.text = branch.value.toString();
    }
    if(invoiceNumber.cashRegister!=null){
      cashRegister.value = invoiceNumber.cashRegister!;
      cashRegisterController.text = cashRegister.value.toString();
    }
    if(invoiceNumber.number!=null){
        number.value = invoiceNumber.number!+1;
        numberController.text = number.value.toString();
    }
    DateTime now = Memory.getDateTimeNowLocal();
    maxDay = DateTime(now.year+1, now.month, now.day);
    minDay = DateTime(now.year-1, now.month, now.day);
    today  = DateTime(now.year, now.month, now.day);
    date.value = today;
    dateInString.value =   date.value.toString().split(' ').first;

    dateController.text = dateInString.value;


    setInvoiceNumberString();




  }


  void addItem(var value, controller,int valueToIncrease) {
    int? q = int.tryParse(controller.text);
    if(q==null || q<0){
      q=0;
      //showErrorMessages(Messages.ERROR_QUANTITY);
      //return;

    }
    value.value = q + valueToIncrease;
    controller.text = value.value.toString();
    setInvoiceNumberString();
  }
  void setItem(var counter, TextEditingController controller) {
    int? q = int.tryParse(controller.text);
    if(q==null || q<0){
      showErrorMessages(Messages.ERROR_QUANTITY);
      return;
    }
    counter.value = q;
    controller.text = counter.value.toString();

    setInvoiceNumberString();
  }



  void removeItem(var value, TextEditingController controller,
      int valueToIncrease) {
    int? q = int.tryParse(controller.text);
    if(q==null || q<=0){
      showErrorMessages(Messages.ERROR_QUANTITY);
      return;
    }
    if(value.value-valueToIncrease>0){
      value.value = q -  valueToIncrease;
    } else {
      showErrorMessages(Messages.QUANTITY);
      return;
    }
    controller.text = value.value.toString();
    setInvoiceNumberString();
  }

  Future<void> updateOrderStatusToDeliveredwithInvoice(BuildContext context) async {

   InvoiceNumber invoiceNumber = InvoiceNumber(
     number: number.value,
     cashRegister: cashRegister.value,
     branch: branch.value,
     numberInString: invoiceNumberString.value,
     date: date.value.toString()
   );
   print('date ${invoiceNumber.date.toString()}');
   saveInvoiceUsed(invoiceNumber);
   order.invoiceNumbers = invoiceNumberString.value;
   print('invoice ${invoiceNumber.numberInString}');
   order.setOrderStatus(Memory.deliveredOrderStatus);
   OrdersProvider ordersProvider = OrdersProvider();
   ResponseApi responseApi = await ordersProvider.updateOrderStatusToDeliveredWithInvoice(context,order);
   if (responseApi.success == true) {
     showSuccessMessages(responseApi.message!);
     Get.offNamedUntil(Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE, (route) => false);
   } else {
     showErrorMessages(responseApi.message!);
   }

   //Get.back(result:invoiceNumber);
  }

  void setInvoiceNumberString() {


    formattedNumber = formatter7.format(number.value);
    formattedCashRegister = formatter3.format(cashRegister.value);
    formattedBranch = formatter3.format(branch.value);
    invoiceNumberString.value ='$formattedBranch-$formattedCashRegister-$formattedNumber';
    paintWithColorWhite.value = false;
  }

  void setDate(DateTime? data) {
    if(data==null){
      return;
    }
    date.value = data ;
    String s = data.toString().split(' ').first;
    if(s.isEmpty){
      return;
    }

    dateInString.value = s;
    dateController.text = dateInString.value;


  }
}