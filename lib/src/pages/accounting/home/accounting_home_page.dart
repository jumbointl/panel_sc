import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../models/society.dart';
import '../../../widgets/no_data_widget.dart';
import 'accounting_home_controller.dart';

class AccountingHomePage extends StatelessWidget {

  AccountingHomeController con = Get.put(AccountingHomeController());

  late double marginsHorizontal;
  RxBool isLoading = false.obs;
  AccountingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    isLoading = con.isLoading ;
    marginsHorizontal = con.getMarginsForMaximumColumns(context);
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          Messages.CLIENT,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions: [
         con.buttonReload(),
          con.buttonUp(),
          con.popUpMenuButton(),
        ],
      ),
      body: GetBuilder<AccountingHomeController> ( builder: (value) => Stack(
        children: [
          _textSelectSociety(),

          _listSociety(context),
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: con.getMaximumInputFieldWidth(context),
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: marginsHorizontal, vertical: 40),
      child: ElevatedButton(
          onPressed: () => con.goToClientOrderList(context),
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15)
          ),
          child: Text(
            Messages.VIEW_TRANSACTIONS,
            style: TextStyle(
                color: Colors.black
            ),
          )
      ),
    );
  }

  Widget _listSociety(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(top: 60),
      child: FutureBuilder(
          future: con.getSocieties(),
          builder: (context, AsyncSnapshot<List<Society>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: marginsHorizontal, vertical: 20),
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
      ),
    );
  }

  Widget _radioSelectorSociety(BuildContext context, Society society, int index) {
    double cWidth = con.getMaximumInputFieldWidth(context)-10;
    return Container(
      width: cWidth,
      //color: (society.defaultSelection==1) ? Colors.lightBlue[100]: Colors.white,
      color: (con.radioValue.value==index) ? Colors.lightBlue[100]: Colors.white,
      margin: EdgeInsets.symmetric(horizontal: 10),
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
                width: cWidth-60,
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
                      style: TextStyle(
                          fontSize: 12
                      ),
                    )
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

  Widget _textSelectSociety() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      alignment: Alignment.topCenter,
      child: con.isLoading.value ? CircularProgressIndicator() : Text(
        con.societyName.value !='' ? con.societyName.value : Messages.SELECT_A_CLIENT,
        style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _iconRefresh() {
    return con.buttonReload();
  }



}
