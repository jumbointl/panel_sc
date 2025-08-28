



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../models/product_price_by_group.dart';
import 'product_price_by_group_handling_controller.dart';
import '../../../../../../../models/group.dart';

import '../../../../../../../data/memory.dart';
import '../../../../../../../data/messages.dart';
import '../../../../../../../models/active.dart';
import '../../../../../../../models/category.dart';

class ProductPriceByGroupHandlingPage extends StatelessWidget {
  ProductPriceByGroupHandlingController controller = Get.put(ProductPriceByGroupHandlingController());

  ProductPriceByGroupHandlingPage({super.key});
  late double screenWith  ;

  late double screenHeight;
  final double imageSize = 80;
  Color barColor = Colors.amber;
  Color resultColor = Colors.lightBlue;
  Color dropDownColor = Colors.lightGreen;

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
          _buttomBack(),

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
      height: MediaQuery.of(context).size.height*0.85,
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
            _textFieldFindGroupByName(),
            _findBarGroup(context),
            _textFieldFindProductByName(),
            _dropDownCategories(controller.categoriesList),
            _findBarProduct(context),
            _textFieldId(),

            _dropDownGroups(controller.groupsList),
            //_textFieldIdProduct(),
            _dropDownProducts(controller.productsList),
            _textFieldPrice(),
            _dropDownActive(controller.activeList),
            _buttomUpdate(context),
          ],
        ),

      ),

    );

  }
  Widget _dropDownGroups(List<Group> groups) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin:  EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
      decoration: BoxDecoration(
        color:  controller.groupsListIsEmpty ? Colors.white : resultColor ,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.black,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_GROUP,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsGroups(groups),
        value: controller.idGroup.value == '' ? null : controller.idGroup.value,
        onChanged: (option) {

          if(controller.idGroup.value!=option.toString()){
            controller.idGroup.value = option.toString();
            controller.idController.text ='';
          }
        },
      ),
    );
  }
  Widget _dropDownProducts(List<ProductPriceByGroup> products) {
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
        value: controller.idProductPrice.value == '' ? null : controller.idProductPrice.value,
        onChanged: (option) {
              controller.idProductPrice.value = option.toString();
              controller.idProductChanged();
              /*
              int? id = int.tryParse(option.toString());
              if(id==null || id==0){
                return;
              }
              ProductPriceByGroup? data = controller.getProductWithPriceById(controller.productsList, id);
              if(data ==null){
                return;
              }
              controller.setData(data);

               */
            },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownProductsItems(List<ProductPriceByGroup> datas) {
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
        color:  controller.categoriesListIsEmpty ? Colors.white : dropDownColor ,  // Set the desired background color
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

  List<DropdownMenuItem<String>> _dropDownItemsGroups(List<Group> groups) {
    List<DropdownMenuItem<String>> list = [];
    for (var group in groups) {
      list.add(DropdownMenuItem(
        value: group.id.toString(),
        child: Text(group.name ?? ''),
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
            color: barColor,
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
  Widget _buttomUpdate(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: ElevatedButton(onPressed: ()=> controller.priceUpdate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor:Memory.PRIMARY_COLOR,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(Messages.DATA_UPDATE,
            style: TextStyle(color: Colors.black),
          )),
    );

  }
  Widget _findBarProduct(BuildContext context){
    double iconSize = 36 ;
    double bottomWidth = 50 ;
    double bottomHeight = 50 ;
    double space = 8;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10,),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: bottomWidth, height: bottomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_FIND),
                iconSize: iconSize,
                onPressed: () {
                  controller.findProductswithPriceBySqlCondition(context);
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: bottomWidth, height:  bottomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_REFRESH),
                iconSize: iconSize,
                onPressed: () {
                  controller.clearForm();
                },
              )
          ),

        ],
      ),
    );

  }
  Widget _findBarGroup(BuildContext context){
    double iconSize = 36 ;
    double bottomWidth = 50 ;
    double bottomHeight = 50 ;
    double space = 8;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10,),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: bottomWidth, height: bottomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_FIND),
                iconSize: iconSize,
                onPressed: () {
                  controller.findGroupsBySqlCondition(context);
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: bottomWidth, height:  bottomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_REFRESH),
                iconSize: iconSize,
                onPressed: () {
                  controller.clearForm();
                },
              )
          ),

        ],
      ),
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
  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

      child: TextField(
        controller: controller.idController,
        keyboardType: TextInputType.number,
        //enabled: false,
        readOnly: true,
        decoration: InputDecoration(
          hintText: Messages.ID,
          prefixIcon: Icon(Icons.card_membership),
        ),
      ),
    );
  }
  Widget _textFieldFindGroupByName(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

      child: TextField(
        controller: controller.findByGroupNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.TIPS_FIND_BY_GROUP,
          prefixIcon: Icon(Icons.category),
        ),
      ),
    );
  }
  Widget _textFieldIdProduct(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

      child: TextField(
        controller: controller.idController,
        keyboardType: TextInputType.number,
        readOnly: true,
        decoration: InputDecoration(
          hintText: Messages.PRODUCT,
          prefixIcon: Icon(Icons.card_membership),
        ),
      ),
    );
  }
  Widget _textFieldPrice(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: TextField(
        controller: controller.priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: Messages.PRICE,
          prefixIcon: Icon(Icons.money),
        ),
      ),
    );
  }

  Widget _textFieldFindProductByName(){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(left: 10,right: 10, top: 10, ),
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

  Widget _textInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 20),
        alignment: Alignment.topCenter,
        child: Text(Messages.PRICE,
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black
            ))
    );
  }


}
