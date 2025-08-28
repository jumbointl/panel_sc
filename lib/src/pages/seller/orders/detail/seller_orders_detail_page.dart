import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/pages/seller/orders/detail/seller_orders_detail_controller.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../models/user.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';


class SellerOrdersDetailPage extends StatelessWidget {

  SellerOrdersDetailController con = Get.put(SellerOrdersDetailController());
  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  SellerOrdersDetailPage({super.key});
  double gridRatio = 2.3;
  bool paid = false;
  bool deliveryAssigned = false;
  double screenWidth = 0;
  double screenHeight = 0;
  double columnsWidth = 0;
  double cardHeight = 80 ;
  bool isWideScreen = false;
  int columns = 1;
  bool isPortrait = true;


  @override
  Widget build(BuildContext context) {
    isPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth>=Memory.minimumWideScreenWidth){
      isWideScreen = true;
    }

    columns  = (screenWidth/Memory.minimumWideScreenColumWidth).round();
    if(columns==0){
      columns =1;
    }

    columnsWidth = (screenWidth/columns)*0.8;
    double ratio = columnsWidth/cardHeight;
    print('columns $columns columnswidth $columnsWidth');
    return Obx(() => Scaffold(
      bottomNavigationBar: Container(
            //margin: EdgeInsets.symmetric(horizontal: 10),
            color: Color.fromRGBO(245, 245, 245, 1),
            height: con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                ? MediaQuery.of(context).size.height * 0.41
                : MediaQuery.of(context).size.height * 0.38,
            // padding: EdgeInsets.only(top: 5),
            child: SingleChildScrollView(
                child: Column(
                  children: [
                    _dataClient(),
                    _dataAddress(),
                    _getDeliveryPanel(context),
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
            '#${con.order.id} (${con.order.documentItems?.length ?? 0} Items)',
            style: TextStyle(
              color: Colors.black
            ),
          ),
        ),

      ),
      body: con.order.documentItems!.isNotEmpty
      ? Container(
        color: Colors.lightGreen[200],
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns, //  columns
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: ratio,
          ),
          children: List.generate(con.order.documentItems!.length, (index) {
            return  _cardProduct(context, con.order.documentItems![index],index);
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
    String society ='';
    if(con.order.idSociety==0 || con.order.society==null){
      if(con.order.user!=null ){
        String n = con.order.user!.name ?? '';
        String a = con.order.user!.lastname ?? '';
        society ='$a $n';
      }
    } else {
      society = con.order.society?.name! ?? 'EMPTY';
    }
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        //title: Text(Messages.CLIENT),
        //subtitle: Text('$society ($client)'),
        title: Text(society),
        subtitle: Text(con.order.deliveredTime != null ? RelativeTimeUtil.getRelativeTimeFromString(con.order.deliveredTime!):''),
        trailing: Icon(Icons.person),
      ),
    );
  }

  Widget _dataDelivery(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text('${con.order.delivery?.lastname ?? ''} ${con.order.delivery?.name ?? ''} - ${con.order.delivery?.phone ?? ''}'),
        trailing: Icon(Icons.delivery_dining),
      ),
    );
  }

