import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/order.dart';
import '../../models/user.dart';
import '../../utils/relative_time_util.dart';
import '../../widgets/no_data_widget.dart';
abstract class OrderListPageModel extends StatelessWidget  {
  double imageHeight = 60;
  double imageWidth = 60;
  double screenWidth = 0;
  double screenHeight = 0;
  double columnsWidth = 0;
  bool isWideScreen = false;
  int columns = 1;
  bool isPortrait = true;
  double ratio = 2;
  late Color appBarColor;
  Color cardColor = Colors.white;
  Color backGroundColor = Memory.SCAFFOLD_BACKGROUND_COLOR;
  Color cardFontColor = Colors.black;
  double cardHeight = 140;
  late RxStatus pageStatus ;
  RxBool isLoading = false.obs;

  late User userSession;


  OrderListPageModel({super.key}) {
    userSession = Memory.getSavedUser();
    if(userSession.roles !=null && userSession.roles![0].id !=null &&
        userSession.roles![0].id == Memory.ROL_WAREHOUSE.id){
      cardColor = Colors.white;
      cardFontColor = Colors.black;
      backGroundColor = Colors.black;
    } else {
      cardColor = Colors.white;
      cardFontColor = Colors.black;

    }

  }

  @override
  Widget build(BuildContext context) {
    pageStatus = getPageStatus();

    appBarColor = getAppBarColor(context);
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
    ratio = columnsWidth/cardHeight;

    return Obx(() =>DefaultTabController(

      length: getTabLength(),
      child: Scaffold(

          appBar: AppBar(
            title: getAppBarTitle(),
            elevation: 0,
            backgroundColor: getAppBarColor(context),
            automaticallyImplyLeading: false,
            actions: getActionButtons(),

            bottom: TabBar(
                tabAlignment: TabAlignment.center,
                isScrollable: true,
                indicatorColor: Memory.BAR_BACKGROUND_COLOR,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                tabs: List<Widget>.generate(getTabLength(), (index) {
                  return Tab(child: Text(getOrderStatusList()[index].name ??
                      ''),);
                })),
          ),
          bottomSheet: Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            //color: Memory.BAR_BACKGROUND_COLOR,
            height: 80,
            width: 250,
            child:Obx(()=> getBottomSheetPortrait()),
          ),
          body: SafeArea(

            child: isLoading.value ? CircularProgressIndicator() : TabBarView(
              children: getOrderStatusList().map((OrderStatus status) {
                return FutureBuilder(
                    future: getOrders(context, status),
                    builder: (context,
                        AsyncSnapshot<List<Order>?> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            color: backGroundColor,
                            child: GridView.builder(
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5,
                                childAspectRatio: ratio,
                              ),
                              itemCount: snapshot.data?.length ?? 0,
                              itemBuilder: (_, index) {
                                return cardOrder(
                                    context, snapshot.data![index]);
                              },

                            ),
                          );
                        }
                        else {
                          return Center(child: NoDataWidget(
                            text: Messages.NO_DATA_FOUND,
                            count: getPageRefreshTimes(),));
                        }
                      }
                      else {
                        return Center(child: NoDataWidget(
                            text: Messages.NO_DATA_FOUND,
                            count: getPageRefreshTimes()));
                      }
                    }
                );
              }).toList(),
            ),

          )),

    ));
  }
  Color getWarningColor(Order order) {
    Color barColor = Colors.purple;
    if (order.idOrderStatus == null){
      return barColor;
    }
    int days = RelativeTimeUtil.differenceToToday(DateTime.parse(order.deliveredTime ?? ''));


    if(days<0){
      return Colors.white;
    }

    switch(order.idOrderStatus){
      case Memory.ORDER_STATUS_CREATE_ID:
        barColor = Colors.red[300]!;
        print(1);
        break;
      case Memory.ORDER_STATUS_PAID_APPROVED_ID:
        barColor = Colors.cyan[300]!;
        print(2);
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
    return barColor;
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
    Color color = getWarningColor(order) ?? Colors.purple;
    return GestureDetector(
      onTap: () => goToOrderDetailPage(order),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: cardHeight,
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10),
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Container(

                      height: 30,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color,
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

                    margin: EdgeInsets.only(top: 35, left: 10, right: 10,bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: cardColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 5,left: 5,right: 5),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: Text('${Messages.DATE} : $date',textAlign: TextAlign.left,
                            style: TextStyle(
                              color: cardFontColor,
                            ),)),
                        //Text(order.timeStamp ?? ''),
                        Container(
                          margin: EdgeInsets.only(top: 5,left: 5,right: 5),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: RichText(
                            text: TextSpan(
                              text: society,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: cardFontColor,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: '  ($client)', style: TextStyle(
                                    color: cardFontColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5,left: 5,right: 5),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: Text(order.address !=null ? order.address!.address ?? '' : '',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: cardFontColor,
                            ),),
                        ),
                      ],
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

  Widget getBottomSheetLandscape() {

    String total = Memory.currencyFormatter.format(getTotalAmountObsValue());

    return  isLoading.value ? CircularProgressIndicator() : Container(
      margin: EdgeInsets.only(bottom: 10),
      height: 35,
      width: double.infinity,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text("${Messages.TOTAL} : $total",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),),
          SizedBox(width: 100,),
          //Text("${Messages.ORDERS} : ${getTotalOrderObsValue()} - ${screenWidth.round()} - ${screenHeight.round()}",
          Row(
            children: [
              Text("${Messages.ORDERS} : ${getTotalOrderObsValue()}}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),),
              Spacer(),
              getBottomActionButton(),
            ],
          ),
        ],
      ),
    );


  }

  Widget getBottomSheetPortrait() {

    String total = Memory.currencyFormatter.format(getTotalAmountObsValue());

    return isLoading.value ? CircularProgressIndicator() : Container(
      //margin: EdgeInsets.only(bottom: 5),
      width: screenWidth/2,
      //height: 55,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text("${Messages.TOTAL} : $total",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),),

          Row(
            children: [
              //Text("${Messages.ORDERS} : ${getTotalOrderObsValue()} - ${screenWidth.round()} - ${screenHeight.round()}",
              Text("${Messages.ORDERS} : ${getTotalOrderObsValue()}",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),),
              Spacer(),
              getBottomActionButton(),
            ],
          ),
        ],
      ),
    );


  }


  int getPageRefreshTimes() {
    return 1;
  }

  String getTitle() { return '';}

  Widget getBottomActionButton() {
    return Container();
  }

  Widget getAppBarTitle() {

    return Text(userSession.name ?? '');
  }

  Color getAppBarColor(BuildContext context) {
    return Colors.cyan[300]!;
  }

  RxStatus getPageStatus() {
    return  RxStatus.empty();
  }
}
