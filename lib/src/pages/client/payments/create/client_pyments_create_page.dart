import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/order.dart';
import '../../../../models/payment_type.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_payments_create_controller.dart';

class ClientPaymentsCreatePage extends StatelessWidget {

  ClientPaymentsCreateController con = Get.put(ClientPaymentsCreateController());

  ClientPaymentsCreatePage({super.key});

  @override
  Widget build(BuildContext context) {

    return  Scaffold(

      bottomNavigationBar: SizedBox(
        //color: Color.fromRGBO(245, 245, 245, 1),
        height: MediaQuery.of(context).size.height*0.33,
        child: cardOrder(context, con.getSavedOrder()),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          Messages.PAYMENTS,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions: [
          con.buttonBack(),
        ],
      ),
      body: GetBuilder<ClientPaymentsCreateController> ( builder: (value) => Stack(
        children: [
          _textSelectPayment(),
          _listPayment(context)
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.only(top:20, bottom: 10,right: 10,left: 10),
      child: IconButton(
        icon: con.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.PAY),
        onPressed: () => con.isLoading.value ? null : con.createPayment(context),
        tooltip: con.isLoading.value ? Messages.LOADING
            : Messages.CREATE_ADDRESS,
        style: IconButton.styleFrom(
          backgroundColor: con.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        ),
      ),
    );
  }

  Widget _listPayment(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: con.getPayments(),
          builder: (context, AsyncSnapshot<List<PaymentType>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorPayment(context,snapshot.data![index], index);
                    }
                );
              }
              else {
                return Center(
                  child: NoDataWidget(text: Messages.NO_DATA_FOUND),
                );
              }
            }
            else {
              return Center(
                child: NoDataWidget(text: Messages.NO_DATA_FOUND),
              );
            }
          }
      ),
    );
  }

  Widget _radioSelectorPayment(BuildContext context, PaymentType Payment, int index) {
    double cWidth = MediaQuery.of(context).size.width*0.6;
    return Container(
      width: cWidth,
      //color: (Payment.defaultSelection==1) ? Colors.lightBlue[100]: Colors.white,
      color: (con.radioValue.value==index) ? Colors.lightBlue[100]: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: index,
                groupValue: con.radioValue.value,
                onChanged: con.handleRadioValueChange,
              ),
              SizedBox(
                width: cWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      Payment.name?.toUpperCase() ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),

                  ],
                ),
              )
            ],
          ),
          Divider(color: Colors.grey[400])
        ],
      ),
    );
  }

  Widget _textSelectPayment() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      alignment: Alignment.topCenter,
      child: Text(
        Messages.SELECT_AN_OPTION,
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget cardOrder(BuildContext context, Order order) {
    String client = '';
    String society ='';
    if(order.idSociety==0 || order.society==null){
      if(order.user!=null ){
        String n = order.user!.name ?? '';
        String a = order.user!.lastname ?? '';
        client ='$a $n';
      }
    } else {
      society = order.society!.name ?? '';
      String n = order.user!.name ?? '';
      String a = order.user!.lastname ?? '';
      //client = '${order.seller!.name ?? ''} ($n $a)';
      client ='$a $n';
    }
    String date =RelativeTimeUtil.getRelativeTimeFromString(order.deliveredTime);
    Color color = Colors.redAccent;
    return GestureDetector(
      onTap: () => goToOrderDetailPage(order),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, left: 10, right: 10),
            //width:  MediaQuery.of(context).size.width*0.9,
            width: double.infinity,
            height: MediaQuery.of(context).size.height*0.20,
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Container(
                      height: 25,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color,
                        //color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text('${Messages.ORDER} # ${order.id}',
                          textAlign: TextAlign.center,
                          style:  TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                    height: 130,
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text('${Messages.DATE} : $date',textAlign: TextAlign.left,)),
                        //Text(order.timeStamp ?? ''),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: society,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '  ($client)', style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(order.address !=null ? order.address!.address ?? '' : '',
                            textAlign: TextAlign.left,),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text('${Messages.TOTAL_TO_PAY} : ${order.total}',
                            textAlign: TextAlign.left,style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),

                ],
              ),

            ),
          ),

          _buttonNext(context),
        ],
      ),
    );
  }

  void goToOrderDetailPage(order) {}


}