  Widget _dataAddress() {
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        title: Text(con.order.address?.address ?? ''),
        trailing: Icon(Icons.location_on),
      ),
    );
  }


  Widget _cardProduct(BuildContext context, Product product, int index) {
    double subtotal = 0;
    if(product.quantity !=null && product.price!=null){
      subtotal = product.quantity! * product.price!;
    }
    return Container(
      color: Colors.white,
      height: cardHeight,
      width: columnsWidth -10,
      margin: EdgeInsets.symmetric(vertical: 7),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 10,),
              Text(
                '${index+1} - ${product.name ?? ''}',
                style: TextStyle(
                    fontWeight: FontWeight.bold

                ),
              ),
              //Spacer(),
            ],
          ),
          Row(
            children: [
              SizedBox(width: 10),
              _imageProduct(product),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 7),
                  SizedBox(
                    width: columnsWidth-20,
                    child: Row(
                      children: [
                        Text(
                          '${Messages.QUANTITY}: ${numberFormatter.format(product.quantity)}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
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
                  SizedBox(height: 10,)
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
    deliveryAssigned = false;
    if(con.order.idOrderStatus! > Memory.ORDER_STATUS_PAID_APPROVED_ID){
      deliveryAssigned =true;
    }

    if(con.order.idOrderStatus!>=Memory.ORDER_STATUS_PAID_APPROVED_ID){
      paid = true;
    }
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _getShippedButton(context),
                Spacer(),
                con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                    ? IconButton(
                  icon: con.isLoading.value
                      ? CircularProgressIndicator(color: Colors.redAccent)
                      : Text(deliveryAssigned ? Messages.MAP : Messages.PREPARED ,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  onPressed: () => con.isLoading.value ? null : deliveryAssigned ?
                      con.goToOrderMapPage() :con.updateOrderToPrepared(context),
                  tooltip: con.isLoading.value ? Messages.LOADING
                      : deliveryAssigned ? Messages.MAP : Messages.PREPARED,
                  style: IconButton.styleFrom(
                    backgroundColor: con.isLoading.value
                        ? Memory.PRIMARY_COLOR
                        : Memory.BAR_BACKGROUND_COLOR,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                )                    : Container(),
                SizedBox(width: 10,),
                con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                    ? IconButton(
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
                )
                    : Container(),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                  ? IconButton(
                            icon: con.isLoading.value
                            ? CircularProgressIndicator(color: Colors.redAccent)
                                : Text(Messages.CANCEL),
                            onPressed: () => con.isLoading.value ? null : con.updateOrderToCanceled(context,con.order),
                            tooltip: con.isLoading.value ? Messages.LOADING
                                : Messages.CANCEL,
                            style: IconButton.styleFrom(
                            backgroundColor: con.isLoading.value
                            ? Memory.PRIMARY_COLOR
                                : Memory.BAR_BACKGROUND_COLOR,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            ),
              )

                  : Container(),
              SizedBox(width: 10,),
              con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                  ? IconButton(
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
              )

                  : Container(),
              SizedBox(width: 10,),
              con.order.idOrderStatus! >= Memory.ORDER_STATUS_PAID_APPROVED_ID
                  ? IconButton(
                    icon: con.isLoading.value
                    ? CircularProgressIndicator(color: Colors.redAccent)
                        : Text(Messages.DESIST),
                    onPressed: () => con.isLoading.value ? null : con.updateOrderToPaidAndSetDeliveryIdNull(context,con.order),
                    tooltip: con.isLoading.value ? Messages.LOADING
                        : Messages.DESIST,
                    style: IconButton.styleFrom(
                    backgroundColor: con.isLoading.value
                    ? Memory.PRIMARY_COLOR
                        : Memory.BAR_BACKGROUND_COLOR,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
            )
                  : Container()
            ],
          ),

        ],
      ),
    );
  }

  Widget _dropDownDeliveryMen(List<User> users) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 35),
      margin: EdgeInsets.only(left: 15, right: 15,),
      child: DropdownButton(
        underline: Container(
          //color: Memory.BAR_BACKGROUND_COLOR,
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber[800],
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.ASSIGN_DELIVERY_PERSON,
          style: TextStyle(
              color: Colors.black,
              fontSize: 20
          ),
        ),
        items: _dropDownItems(users),
        value: con.idDelivery.value == '' ? null : con.idDelivery.value,
        onChanged: (option) {
          print('Opcion seleccionada $option');
          con.idDelivery.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItems(List<User> users) {
    List<DropdownMenuItem<String>> list = [];
    for (var user in users) {
      list.add(DropdownMenuItem(
        value: user.id.toString(),
        child: Row(
          children: [
            SizedBox(
              height: 35,
              width: 35,
              child: FadeInImage(
                image: user.image != null
                    ? NetworkImage(user.image!)
                    : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage(Memory.IMAGE_NO_IMAGE),
              ),
            ),
            SizedBox(width: 15),
            Text('${user.name ?? ''} ${user.lastname ?? ''}'),
          ],
        ),
      ));
    }

    return list;
  }

  Container _getShippedButton(BuildContext context){

    return deliveryAssigned
        ? Container(
      margin: EdgeInsets.only(right: 10),
      child:IconButton(
        icon: con.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.ON_THE_WAY),
        onPressed: () => con.isLoading.value ? null : con.updateOrderToShipped(context,con.order),
        tooltip: con.isLoading.value ? Messages.LOADING
            : Messages.ON_THE_WAY,
        style: IconButton.styleFrom(
          backgroundColor: con.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      ),
    ) :Container();
  }

  Widget _getDeliveryPanel(BuildContext context) {
    if(con.order.idOrderStatus!>=Memory.ORDER_STATUS_PAID_APPROVED_ID){
      paid = true;
    } else {
      paid = false;
    }
    return paid  ?  deliveryAssigned ? _dataDelivery(context)  :_dropDownDeliveryMen(con.users)
        : ElevatedButton(
        onPressed: () => con.goToPaymentsPage(),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(15)
        ),
        child: Text(Messages.PAY,
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
  }
}
