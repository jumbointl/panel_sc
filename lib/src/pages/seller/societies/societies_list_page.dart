
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/pages/seller/societies/societies_list_controller.dart';

import '../../../data/memory.dart';
import '../../../models/society.dart';
import '../../../widgets/no_data_widget.dart';

class SocietiesListPage extends StatelessWidget {

  SocietiesListController con = Get.put(SocietiesListController());

  late double  marginsHorizontal;

  SocietiesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    bool isPortrait =  MediaQuery.of(context).orientation == Orientation.portrait;
    bool isWideScreen = false;
    if(screenWidth>=Memory.minimumWideScreenWidth){
      isWideScreen = true;
    }

    marginsHorizontal = 5;
    marginsHorizontal = con.getMarginsForMaximumColumns(context) ;

    return  Obx(()=>Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        backgroundColor: con.isDebitTransaction.value ? Memory.COLOR_IS_DEBIT_TRANSACTION
            : Memory.COLOR_IS_CREDIT_TRANSACTION,

        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        centerTitle: true,
        title: Text(con.getSavedClientSociety().name ?? ''),
        actions: [
          con.buttonReload(),
          con.buttonBack(),
          con.popUpMenuButton(),
        ],
      ),
      body: GetBuilder<SocietiesListController> ( builder: (value) =>FutureBuilder(
          future: con.getSocieties(),
          builder: (context, AsyncSnapshot<List<Society>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: marginsHorizontal-10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorSociety(context,snapshot.data![index], index);
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
      ),),
    ));
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: con.isDebitTransaction.value ? Memory.COLOR_IS_DEBIT_TRANSACTION
          : Memory.COLOR_IS_CREDIT_TRANSACTION,
      width: double.infinity,
      height: 100,
      child: Column(
        spacing: 5,
        children: [
          _getIsDebitTransaction(context),
          IconButton(
            icon: con.isLoading.value
                ? CircularProgressIndicator(color: Colors.redAccent)
                : con.isDebitTransaction.value ? Text(Messages.CREATE_ORDER):Text(Messages.RETURNS),
            onPressed: () => con.isLoading.value ? null : con.createOrder(context),
            tooltip: con.isLoading.value ? Messages.LOADING
                : con.isDebitTransaction.value ? Messages.CREATE_ORDER : Messages.RETURNS,
            style: IconButton.styleFrom(
              backgroundColor: con.isLoading.value
                  ? Memory.PRIMARY_COLOR
                  : Memory.BAR_BACKGROUND_COLOR,
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }



  Widget _radioSelectorSociety(BuildContext context, Society society, int index) {
    double cWidth = con.getMaximumInputFieldWidth(context)-20;
    String aux1 = society.configuration?.name ?? '';
    String aux2 = '${society.configuration?.commission ?? ''}';
    String aux ='$aux1  commission : $aux2';

    return Container(
      alignment: Alignment.topCenter,
      width: cWidth,
      //color: (society.defaultSelection==1) ? Colors.lightBlue[100]: Colors.white,
      color: (con.radioValue.value==index) ? Colors.lightBlue[100]: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: index,
                groupValue: con.radioValue.value,
                onChanged: con.handleRadioValueChange,
              ),
              SizedBox(
                width: cWidth -20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      society.name?.toUpperCase() ?? '',
                      style: TextStyle(
                          color: (index==society.id) ? Colors.blue[700]: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      society.taxId ?? '',
                      //aux,
                      style: TextStyle(
                          fontSize: 12
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

    );
  }

  Widget _textSelectSociety() {
    return con.isLoading.value ? CircularProgressIndicator() : Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      alignment: Alignment.topCenter,
      child: Text(
        con.societyName.value !='' ? con.societyName.value : Messages.SELECT_A_CLIENT,
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }


  Widget _getIsDebitTransaction(BuildContext context){
    return con.isLoading.value ? CircularProgressIndicator() : PreferredSize(
      preferredSize: Size.fromHeight(14),

      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerLeft,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              width: 155,
              height: 25,

              child: Row(
                children: [
                  Checkbox(
                    value: con.isDebitTransaction.value,
                    onChanged: (bool? newValue) {
                      if(newValue!=null){
                        con.setIsDebitTransaction(newValue);
                      }
                    },
                  ),
                  SizedBox(width: 6,),
                  Text(con.isDebitTransaction.value ? Messages.SELL :
                     Messages.RETURNS,style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),),
                ],
              ),
            ),

          ],
        ),
      ),
    );

  }

}
