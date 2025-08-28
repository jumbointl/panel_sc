



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/category.dart';

import 'package:solexpress_panel_sc/src/pages/admin/database/products/handling/products_handling_controller.dart';
import 'package:solexpress_panel_sc/src/pages/common/active_dropdown.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/product.dart';
import '../../../../common/sql_buttons.dart';

class ProductsHandlingPage extends StatelessWidget {
  ProductsHandlingController controller = Get.put(ProductsHandlingController());
  SqlButtons? buttonBar ;
  late double screenWith  ;

  late double screenHeight;
  final double imageSize = 80;

  Color barColor = Colors.amber;
  Color resultColor = Colors.lightBlue;
  Color dropDownColor = Colors.lightGreen;

  ProductsHandlingPage({super.key});
  @override
  Widget build(BuildContext context) {

    buttonBar = SqlButtons();
    buttonBar!.setController(controller);
    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Obx(()=>Stack(
        //alignment: Alignment.topCenter,
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textInfo(),
          _buttomBack(),
        ],
      )),
    );
  }
  Widget _buttomBack(){
    return SafeArea(child: Container(
      margin: EdgeInsets.only(top: 10, left: 20),

      child: IconButton(onPressed: ()=>Get.back(),
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }

  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.87,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1,
          left: 20,right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75),
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textFieldFindProductByName(),
            buttonBar!.getEditBar(context),
            _dropDownProducts(controller.productsList),
            _textFieldId(),
            _textFieldName(),
            _textFieldBarcode(),
            _textFieldDescription(),
            _dropDownCategories(controller.categories),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GetBuilder<ProductsHandlingController>
                    (builder: (value)=>_imageCard1()),
                  SizedBox(width: 10,),
                  GetBuilder<ProductsHandlingController>
                    (builder: (value)=>_imageCard2()),
                  SizedBox(width: 10,),
                  GetBuilder<ProductsHandlingController>
                    (builder: (value)=>_imageCard3()),],
              ),
            ),
            _dropDownActive(ActiveDropdown.activeList),
          ],
        ),

      ),

    );

  }
  Widget _backgroundCover(BuildContext context){

    return SafeArea(
      child: Container(
        //alignment: Alignment.topCenter,
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.30,
        color: Memory.PRIMARY_COLOR,

      ),
    );
  }
  Widget _textFieldFindProductByName(){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(left: 10,right: 10, top: 10, bottom: 10),
      child: TextField(
        controller: controller.findByProductNameController,
        keyboardType: TextInputType.text,
        //maxLength: 20,
        decoration: InputDecoration(
          hintText: Messages.TIPS_FIND_BY_PRODUCT,
          fillColor: barColor,
          prefixIcon: Icon(Icons.data_object),
        ),
      ),
    );
  }


  Widget _dropDownProducts(List<Product> products) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
      decoration: BoxDecoration(
        color:  controller.productsListIsEmpty ? Colors.white : resultColor ,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(

        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color:Colors.black,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.NO_DATA_FOUND,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownProductsItems(products),
        value: controller.idProduct.value == '' ? null : controller.idProduct.value,
        onChanged: (option) {
          int? id = int.tryParse(option.toString());
          if(id!=null && id>0){
            Product? data = controller.getProductById(controller.productsList, id);
            if(data!=null){
              controller.setDatas(data);
            }

          }
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownProductsItems(List<Product> datas) {
    List<DropdownMenuItem<String>> list = [];
    for (var product in datas) {
      list.add(DropdownMenuItem(

        value: product.id.toString(),
        child: Text(product.name ?? ''),
      ));
    }

    return list;
  }
  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
      decoration: BoxDecoration(
        color:  controller.categories.isEmpty ? Colors.white : resultColor ,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_AN_OPTION,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownCategoriesItems(categories),
        value: controller.idCategory.value == '' ? null : controller.idCategory.value,
        onChanged: (option) {
          // print('Opcion categoria seleccionada ${option}');
          controller.idCategory.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownCategoriesItems(List<Category> categories) {
    List<DropdownMenuItem<String>> list = [];
    for (var category in categories) {
      list.add(DropdownMenuItem(
        value: category.id.toString(),
        child: Text(category.name ?? ''),
      ));
    }

    return list;
  }
  Widget _dropDownActive(List<Active>  list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.amber,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_AN_OPTION,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownActiveItems(list),
        value: controller.isActive.value == '' ? null : controller.isActive.value ,

        onChanged: (option) {
          //print('Opcion seleccionada ${option}');
          controller.isActive.value = option.toString() ;
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownActiveItems(List<Active> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(

        value: data.active.toString(),

        child: Text(data.name ?? ''),

      ));
    }

    return list;
  }

  Widget _imageCard1(){

    return GestureDetector(

        onTap: (){
          controller.getImage(1);
        },
        child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.all(10),
              height: imageSize,
              width: imageSize,
              child:  controller.imageFile1!=null ? Image.file(controller.imageFile1!,fit: BoxFit.cover,)
                  : controller.productSelected.image1 != null ? Image.network(controller.productSelected.image1!,fit: BoxFit.cover,)
                  : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE))
          ),

        )

    );
  }
  Widget _imageCard2(){
    return GestureDetector(
        onTap: (){
          controller.getImage(2);
        },
        child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.all(10),
              height: imageSize,
              width: imageSize,
              child:  controller.imageFile2!=null ? Image.file(controller.imageFile2!,fit: BoxFit.cover,)
                  : controller.productSelected.image2 != null ? Image.network(controller.productSelected.image2!,fit: BoxFit.cover,)
                  : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE))
          ),

        )

    );
  }

  Widget _imageCard3(){
      return GestureDetector(
          onTap: (){
            controller.getImage(3);
          },
          child: Card(
            elevation: 3,
            child: Container(
                padding: EdgeInsets.all(10),
                height: imageSize,
                width: imageSize,
                child:  controller.imageFile3!=null ? Image.file(controller.imageFile3!,fit: BoxFit.cover,)
                    : controller.productSelected.image3 != null ? Image.network(controller.productSelected.image3!,fit: BoxFit.cover,)
                    : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE))
            ),

          )

      );
  }


  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.idController,
        keyboardType: TextInputType.number,
        readOnly: true,
        decoration: InputDecoration(
          hintText: Messages.ID,
          prefixIcon: Icon(Icons.card_membership),
        ),
      ),
    );
  }
  Widget _textFieldName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.NAME,
          prefixIcon: Icon(Icons.category),
        ),
      ),
    );
  }
  Widget _textFieldDescription(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.descriptionController,
        keyboardType: TextInputType.text,
        maxLength: 255,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: Messages.DESCRIPTION,
          prefixIcon: Icon(Icons.card_membership),
        ),
      ),
    );
  }
  Widget _textFieldBarcode(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.barcodeController,
        keyboardType: TextInputType.text,
        //maxLength: 255,
        //maxLines: 4,
        decoration: InputDecoration(
          hintText: Messages.BARCODE,
          prefixIcon: Icon(Icons.barcode_reader),
        ),
      ),
    );
  }


  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 20),
        alignment: Alignment.topCenter,
        child: Text(Memory.PRODUCTS,
          style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ))
    );

  }


}
