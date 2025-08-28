import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../models/user.dart';
import 'client_products_detail_controller.dart';

class ClientProductsDetailPage extends StatelessWidget {

  late Product product ;
  late ClientProductsDetailController con;
  var counter = 0.0.obs;
  RxBool paintWithColorWhite =true.obs;
  var price = 0.0.obs;
  String addToCart = Messages.BUY;
  TextEditingController quantityController = TextEditingController();
  double setTo = 1;
  double fontSizeButton = 16;
  double widthButton = 40;
  String tipForPrice = Messages.PRICE_NOT_INCLUDING_VAT;
  User user =  Memory.getSavedUser();
  NumberFormat currencyFormatter = Memory.currencyFormatter;
  NumberFormat numberFormatter = Memory.numberFormatter;
  ClientProductsDetailPage({super.key,
    required this.product,

  }) {
    con = Get.put(ClientProductsDetailController());
    if(user.society?.priceIncludingVat==1){
      tipForPrice = Messages.PRICE_INCLUDING_VAT ;
    }
  }

  @override
  Widget build(BuildContext context) {
    con.checkIfProductsWasAdded(product, price, counter, quantityController,paintWithColorWhite);
    return Obx(() => Scaffold(
        backgroundColor: Memory.PRIMARY_COLOR,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),

          title: SafeArea(
            child: Text(
              product.name ?? '',
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: con.getMaximumInputFieldWidth(context),
                width: double.infinity,

                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  //color: Memory.PRIMARY_COLOR,

                  color: Colors.white,
                  height: 300,
                  width: 300,
                  child: _imageSlideshow(context),

                ),),
              _textDescriptionProduct(),
              _textPriceProduct(),
              _buttonsQuantity(context),
            ],
          ),
        ),
      ),
    );
  }



  Widget _textDescriptionProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Text(
        product.description ?? '',
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }


  Widget _buttonsAddToBag(BuildContext context) {
    return ElevatedButton(
              onPressed: () => con.addToBag(product, price, counter,paintWithColorWhite),
              style: ElevatedButton.styleFrom(
                backgroundColor: paintWithColorWhite.value ? Colors.white : Memory.BAR_BACKGROUND_COLOR,
                minimumSize: Size(260, 37),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                getTotal(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold
                ),
              ),
            );



  }
  Widget _buttonsQuantity(BuildContext context) {

    return Column(
      children: [

        //Divider(height: 1, color: Colors.grey[400]),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10,),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () =>{
                  con.removeItem(product, price, counter,quantityController, paintWithColorWhite,10)

                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    //maximumSize:  Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        )
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
              //Spacer(),
              SizedBox(width: 4,),
              //SizedBox(width: 25,),
              ElevatedButton(
                onPressed: () =>{
                  con.removeItem(product, price, counter,quantityController, paintWithColorWhite,1)

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
                    /*
                    String s = await con.getTextFromDialog(context, Messages.QUANTITY);
                    double? d = double.tryParse(s);
                    if(d!=null && d>0){
                      quantityController.text = s;
                      con.setItem(product, price, counter, quantityController, paintWithColorWhite);
                    } else {
                      con.showErrorMessages(Messages.QUANTITY);
                    }
                    */

                  },
                  /*
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },

                   */
                  textAlign: TextAlign.end,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: Messages.QUANTITY,
                    fillColor: paintWithColorWhite.value ? Memory.BAR_BACKGROUND_COLOR : Colors.white,



                  ),
                  controller: quantityController,
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
                onPressed: () => con.addItem(product, price, counter,quantityController, paintWithColorWhite,1),
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
              SizedBox(width: 4,),
              //Spacer(),
              ElevatedButton(
                onPressed: () => con.addItem(product, price, counter,quantityController, paintWithColorWhite,10),
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
                  '+10',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),

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
                onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  '-100',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSizeButton
                  ),
                ),
              ),
              SizedBox(width: 4,),
              //Spacer(),
              ElevatedButton(
                onPressed: () => con.addItem(product, price, counter,quantityController, paintWithColorWhite,100),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(widthButton, 37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),

                    )
                ),
                child: Text(
                  '+100',
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
        SizedBox(height: 7,),
        _numberButtons(),
        SizedBox(height: 7,),
        _buttonsAddToBag(context),


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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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
                 //onPressed: () => con.removeItem(product, price, counter,quantityController, paintWithColorWhite,100),
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

  Widget _textPriceProduct() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(top: 10, left: 30, right: 30),
      child: Text(
        '${currencyFormatter.format(product.price) } ($tipForPrice)',
        style: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _imageSlideshow(BuildContext context) {


    double width =260;
    return Container(
      margin: EdgeInsets.all(15),
      child: ImageSlideshow(

          width: width, //double.infinity,
          height: width, // MediaQuery.of(context).size.height * 0.4,
          initialPage: 0,
          indicatorColor: Colors.amber,
          indicatorBackgroundColor: Colors.grey,

          children: [
            FadeInImage(
                fit: BoxFit.fitHeight,
                fadeInDuration: Duration(milliseconds: 50),

                placeholder: AssetImage(Memory.IMAGE_NO_IMAGE),
                image: product.image1 != null
                    ? NetworkImage(product.image1!)
                    : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider
            ),
            FadeInImage(
                fit: BoxFit.fitHeight,
                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage(Memory.IMAGE_NO_IMAGE),
                image: product.image2 != null
                    ? NetworkImage(product.image2!)
                    : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider
            ),
            FadeInImage(
                fit: BoxFit.fitHeight,

                fadeInDuration: Duration(milliseconds: 50),
                placeholder: AssetImage(Memory.IMAGE_NO_IMAGE),
                image: product.image3 != null
                    ? NetworkImage(product.image3!)
                    : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider
            ),
          ]
      ),
    );
  }

  String getTotal() {
    if(counter.value==0){
      return Messages.QUANTITY_EQUAL_TO;
    }
    return '$addToCart ${currencyFormatter.format(price.value)}';
  }

  setItemTo() {
    counter.value = setTo;
    quantityController.text = counter.value.toString();
    paintWithColorWhite.value = false ;

  }

  void addQuantityText(int i) {
    String s =  quantityController.text;
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

    double? d = double.tryParse(r);
    print('valor: $r');
    if(d==null || d<=0){
      con.showErrorMessages('${Messages.ERROR}:${Messages.QUANTITY}');
      return;
    }
    counter.value =d ;
    quantityController.text = d.toString();
    paintWithColorWhite.value = false;
    con.setItem(product, price, counter, quantityController, paintWithColorWhite);
  }

   void setQuantityEmpty() {
     counter.value = 0 ;
     quantityController.text = '';
     paintWithColorWhite.value = true;
   }

}
