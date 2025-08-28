import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/document_item.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/order.dart';
import '../../../../utils/relative_time_util.dart';
import '../../../../widgets/no_data_widget.dart';
abstract class AccountingListPageModel extends StatelessWidget {
  double imageHeight = 60;
  double imageWidth = 60;
  int quantityLength = 5;
  Color colorTextTitle = Colors.black;
  double screenWidth = 0;
  double screenHeight = 0;
  double columnsWidth = 0;
  bool isWideScreen = false;
  int columns = 1;
  bool isPortrait = true;
  RxBool isLoading = false.obs;
  bool isDebit = true;
  AccountingListPageModel({super.key});

  @override
  Widget build(BuildContext context) {
    isPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    if(screenWidth>=Memory.minimumWideScreenWidth){
      isWideScreen = true;
    }
    if(isWideScreen){
      columns  = (screenWidth/Memory.minimumWideScreenColumWidth).floor();
      if(columns==0){
        columns ==1;
      }
      columnsWidth = (screenWidth/columns)*0.85;
    }
    return Obx(() =>
      DefaultTabController(

          length: getTabLength(),
          child: Scaffold(

              appBar: AppBar(
                      //toolbarHeight: 80,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      actions: getActionButtons(),
                      flexibleSpace: SafeArea( child: getTitleField()),
                      //leading: getBottomSheet(),


                      bottom:  TabBar(
                          tabAlignment: TabAlignment.center,
                          isScrollable: true,
                          indicatorColor: Memory.BAR_BACKGROUND_COLOR,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey[600],
                          tabs: List<Widget>.generate(getTabLength(), (index){
                            return Tab(child: Text( getOrderStatusList()[index].name ??''),);

                          })),
                    ),
              bottomSheet: isLoading.value ? CircularProgressIndicator() : getBottomSheet(),
              body: SafeArea(
                child: TabBarView(children: getOrderStatusList().map((OrderStatus status){
                  return FutureBuilder(
                      future: getOrders(context,status),
                      builder: (context, AsyncSnapshot<List<Order>?> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return  GridView.builder(
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (_, index) {
                                return cardOrder(context, snapshot.data![index]);
                              },
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns, // 2 columns
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: 1.6,
                              ),
                            );
                          }
                          else {
                            return Center(child: NoDataWidget(text: Messages.NO_DATA_FOUND,count: getPageRefreshTimes(),));
                          }
                        }
                        else {
                          return Center(child: NoDataWidget(text: Messages.NO_DATA_FOUND,count: getPageRefreshTimes()));
                        }
                      }
                  );
                }).toList(),
                ),

          )),

    ));
  }
  Color getWarningColor(Order order){
    Color barColor = Memory.BAR_BACKGROUND_COLOR;
    switch(order.idOrderStatus){
      case Memory.ORDER_STATUS_CREATE_ID:
        barColor = Colors.red[300]!;
        break;
      case Memory.ORDER_STATUS_PAID_APPROVED_ID:
        barColor = Colors.cyan[300]!;
        break;
      case Memory.ORDER_STATUS_PREPARED_ID:
        barColor = Colors.red[400]!;
        break;
      case Memory.ORDER_STATUS_SHIPPED_ID:
        barColor = Colors.green[600]!;
        break;
      default :
        barColor = Colors.blue[600]!;
        break;
    }
    if(order.isDebitDocument==0){
      barColor = Colors.amber[800]!;
    }

    return barColor;
  }
  Widget cardOrder(BuildContext context, Order order) {


    List<DocumentItem> productMap = order.documentItems ?? [];
    double cardHeight = 246;
    String date = RelativeTimeUtil.getTimeOnStringOnlyDate(order.deliveredTime);
    isDebit = order.isDebitDocument==1;
    Color color = getWarningColor(order);
    return GestureDetector(
      onTap: () => goToOrderDetailPage(order),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            //width:  MediaQuery.of(context).size.width*0.9,
            width: double.infinity,
            height: cardHeight,
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Container(
                      height: 35,
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
                        margin: EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Text('${Messages.ORDER} # ${order.id}',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                                onPressed: () => updateOrderToSettlement(context,order),

                                child: Text(Messages.UPDATE,
                                  style: TextStyle(
                                      color: Colors.amber[800],
                                      fontWeight: FontWeight.bold,
                                      //fontSize: 12,
                                  ),
                                )
                            ),
                            //SizedBox(width: 10,),
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: SingleChildScrollView(
                      child: Form(
                        child: Column(
                            children: [
                              Row(
                                children: [
                                Text('${Messages.DATE} : $date',textAlign: TextAlign.left,),
                                Spacer(),
                                Text(Memory.currencyFormatter.format(isDebit ? order.total :  - order.total!),
                                  style: TextStyle(
                                    color: isDebit ? Colors.black : Colors.redAccent,
                                  ),),
                                ],
                              ),
                                                    
                              ListView.separated(
                                shrinkWrap: true,
                                itemCount: productMap.length,
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(height: 10);
                                },
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Text(getFormattedQuantity(- productMap[index].quantity!),
                                        style: TextStyle(
                                          color: isDebit ? Colors.black : Colors.redAccent,
                                        ),),
                                      SizedBox(width: 8,),
                                      Text('x ${productMap[index].name ?? ''}'),
                                      Spacer(),
                                      Text(Memory.currencyFormatter.format(productMap[index].price),
                                        style: TextStyle(
                                          color: isDebit ? Colors.black : Colors.redAccent,
                                        ),),
                                    ],
                                  );
                                },
                              ),
                              
                            ],
                          ),
                      ),
                    ),

                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }



  dynamic getActionButtons(){
    return <dynamic>[];
  }

  int getTabLength() {
    return 0;
  }

  List<OrderStatus> getOrderStatusList() {
    return <OrderStatus>[];
  }
  Future<List<Order>?> getOrders(BuildContext context, OrderStatus status) async {
    return null;
  }

  void goToOrderDetailPage(Order order) {

  }

  List<Order> getExtractedOrders(){
    return <Order> [];
  }
  double getTotalAmountObsValue(){
    return 0.0;
  }
  int getTotalOrderObsValue(){
    return 0;
  }

  Widget getTitleField() {

    String total = Memory.currencyFormatter.format(getTotalAmountObsValue());

    return  Container(
      margin: EdgeInsets.only(left: 10),
      height: 80,
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          getTitle() =='' ? Container() :Text(getTitle(),style: TextStyle(
          color: colorTextTitle,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),),
          Text("${Messages.TOTAL} : $total",
            style: TextStyle(
              color: colorTextTitle,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),),

          Text("${Messages.ORDERS} : ${getTotalOrderObsValue()}",
            style: TextStyle(
              color: colorTextTitle,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),),
        ],
      ),
    );


  }

  int getPageRefreshTimes() {
    return 1;
  }

  List<Row> getItemsRows(List<DocumentItem>? documentItems) {
    if(documentItems == null || documentItems.isEmpty){
      return <Row>[];
    }
    List<Row> rows = <Row>[];
    for (int i =0; i< documentItems.length ; i++) {
      Row row = Row(
        children: [
          Text('${i+1} _ ${documentItems[i].name ?? ''}'),
          Spacer(),
          Text(Memory.currencyFormatter.format(isDebit ? documentItems[i].quantity! : -documentItems[i].quantity!)),
        ],
      );
      rows.add(row);
    }


    return rows;


  }

  void updateOrderToSettlement(BuildContext context, Order order) {

  }

  String getTitle() { return '';}

  String getFormattedQuantity(double? quantity) {

    if(quantity == null){
      return '    ';
    }
    String res = Memory.numberFormatter.format(quantity);
    if(res.length>=quantityLength){
      return res;
    }
    int add = quantityLength-res.length;
    print(add);
    for(int i=0; i < add ;i++){
      res =' $res';
    }

    return res;
  }

  Widget getBottomSheet() {
    return Container();
  }
}
