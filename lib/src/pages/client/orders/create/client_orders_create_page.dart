import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../widgets/no_data_widget.dart';
import 'client_orders_create_controller.dart';

class ClientOrdersCreatePage extends StatelessWidget {
  RxBool isLoading = false.obs;
  ClientOrdersCreateController con = Get.put(ClientOrdersCreateController());

  ClientOrdersCreatePage({super.key}) {
     isLoading = con.isLoading;

  }

  @override
  Widget build(BuildContext context) {
    return Obx (() => Scaffold(
        bottomNavigationBar: Container(
          color: getColor(con.colorButtonPanel.value),
          height: 160,
          child: _totalToPay(context),
        ),
        appBar: AppBar(
          centerTitle: true,
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
          //bottom: _buttonsDate(context),
        ),
        
        body: con.selectedProducts.isNotEmpty
        ? SafeArea(
          child: Container(
            child: Form(
              child: ListView(
                children: con.selectedProducts.map((Product product) {
                  int i = con.selectedProducts.indexOf(product);

                  return _cardProduct(context,product,i,con.quantityController[i]);
                }).toList(),
              ),
            ),
          ),
        )
        : SafeArea(
          child: Center(
              child:
              NoDataWidget(text: Messages.NO_PRODUCT_ADDED_YET)
          ),
        ),
      ),
    );
  }

  Widget _totalToPay(BuildContext context) {
    return  Container(
          //color: con.colorButtonPanel,
          margin: EdgeInsets.only(left: 20, right: 20,top: 10,bottom: 10),
          child: Column(
            spacing: 5,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '${Messages.TOTAL}: ${Memory.currencyFormatter.format(con.total.value)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              _buttonsDate(context),
              ElevatedButton(

                  onPressed: () => con.goToAddressListPage(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:  con.isDebitTransaction.value ? Memory.COLOR_IS_DEBIT_TRANSACTION
                          : Memory.COLOR_IS_CREDIT_TRANSACTION,
                      padding: EdgeInsets.all(15),
                      //maximumSize: Size(100.0,37.0),
                  ),
                  child: Text(
                    con.isDebitTransaction.value ? Messages.CONFIRM_ORDER : Messages.RETURNS ,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  )
              )
            ],
          ),
        );

  }

  Widget _cardProduct(BuildContext context,Product product, int i,TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageProduct(product),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              _buttonsAddOrRemove(context,product,i,controller)
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _textPrice(product,i),
              _textSubTotal(product,i),
              _iconDelete(product,i)
            ],
          )
        ],
      ),
    );
  }

  Widget _iconDelete(Product product,int i) {
    return IconButton(
        onPressed: () => con.deleteItem(product,i),
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        )
    );
  }

  Widget _textPrice(Product product,int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        textAlign: TextAlign.end,
        Memory.currencyFormatter.format(product.price!),
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _textSubTotal(Product product,int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        textAlign: TextAlign.end,
        Memory.currencyFormatter.format(product.price! * product.quantity!),
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buttonsAddOrRemove(BuildContext context,Product product, int i,TextEditingController controller) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => con.removeItem(product,i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              )
            ),

            child: Text('-'),
          ),
        ),
        SizedBox(width: 7,),
        SizedBox(
          width: 100.0,
          height: 37,
        child: GestureDetector(child: TextField(
            onTap: () async {
              String s = await con.getTextFromDialog(context, Messages.QUANTITY);
              double? d = double.tryParse(s);
              if(d!=null && d>0){
                con.setItem(product, i,s);
                con.showSuccessMessages(Messages.QUANTITY);

              } else {
                con.showErrorMessages(Messages.QUANTITY);
              }
            },

            readOnly: true,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              filled: true,
              hintText: Messages.QUANTITY,
              fillColor: Colors.white,


            ),
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(
                color: Colors.black,
                fontSize: 18
            ),
          )),
        ),
        SizedBox(width: 7,),
        GestureDetector(
          onTap: () => con.addItem(product,i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
            ),
            child: Text('+'),
          ),
        ),
      ],
    );
  }

  Widget _imageProduct(Product product) {
    return SizedBox(
      height: 70,
      width: 70,
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
  Widget _buttonsDate(BuildContext context) {

    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(con.isDebitTransaction.value ? Messages.DELIVER : Messages.DATE),
        SizedBox(
          width: 100,
          height: 30,

          child: TextField(
                onTap: () async {
                  final date = await showDatePickerDialog(
                    context: context,
                    minDate: con.minDay,
                    maxDate: con.maxDay,
                    initialDate: con.date.value,
                    selectedDate: con.date.value,
                  );
                  con.setDate(date);
                },
                textAlign: TextAlign.center,
                //textAlignVertical: TextAlignVertical.center,
                readOnly: true,

                decoration: InputDecoration(
                  //filled: true,
                  fillColor: Colors.amber[200],

                  hintText: con.isDebitTransaction.value ? Messages.DELIVERY_DATE : Messages.DATE,
                  //border: OutlineInputBorder(),
                ),


                controller:  con.dateController,
                keyboardType: TextInputType.none,
                style: TextStyle(
                    color: Colors.black,

                    fontSize: 14.5
                ),
              ),
        ),
        if(con.isDebitTransaction.value) SizedBox(width: 5,),
        if(con.isDebitTransaction.value) Text('${Messages.DELIVERED}?'),
        if(con.isDebitTransaction.value) Checkbox(
          value: con.deliveredOrder.value,
          onChanged: (bool? newValue) {
            if(!con.showDeliveredOption.value){
              return;
            }

            if(newValue!=null){
              con.setIsDeliveredOrder(newValue);

            }
          },
        ),
      ],
    );

  }

  Color getColor(int value) {
    if(con.deliveredOrder.value){
      return Colors.cyan[200]!;
    }
    if(value==0){
     return Colors.white;
    } else if(value>0){
      return Colors.cyan[200]!;
    } else {
      return Colors.purple[200]!;
    }
  }
}
