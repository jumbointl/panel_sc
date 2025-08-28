


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/admin/database/categories/create/categories_create_controller.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/vat.dart';

class CategoriesCreatePage extends StatelessWidget {
  CategoriesCreateController controller = Get.put(CategoriesCreateController());

  CategoriesCreatePage({super.key});
  late double screenWith  ;

  late double screenHeight;
  final double imageSize = 80;

  @override
  Widget build(BuildContext context) {

    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Obx(()=>Stack(
        //alignment: Alignment.topCenter,
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textInfo(),
          _bottomBack(),

        ],
      )),
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
  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.75,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.13,
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
            _textFieldDescription(),
            GetBuilder<CategoriesCreateController>
              (builder: (value)=>_imageCard(controller.imageFile)),
            _dropDownVats(),
            _dropDownActive(controller.activeList),
            _buttomCreate(context),
            _buttomClear(context),
          ],
        ),

      ),

    );

  }
  Widget _dropDownVats() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 10),
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
          Messages.SELECT_A_VAT,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsVats(controller.vatsList),
        value: controller.idVat.value == '' ? null : controller.idVat.value,
        onChanged: (option) {
          controller.idVat.value = option.toString();
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsVats(List<Vat> vats) {
    List<DropdownMenuItem<String>> list = [];
    for (var vat in vats) {
      list.add(DropdownMenuItem(
        value: vat.id.toString(),
        child: Text(vat.name ?? ''),
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

  Widget _bottomBack(){
    return SafeArea(child: Container(
      margin: EdgeInsets.only(top: 10, left: 20),

      child: IconButton(onPressed: ()=>Get.back(),
        icon: Icon(Icons.arrow_back_ios,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }
  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
  Widget _buttomCreate(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: ElevatedButton(onPressed: ()=> controller.createWithImage(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:Memory.PRIMARY_COLOR,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(Messages.DATA_CREATE,
            style: TextStyle(color: Colors.black),
          )),
    );

  }
  Widget _buttomClear(BuildContext context){
    double iconSize = 24 ;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: IconButton(
        icon: Image.asset(Memory.IMAGE_REFRESH),
        iconSize: iconSize,
        onPressed: () {
          controller.clearForm();

        },
      ),
    );

  }


  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 20),
        alignment: Alignment.topCenter,
        child: Text(Memory.CATEGORIES,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ))
    );
  }
  Widget _imageCard(File? image) {
    return GestureDetector(
        onTap: () {
          controller.getImage();
        },
        child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.all(10),
              height: imageSize,
              width: imageSize,
              child: image != null ? Image.file(image, fit: BoxFit.cover,)
                  : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE))
          ),

        )

    );
  }

}
