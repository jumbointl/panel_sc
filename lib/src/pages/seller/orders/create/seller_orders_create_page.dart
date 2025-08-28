import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/product.dart';
import '../../../../widgets/no_data_widget.dart';
import 'seller_orders_create_controller.dart';

class SellerOrdersCreatePage extends StatelessWidget {

  SellerOrdersCreateController con = Get.put(SellerOrdersCreateController());

  SellerOrdersCreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx (() => SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          height: 120,
          child: _totalToPay(context),
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          title: Text(
            con.clientSociety.name ?? Messages.EMPTY,
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: con.selectedProducts.isNotEmpty
        ? ListView(
          children: con.selectedProducts.map((Product product) {
            int i = con.selectedProducts.indexOf(product);

            return _cardProduct(context,product,i,con.quantityController[i]);
          }).toList(),
        )
        : Center(
            child:
            NoDataWidget(text: Messages.NO_PRODUCT_ADDED_YET)
        ),
      ),
    ));
  }

  Widget _totalToPay(BuildContext context) {
    return Column(
      children: [
        Divider(height: 1, color: Colors.grey[300]),
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 5,right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  '${Messages.TOTAL}: ${Memory.currencyFormatter.format(con.total.value)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              SizedBox(height: 7,),
              Container(
                margin: EdgeInsets.only(left: 20, top: 5, right: 20),

                child: ElevatedButton(

                    onPressed: () => con.goToAddressListPage(),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15),
                        //maximumSize: Size(100.0,37.0),
                    ),
                    child: Text(
                      Messages.CONFIRM_ORDER,
                      style: TextStyle(
                          color: Colors.black
                      ),
                    )
                ),
              )
            ],
          ),
        )

      ],
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
              con.setItem(product, i,s);
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
}
