import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
import 'delivery_orders_return_controller.dart';


class DeliveryOrdersReturnPage extends StatelessWidget {

  DeliveryOrdersReturnController con = Get.put(DeliveryOrdersReturnController());
  DeliveryOrdersReturnPage({super.key});


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
            //_dataDate(),
            _dataClient(),
            _dataAddress(),
            _dataDelivery(),
            _totalToPay(context),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
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
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 2,
          ),
          children: List.generate(con.order.documentItems!.length, (index) {
            return  _cardProduct(con.order.documentItems![index]);
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


  Widget _cardProduct(Product product) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Column(
        children: [
          Text(
            product.name ?? '',
            style: TextStyle(
                fontWeight: FontWeight.bold

            ),
          ),
          Row(
            children: [
              _imageProduct(product),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 7),
                  Text(
                    '${Messages.QUANTITY}:',
                    style: TextStyle(
                      // fontWeight: FontWeight.bold
                        fontSize: 13
                    ),
                  ),
                  Text(
                    '${product.quantity}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15
                    ),
                  ),
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
                        '${Messages.TOTAL}: ${Memory.currencyFormatter.format(con.total.value)}',
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
                        onPressed: () => con.updateOrderToTotalReturned(context),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15)
                        ),
                        child: Text(Messages.TOTAL_RETURN,
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
                        onPressed: () => con.updateOrderToPartialReturned(context),
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15)
                        ),
                        child: Text(Messages.PARTIAL_RETURN,
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
