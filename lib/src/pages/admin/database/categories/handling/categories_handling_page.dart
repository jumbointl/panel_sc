



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/category.dart';
import '../../../../../models/vat.dart';
import 'categories_handling_controller.dart';

class CategoriesHandlingPage extends StatelessWidget {
  CategoriesHandlingController controller = Get.put(CategoriesHandlingController());

  CategoriesHandlingPage({super.key});
  late double screenWith  ;

  late double screenHeight;
  final double imageSize = 80;
  Color barColor = Colors.amber;
  Color resultColor = Colors.lightBlue;

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
            _textFieldFindByName(),
            _dropDownCategories(controller.categoriesResult),
            _findBar(context),
            _textFieldId(),
            _textFieldName(),
            _textFieldDescription(),
            GetBuilder<CategoriesHandlingController>
              (builder: (value)=>_imageCard()),
            _dropDownVats(),
            _dropDownActive(controller.activeList),
            _buttomBar(context),
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
            color: barColor,
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
          /*
          if(option.toString()!='' && option.toString()!='0'){
            print('seleccionada $option');
            String? vatName = controller.getNamebyIdFromObjectWithNameAndId(controller.vatsList,int.tryParse(option.toString()));
            print('name eleccionada $vatName');
            controller.findController.text =vatName ?? Messeges.ID_NOT_FOUND;
            controller.update();
          }
          */
        },
      ),
    );
  }
  Widget _dropDownCategories(List<Category> categories) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 10, bottom: 10,left: 10,right: 10),
      decoration: BoxDecoration(
        color:  controller.showNavigateBottom ? resultColor :Colors.white,  // Set the desired background color
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
        value: controller.idCategoryResult.value == '' ? null : controller.idCategoryResult.value,
        onChanged: (option) {
          // print('Opcion categoria seleccionada ${option}');
          controller.idCategoryResult.value = option.toString();
          int? id =int.tryParse(option.toString());
          if(id!=null && id>0){
            Category? ob = controller.getCategoryById(controller.categoriesResult, id);
            controller.setDatas(ob);
          }
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
  Widget _buttomBar(BuildContext context){
    double iconSize = 36 ;
    double buttomWidth = 50 ;
    double buttomHeight = 50 ;
    double space = 8;
  return  Container(
    margin: EdgeInsets.only(left: 10,right: 10,top: 20),
    alignment: Alignment.bottomCenter,
    decoration: BoxDecoration(
      color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
            child: IconButton(
              icon: Image.asset(Memory.IMAGE_UPDATE),
              iconSize: iconSize,
              onPressed: () {
                controller.updateData(context);
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

        ],
      ),
  );

  }
  Widget _findBar(BuildContext context){
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
                  controller.findCategoriesBySqlCondition(context);
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
  Widget _textFieldFindByName(){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(left: 10,right: 10, top: 10, ),
      child: TextField(
        controller: controller.findController,
        keyboardType: TextInputType.text,
        //maxLength: 20,
        decoration: InputDecoration(
          hintText: Messages.TIPS_FIND_BY_NAME,
          fillColor: barColor,
          //prefixIcon: Icon(Icons.photo),
        ),
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
  Widget _imageCard() {
    String? categoryImage ;
    if(controller.categoryResult!=null && controller.categoryResult!.image !=null){
      categoryImage = controller.categoryResult!.image  ;

    }

    return GestureDetector(
        onTap: () {
          controller.getImage();
          if(controller.imageFile != null){
            print(controller.imageFile!.path);
          } else {
            print('controller.imageFile!.null');
          }

        },
        child: Card(
          elevation: 3,
          child: Container(
              padding: EdgeInsets.all(10),
              height: imageSize,
              width: imageSize,
              child: controller.imageFile != null ? Image.file(controller.imageFile!, fit: BoxFit.cover,)
                  : categoryImage!=null ? Image(image: NetworkImage(categoryImage),fit: BoxFit.cover,)
                  : Image(image: AssetImage(Memory.IMAGE_COVER_IMAGE),fit: BoxFit.cover,)

          ),

        )

    );
  }

}
