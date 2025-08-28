import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/pages/seller/orders/return/seller_orders_return_controller.dart';

import '../../../../data/memory.dart';
import '../../../../models/document_item.dart';
import '../../../../widgets/no_data_widget.dart';

class SellerOrdersReturnPage extends StatelessWidget {

  SellerOrdersReturnController con = Get.put(SellerOrdersReturnController());
  RxBool isLoading = false.obs;
  SellerOrdersReturnPage({super.key}){
    isLoading = con.isLoading ;
  }

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
            '${Messages.RETURN}  # ${con.returnOrder.id}',
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
        body: con.selectedDocumentItems.isNotEmpty
        ? ListView(
          children: con.selectedDocumentItems.map((DocumentItem documentItem) {
            int i = con.selectedDocumentItems.indexOf(documentItem);

            return _cardDocumentItem(context,documentItem,i,con.quantityController[i]);
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
                  '${Messages.TOTAL_REFUND}: ${Memory.currencyFormatter.format(con.total.value)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),
              ),
              SizedBox(height: 7,),
              Row(
                children: [

                  isPartialReturn() ?  IconButton(
                    icon: con.isLoading.value
                        ? CircularProgressIndicator(color: Colors.redAccent)
                        : Text(Messages.PARTIAL_RETURN,),
                    onPressed: () => con.isLoading.value ? null : con.updateOrderToPartialReturned(context),
                    tooltip: con.isLoading.value ? Messages.LOADING
                        : Messages.PARTIAL_RETURN,
                    style: IconButton.styleFrom(
                      backgroundColor: con.isLoading.value
                          ? Memory.PRIMARY_COLOR
                          : Memory.BAR_BACKGROUND_COLOR,
                      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                    ),
                  )
                    : Container(),
                  Spacer(),
                    isTotalReturn() ? IconButton(
                      icon: con.isLoading.value
                          ? CircularProgressIndicator(color: Colors.redAccent)
                          : Text(Messages.TOTAL_RETURN),
                      onPressed: () => con.isLoading.value ? null : con.updateOrderToTotalReturned(context),
                      tooltip: con.isLoading.value ? Messages.LOADING
                          : Messages.TOTAL_RETURN,
                      style: IconButton.styleFrom(
                        backgroundColor: con.isLoading.value
                            ? Memory.PRIMARY_COLOR
                            : Memory.BAR_BACKGROUND_COLOR,
                        padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                    )
                  : Container(),

                ],
              )
            ],
          ),
        )

      ],
    );
  }

  Widget _cardDocumentItem(BuildContext context,DocumentItem documentItem, int i,TextEditingController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _imageDocumentItem(documentItem),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                documentItem.name ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
              Text(
                '${Messages.QUANTITY} : ${documentItem.quantity}',
                style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 7),
              _buttonsAddOrRemove(context,documentItem,i,controller)
            ],
          ),
          Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _textPrice(documentItem,i),
              _textSubTotal(documentItem,i),
            ],
          )
        ],
      ),
    );
  }


  Widget _textPrice(DocumentItem documentItem,int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        textAlign: TextAlign.end,
        Memory.currencyFormatter.format(documentItem.price!),
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
  Widget _textSubTotal(DocumentItem documentItem,int i) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Text(
        textAlign: TextAlign.end,
        Memory.currencyFormatter.format(documentItem.price! * documentItem.quantity!),
        style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold
        ),
      ),
    );
  }

  Widget _buttonsAddOrRemove(BuildContext context,DocumentItem documentItem, int i,TextEditingController controller) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => con.removeItem(documentItem,i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              )
            ),

            child: Text('0'),
          ),
        ),
        SizedBox(width: 7,),
        SizedBox(
          width: 100.0,
          height: 37,
        child: GestureDetector(child: TextField(
            onTap: () async {
              String s = await con.getTextFromDialog(context, Messages.QUANTITY);

              con.setItem(documentItem, i ,s);
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
          onTap: () => con.allItem(documentItem,i),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )
            ),
            child: Text('A'),
          ),
        ),
      ],
    );
  }

  Widget _imageDocumentItem(DocumentItem documentItem) {
    return SizedBox(
      height: 70,
      width: 70,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: documentItem.image1 != null
              ? NetworkImage(documentItem.image1!)
              : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
        ),
      ),
    );
  }

  bool isTotalReturn() {
    if (con.total.value == con.returnOrder.total){
      return true;
    } else {
      return false;
    }

  }
  bool isPartialReturn() {
    double? d = double.tryParse(con.total.value.toString());
    if(d==null || con.returnOrder.total == null){
      return false;
    }
    if (d < con.returnOrder.total! && d > 0){
      return true;
    } else {
      return false;
    }

  }
}
