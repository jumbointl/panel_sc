import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/address.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_address_list_controller.dart';

class ClientAddressListPage extends StatelessWidget {

  ClientAddressListController con = Get.put(ClientAddressListController());

  ClientAddressListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      bottomNavigationBar: _buttonNext(context),
      appBar: AppBar(
        backgroundColor: con.isDebitTransaction.value ? Memory.COLOR_IS_DEBIT_TRANSACTION
            : Memory.COLOR_IS_CREDIT_TRANSACTION,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          con.clientSociety.name ?? Messages.EMPTY,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions: [
          _iconAddressCreate()
        ],
      ),
      body: GetBuilder<ClientAddressListController> ( builder: (value) => Stack(
        children: [
          _textSelectAddress(),
          con.isLoading.value ? CircularProgressIndicator(): _listAddress(context)
        ],
      )),
    );
  }

  Widget _buttonNext(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
      child: IconButton(
        icon: con.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.CREATE_ORDER),
        onPressed: () => con.isLoading.value ? null : con.createOrder(context),
        tooltip: con.isLoading.value ? Messages.LOADING
            : Messages.CREATE_ORDER,
        style: IconButton.styleFrom(
          backgroundColor: con.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        ),
      ),
    );
  }

  Widget _listAddress(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      child: FutureBuilder(
          future: con.getAddresses(),
          builder: (context, AsyncSnapshot<List<Address>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    itemBuilder: (_, index) {
                      return _radioSelectorAddress(context,snapshot.data![index], index);
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

  Widget _radioSelectorAddress(BuildContext context, Address address, int index) {
    double cWidth = MediaQuery.of(context).size.width*0.6;

    return Container(
      width: cWidth,
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
                      address.address?.toUpperCase() ?? '',
                      style: TextStyle(
                          color: (address.defaultSelection==1) ? Colors.blue[700]: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      address.neighborhood ?? '',
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

  Widget _textSelectAddress() {
    return Container(
      margin: EdgeInsets.only(top: 30, left: 30, right: 30),
      alignment: Alignment.topCenter,
      child: Text(
        con.addressName.value=='' ? Messages.CHOOSE_WHERE_TO_RECEIVE_YOUR_ORDER
            : con.addressName.value,
        style: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _iconAddressCreate() {
    return IconButton(
        onPressed: () => con.goToAddressCreate(),
        icon: Icon(
          Icons.add,
          color: Colors.black,
        )
    );
  }


}
