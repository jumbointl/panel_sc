import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
import 'delivery_orders_detail_controller.dart';


class DeliveryOrdersDetailPage extends StatelessWidget {

  DeliveryOrdersDetailController con = Get.put(DeliveryOrdersDetailController());
  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  double screenWidth = 0;
  double screenHeight = 0;
  double columnsWidth = 0;
  bool isWideScreen = false;
  int columns = 2;
  bool isPortrait = true;

  DeliveryOrdersDetailPage({super.key});


  @override
  Widget build(BuildContext context) {
    isPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth>=Memory.minimumWideScreenWidth){
      isWideScreen = true;
    }
    columns  = (screenWidth/Memory.minimumWideScreenColumWidth).round()*2;
    if(columns==0){
      columns =2;
    }
    columnsWidth = (screenWidth/columns)*0.85;
    print('Columns $columns');
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: MediaQuery.of(context).size.height * 0.40,
          // padding: EdgeInsets.only(top: 5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _dataClient(),
                _dataAddress(),
                _totalToPay(context),
                _bottomPanel(context),
              ],
            ),
          ),
        ),
      
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        actions: [
          con.buttonBack(),
        ],
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
            crossAxisCount: columns, // 2 columns
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

  Widget _dataAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        //title: Text(Messages.DELIVERY_ADDRESS),
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
                    numberFormatter.format(product.quantity),
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
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            '${Messages.TOTAL}:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Text(
            currencyFormatter.format(con.total.value),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.cyan[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomPanel(BuildContext context) {
    return Column(
      children: [

        Container(
          margin: EdgeInsets.only(left:15, top: 15,right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: con.order.idOrderStatus! > Memory.ORDER_STATUS_PAID_APPROVED_ID
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [

                      con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                          ? Spacer() : Container(),
                  con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                      ? Container(
                    margin: EdgeInsets.only(right: 10,left: 10),
                    child: IconButton(
                      icon: con.isLoading.value
                          ? CircularProgressIndicator(color: Colors.redAccent)
                          : Text(Messages.MAP),
                      onPressed: () => con.isLoading.value ? null : con.goToOrderMapPage(),
                      tooltip: con.isLoading.value ? Messages.LOADING
                          : Messages.MAP,
                      style: IconButton.styleFrom(
                        backgroundColor: con.isLoading.value
                            ? Memory.PRIMARY_COLOR
                            : Memory.BAR_BACKGROUND_COLOR,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  )
                      : Container(),
                      con.order.idOrderStatus! > Memory.ORDER_STATUS_PAID_APPROVED_ID
                          ? Container(
                        //margin: EdgeInsets.symmetric(horizontal: 10),
                        child: IconButton(
                          icon: con.isLoading.value
                              ? CircularProgressIndicator(color: Colors.redAccent)
                              : Text(Messages.DELIVER),
                          onPressed: () => con.isLoading.value ? null : con.updateOrderToDelivered(context,con.order),
                          tooltip: con.isLoading.value ? Messages.LOADING
                              : Messages.DELIVER,
                          style: IconButton.styleFrom(
                            backgroundColor: con.isLoading.value
                                ? Memory.PRIMARY_COLOR
                                : Memory.BAR_BACKGROUND_COLOR,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      )
                          : Container(),
                    ],
                ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      icon: con.isLoading.value
                          ? CircularProgressIndicator(color: Colors.redAccent)
                          : Text(Messages.RETURN),
                      onPressed: () => con.isLoading.value ? null : con.goToOrderReturnPage(con.order),
                      tooltip: con.isLoading.value ? Messages.LOADING
                          : Messages.RETURN,
                      style: IconButton.styleFrom(
                        backgroundColor: con.isLoading.value
                            ? Memory.PRIMARY_COLOR
                            : Memory.BAR_BACKGROUND_COLOR,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  )
                      : Container(),

                  con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                      ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: IconButton(
                      icon: con.isLoading.value
                          ? CircularProgressIndicator(color: Colors.redAccent)
                          : Text(Messages.CANCEL),
                      onPressed: () => con.isLoading.value ? null : con.updateOrderToPaidAndSetDeliveryIdNull(context,con.order),
                      tooltip: con.isLoading.value ? Messages.LOADING
                          : Messages.CANCEL,
                      style: IconButton.styleFrom(
                        backgroundColor: con.isLoading.value
                            ? Memory.PRIMARY_COLOR
                            : Memory.BAR_BACKGROUND_COLOR,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                    ),
                  )
                      : Container(),
                  _getShippedBottom(context),
                ],
              ),
            ],
          ),
        )

      ],
    );
  }




  Container _getShippedBottom(BuildContext context){
    return con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
        ? Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child:IconButton(
        icon: con.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.SHIPP),
        onPressed: () => con.isLoading.value ? null : con.updateOrderToShipped(context,con.order),
        tooltip: con.isLoading.value ? Messages.LOADING
            : Messages.SHIPP,
        style: IconButton.styleFrom(
          backgroundColor: con.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    )
        : Container();
  }

}
