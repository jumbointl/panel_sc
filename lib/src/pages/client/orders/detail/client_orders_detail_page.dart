import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_orders_detail_controller.dart';


class ClientOrdersDetailPage extends StatelessWidget {
  
  ClientOrdersDetailController con = Get.put(ClientOrdersDetailController());
  ClientOrdersDetailPage({super.key});

  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
        color: Color.fromRGBO(245, 245, 245, 1),
        height: con.order.idOrderStatus == Memory.ORDER_STATUS_PAID_APPROVED_ID
            ? MediaQuery.of(context).size.height * 0.35
            : MediaQuery.of(context).size.height * 0.35,
        // padding: EdgeInsets.only(top: 5),
        child: Column(
          children: [

            _dataClient(),
            _dataAddress(),
            _dataDelivery(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          con.buttonBack(),
        ],
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: SafeArea(
          child: Text(
            '${Messages.ORDER} #${con.order.id}',
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ),
      ),
      body: con.order.documentItems!.isNotEmpty
      ? Container(
        //color: Colors.white,
        margin: EdgeInsets.only(bottom: 10),
        child: ListView(

          children: List.generate(con.order.documentItems!.length, (index) {
            return  _cardProduct(context, con.order.documentItems![index]);
          }

          ),
        ),
      )
      : Center(
          child: NoDataWidget(text: Messages.NO_DATA_FOUND)
      ),
    ));
  }

  Widget _dataClient() {
    String client = '';
    String society ='';
    if(con.order.idSociety==0 || con.order.society==null){
      if(con.order.user!=null ){
        String n = con.order.user!.name ?? '';
        String a = con.order.user!.lastname ?? '';
        client ='$a $n';
      }
    } else {
      society = con.order.society!.name ?? '';
      String n = con.order.user!.name ?? '';
      String a = con.order.user!.lastname ?? '';
      client ='$a $n';
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text('$society ($client)'),
        subtitle: Text(con.order.deliveredTime != null ? RelativeTimeUtil.getRelativeTimeFromString(con.order.deliveredTime!):''),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataDelivery() {
    String delivery ='';
    if(con.order.delivery!=null ){
      String n = con.order.delivery!.name ?? '';
      String a = con.order.delivery!.lastname ?? '';
      String p = con.order.delivery!.phone ?? '';
      delivery ='$a $n -($p)';
    } else {
      delivery = Messages.NO_DATA_FOUND;
    }
    return con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
    ? Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(Messages.DELIVERY_BOY),
        subtitle: Text(delivery),
        trailing: Icon(Icons.person_2),
      ),
    )
    : Container();
  }

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        //title: Text(Messages.CLIENT_ADDRESS),
        title: Text(con.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }


  Widget _cardProduct(BuildContext context, Product product) {
    double subtotal = 0;
    if(product.quantity !=null && product.price!=null){
      subtotal = product.quantity! * product.price!;
    }


    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(width: 10,),
              Text(

                product.name ?? '',
                style: TextStyle(
                    fontWeight: FontWeight.bold

                ),
              ),
              Spacer(),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10,),
              _imageProduct(product),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [

                  SizedBox(height: 7),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      children: [
                        Text(
                          '${Messages.QUANTITY}: ${numberFormatter.format(product.quantity)}',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold
                              fontSize: 13
                          ),
                        ),
                        Spacer(),
                        Text(
                          '${Messages.PRICE}: ${currencyFormatter.format(product.price)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13
                          ),
                        ),
                      ],
                    ),
                  ),

                  Text(
                    '${Messages.SUBTOTAL}: ${currencyFormatter.format(subtotal)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                  ),
                  SizedBox(height: 10,),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: product.image1 != null
              ? NetworkImage(product.image1!)
              : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [

        Container(
          margin: EdgeInsets.only(left:20, top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: con.order.idOrderStatus! > Memory.ORDER_STATUS_PAID_APPROVED_ID
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                      Text(
                        '${Messages.TOTAL}: ${currencyFormatter.format(con.total.value)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17
                        ),
                      ),
                      con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                          ? Spacer() : Container(),
                  con.order.idOrderStatus! == Memory.ORDER_STATUS_PAID_APPROVED_ID
                      ? Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: ElevatedButton(
                        onPressed: () => con.updateOrderToCanceled(context,con.order),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15)
                        ),
                        child: Text(Messages.CANCEL,
                          style: TextStyle(
                              color: Colors.black
                          ),
                        )
                    ),
                  )
                      : Container(),
                  con.order.idOrderStatus! > Memory.ORDER_STATUS_PAID_APPROVED_ID
                      ? Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: ElevatedButton(
                        onPressed: () => con.goToOrderMapPage(),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15)
                        ),
                        child: Text(Messages.MAP,
                          style: TextStyle(
                              color: Colors.black
                          ),
                        )
                    ),
                  )
                      : Container(),
                ],
              ),

            ],
          ),
        )

      ],
    );
  }






}
