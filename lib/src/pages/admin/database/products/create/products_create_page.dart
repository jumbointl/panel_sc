


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/category.dart';

import 'package:solexpress_panel_sc/src/pages/admin/database/products/create/products_create_controller.dart';
import 'package:solexpress_panel_sc/src/pages/common/active_dropdown.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../common/sql_buttons.dart';

class ProductsCreatePage extends StatelessWidget {
  ProductsCreateController controller = Get.put(ProductsCreateController());
  SqlButtons? buttonBar ;
  late double screenWith  ;

  late double screenHeight;
  final double imageSize = 80;

  ProductsCreatePage({super.key});
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
                  GetBuilder<ProductsCreateController>
                    (builder: (value)=>_imageCard(controller.imageFile1, 1)),
                  SizedBox(width: 10,),
                  GetBuilder<ProductsCreateController>
                    (builder: (value)=>_imageCard(controller.imageFile2, 2)),
                  SizedBox(width: 10,),
                  GetBuilder<ProductsCreateController>
                    (builder: (value)=>_imageCard(controller.imageFile3, 3)),],
              ),
            ),

            //_dropDownSocieties(controller.societies),

            _dropDownActive(ActiveDropdown.activeList),
            buttonBar!.getCompleteBar(context),
            //_buttomBar(context),
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
  Widget _dropDownCategories(List<Category> categories) {
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


  Widget _imageCard(File? image,int index){
      return GestureDetector(
          onTap: (){
            controller.getImage(index);
          },
          child: Card(
            elevation: 3,
            child: Container(
                padding: EdgeInsets.all(10),
                height: imageSize,
                width: imageSize,
                child: image!=null ? Image.file(image,fit: BoxFit.cover,)
                    : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE))
            ),

          )

      )
        
        
        
        ;
  }


  Widget _buttomBar(BuildContext context){
    double iconSize = 36 ;
    double buttomWidth = 50 ;
    double buttomHeight = 50 ;
    double space = 8;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height: buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_FIND),
                iconSize: iconSize,
                onPressed: () {
                  Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_UPDATE),
                iconSize: iconSize,
                onPressed: () {
                  Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_DELITE),
                iconSize: iconSize,
                onPressed: () {
                  Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_CREATE),
                iconSize: iconSize,
                onPressed: () {
                  controller.createWithImage(context);

                },
              )
          ),


        ],
      ),
    );

  }

  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.idController,
        keyboardType: TextInputType.number,
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
