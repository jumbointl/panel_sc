import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import '../../../data/memory.dart';
import '../../../models/product.dart';
import '../../../models/user.dart';
import 'invoice_number_controller.dart';

class InvoiceNumberPage extends StatelessWidget {

  Product? invoiceNumber ;
  late InvoiceNumberController con;

  int setTo = 1;


  String invoice = Messages.INVOICE;


  double fontSizeButton = 16;
  double widthButton = 37;
  User user =  Memory.getSavedUser();


  InvoiceNumberPage({super.key}) {
    con = Get.put(InvoiceNumberController());

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: Memory.PRIMARY_COLOR,
        appBar: AppBar(
          automaticallyImplyLeading: true,
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

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10,),
                _buttonsDate(context),
                SizedBox(height: 10,),
                _buttonsInvoiceBranch(context),
                SizedBox(height: 10,),
                _buttonsInvoiceCashRegister(context),
                SizedBox(height: 10,),
                _buttonsInvoiceNumber(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonsReturnInvoiceNumber(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 25,),
          ElevatedButton(
            onPressed: () =>con.updateOrderStatusToDeliveredwithInvoice(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: con.paintWithColorWhite.value ? Colors.white : Memory.BAR_BACKGROUND_COLOR,
              minimumSize: Size(270, 37),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              getInvoiceNumber(),
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          //SizedBox(width: 7,),

        ],
      );
  }
  Widget _buttonsDate(BuildContext context) {

    return Container(
          margin: EdgeInsets.only(left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Messages.DATE),
              SizedBox(width: 10,),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.36,
                //height: 37,
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
                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: Messages.DATE,
                    fillColor: con.paintWithColorWhite.value ? Memory.BAR_BACKGROUND_COLOR : Colors.white,
                  ),
                  controller:  con.dateController,
                  keyboardType: TextInputType.none,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20
                  ),
                ),
              ),

            ],
          ),
        );

  }
  Widget _buttonsInvoiceBranch(BuildContext context) {

    return Container(
          margin: EdgeInsets.only(left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text(Messages.BRANCH),
            SizedBox(width: 10,),

              ElevatedButton(
                onPressed: () =>{
                  con.removeItem( con.branch,con.branchController,1)

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '-',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.22,
                height: 37,
                child: TextField(
                  onTap: () async {
                    //String s = await con.getTextFromDialog(context, Messages.BRANCH);
                    //con.setItem(con.branch, con.branchController);
                  },
                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: Messages.BRANCH,
                    fillColor: con.paintWithColorWhite.value ? Memory.BAR_BACKGROUND_COLOR : Colors.white,



                  ),
                  controller:  con.branchController,
                  keyboardType: TextInputType.none,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              SizedBox(width: 4,),
              ElevatedButton(
                onPressed: () => con.addItem( con.branch, con.branchController,1),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '+',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
            ],
          ),
        );
  }
  Widget _buttonsInvoiceCashRegister(BuildContext context) {

    return Container(
          margin: EdgeInsets.only(left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(Messages.CASH_REGISTER),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () =>{
                  con.removeItem( con.cashRegister, con.cashRegisterController,1)

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '-',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.22,
                height: 37,
                child: TextField(
                  onTap: () async {
                    //String s = await con.getTextFromDialog(context, Messages.CASH_REGISTER);
                    //con.setItem(con.cashRegister, con.cashRegisterController);

                  },

                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: Messages.CASH_REGISTER,
                    fillColor: con.paintWithColorWhite.value ? Memory.BAR_BACKGROUND_COLOR : Colors.white,



                  ),
                  controller:  con.cashRegisterController,
                  keyboardType: TextInputType.none,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              ElevatedButton(
                onPressed: () => con.addItem( con.cashRegister, con.cashRegisterController, 1),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '+',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
            ],
          ),
        );
  }
  Widget _buttonsInvoiceNumber(BuildContext context) {

    return Column(
      children: [

        Container(
          margin: EdgeInsets.only(left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Messages.NUMBER),
              SizedBox(width: 10,),
              ElevatedButton(
                onPressed: () =>{
                  con.removeItem( con.number, con.numberController,1)

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '-',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              SizedBox(
                width: MediaQuery.of(context).size.width*0.4,
                height: 37,
                child: TextField(
                  onTap: () async {
                    //String s = await con.getTextFromDialog(context, Messages.NUMBER);
                    con.setItem(con.number, con.numberController);


                  },

                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: Messages.NUMBER,
                    fillColor: con.paintWithColorWhite.value ? Memory.BAR_BACKGROUND_COLOR : Colors.white,
                  ),
                  controller:  con.numberController,
                  keyboardType: TextInputType.none,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                  ),
                ),
              ),
              SizedBox(width: 4,),
              ElevatedButton(
                onPressed: () => con.addItem( con.number, con.numberController,1),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        )
                    )
                ),
                child: Text(
                  '+',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),


            ],
          ),
        ),
        //SizedBox(height: 7,),
        Container(

          margin: EdgeInsets.only(top:10, left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ElevatedButton(
                onPressed: () =>{
                    setItemTo()
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  '=$setTo',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),

              //Spacer(),
              SizedBox(width: 4,),
              //Spacer(),
              ElevatedButton(
                onPressed: () => con.removeItem(   con.number, con.numberController ,10),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  '-10',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              ElevatedButton(
                onPressed: () => con.addItem(   con.number, con.numberController ,10),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  '+10',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),

              ElevatedButton(
                onPressed: () => setQuantityEmpty(),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  Messages.CLEAR,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton-4
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10,),
        _numberButtons(),
        SizedBox(height: 50,),
        _buttonsReturnInvoiceNumber(context),


      ],
    );
  }
  Widget _numberButtons(){
     double widthButton = 20 ;
     return Container(

       margin: EdgeInsets.only(left: 10, right: 10,),
       child: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
               onPressed: () => addQuantityText(0),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '0',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(1),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '1',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(2),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '2',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(3),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '3',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(4),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '4',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),

             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [



               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(5),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '5',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(6),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '6',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(7),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '7',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(8),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '8',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
               SizedBox(width: 5,),
               //Spacer(),
               ElevatedButton(
                 //onPressed: () => con.removeItem(product!, price, counter,quantityController ,100),
                 onPressed: () => addQuantityText(9),
                 style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.white,
                     minimumSize: Size(widthButton, 37),
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(5),

                     )
                 ),
                 child: Text(
                   '9',
                   style: TextStyle(
                       color: Colors.black,
                       fontSize: fontSizeButton
                   ),
                 ),
               ),
             ],
           ),

         ],
       ),
     );


  }

  void addQuantityText(int i) {
    String s =   con.numberController.text;
    String s1 = s;
    String s2 ='';
    if(s.contains('.')) {
      s1 = s.split('.').first;
      s2 = s.split('.').last;
    }

    String r ='';
    if(s.contains('.')){
      r='$s1$i.$s2';
    } else {
      r='$s1$i';
    }

    int? d = int.tryParse(r);
    print('valor: $r');
    if(d==null || d<=0){
      con.showErrorMessages('${Messages.ERROR}:${Messages.QUANTITY}');
      return;
    }
    con.number.value =d ;
     con.numberController.text = d.toString();
    con.paintWithColorWhite.value = false;
    con.setItem( con.number,  con.numberController );
  }

   void setQuantityEmpty() {
     con.number.value = 0 ;
      con.numberController.text = '';
     con.paintWithColorWhite.value = true;
   }
  setItemTo() {
    con.number.value = setTo;
     con.numberController.text = con.number.value.toString();
    con.paintWithColorWhite.value = false ;

  }

  String getInvoiceNumber() {
    return '${Messages.INVOICE} # ${con.invoiceNumberString}';
  }
}
