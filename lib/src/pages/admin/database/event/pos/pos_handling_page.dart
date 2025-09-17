



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/function_panel_sc.dart';
import '../../../../../models/pos.dart';
import '../../../../../utils/uppercase_formartter.dart';
import 'pos_handling_controller.dart';

class PosHandlingPage extends StatelessWidget {
  PosHandlingController controller = Get.put(PosHandlingController());
  bool createPage;
  PosHandlingPage({
    super.key,
    required this.createPage,
  });
  late double screenWith  ;
  late double screenHeight;
  Color barColor = Colors.amber;
  Color resultColor = Colors.blue[100]!;
  RxBool isDark = false.obs;
  RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {

    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Messages.POS,style: TextStyle(color: Colors.white,
            fontSize: 20,fontWeight: FontWeight.bold),),
      ),
      bottomNavigationBar: Obx(()=>createPage ? bottomCreateNavigationBar(context) :  bottomHandlingNavigationBar(context)),
      body: Obx(()=>SafeArea(child: _boxForm(context))),
    );
  }
  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.85,
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              if(!createPage)Center(child: _textFieldFindByName()),
              if(!createPage)_dropDownPos(controller.posResults),
              _textFieldId(),
              _textFieldName(),
              _textFieldCode(),
              _dropDownFunctionPanelSc(controller.functionList),
              _dropDownActive(controller.activeList),
            ],
          ),

        ),
      ),

    );

  }


  Widget _dropDownPos(List<Pos> pos) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(left: 10,right: 10),
      decoration: BoxDecoration(
        color: resultColor ,  // Set the desired background color
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
          pos.isEmpty ?Messages.NO_DATA_FOUND : '${Messages.SELECT_A_VALUE} ${pos.length})'
          ,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownPosItems(pos),
        value: controller.idPosResult.value == '' ? null : controller.idPosResult.value,
        onChanged: (option) {
          controller.idPosResult.value = option.toString();
          int? id =int.tryParse(option.toString());
          if(id!=null && id>0){
            Pos? ob = controller.getPosById(controller.posResults, id);
            controller.setData(ob);
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownPosItems(List<Pos> Pos) {
    List<DropdownMenuItem<String>> list = [];
    for (var pos in Pos) {
      list.add(DropdownMenuItem(

        value: pos.id.toString(),
        child: Text(pos.name ?? ''),
      ));
    }

    return list;
  }


  Widget _dropDownActive(List<Active>  list) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
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
              fontWeight: FontWeight.bold,
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
  Widget _dropDownFunctionPanelSc(List<FunctionPanelSc>  list) {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25),
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
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        ),
        items: _dropDownFunctionPanelScItems(list),
        value: controller.functionId.value == '' ? null : controller.functionId.value ,

        onChanged: (option) {
          //print('Opcion seleccionada ${option}');
          controller.functionId.value = option.toString() ;
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownFunctionPanelScItems(List<FunctionPanelSc> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(
        value: data.id.toString(),
        child: Text(data.name ?? ''),

      ));
    }

    return list;
  }


  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,),

      child: TextField(
        controller: controller.idController,
        keyboardType: TextInputType.number,
        readOnly: false,
        decoration: InputDecoration(
          hintText: createPage ? Messages.CREATE_WITH_ID:Messages.ID,
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
        maxLength: MemoryPanelSc.MAX_LENGTH_POS_NAME,
        keyboardType: TextInputType.text,
        inputFormatters: [
          UpperCaseTextFormatter(),
        ],
        decoration: InputDecoration(
          hintText: Messages.NAME,
          prefixIcon: Icon(Icons.event),
        ),
      ),
    );
  }
  Widget _textFieldCode(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.posCodeController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.PASSWORD,
          prefixIcon: Icon(Icons.key),
        ),
      ),
    );
  }
  Widget _textFieldFindByName(){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(left: 10,right: 10),
      child: Text('${Messages.FIND_BY_NAME} (%XXX%)',
      style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    );
  }



  Color getBottomNavigationBarBackgroundColor() {
    return isDark.value ? Colors.black :Memory.THEME_APP_BAR_COLOR;
  }
  Widget bottomHandlingNavigationBar(BuildContext context) {
    Color iconColor =  isDark.value ? Colors.white : Colors.black;
    Color backgroundColor =  getBottomNavigationBarBackgroundColor();

    return controller.isLoading.value
        ? LinearProgressIndicator(
          color: Colors.blue[200],
          backgroundColor: Colors.purple,
          minHeight: kToolbarHeight,
          )
      : BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColor,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.search, color: iconColor), label: Messages.SEARCH),
              BottomNavigationBarItem(icon: Icon(Icons.edit, color: iconColor), label: Messages.UPDATE),
              BottomNavigationBarItem(icon: Icon(Icons.close, color: iconColor), label: Messages.DELETE),
            ],
      currentIndex: selectedIndex.value,
      selectedItemColor: Colors.purple[800],
      onTap: (index) => controller.onHandlingItemTapped(context, index));
  }
  Widget bottomCreateNavigationBar(BuildContext context) {
    Color backgroundColor =  getBottomNavigationBarBackgroundColor();

    return Container(
      color: backgroundColor,
      height: 50,
      child: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),

        child: controller.isLoading.value
            ? LinearProgressIndicator(
          color: Colors.blue[200],
          backgroundColor: Colors.purple,
          minHeight: kToolbarHeight,
        )
            :Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: (){
                  if(controller.isLoading.value) return;
                  controller.clearForm();},
                child: Text(Messages.CLEAR,style: TextStyle(color: Colors.white,
                    fontSize: 25,fontWeight: FontWeight.bold),)),
                TextButton(onPressed: (){
                  if(controller.isLoading.value) return;
                  controller.create(context);},
                    child: Text(Messages.CREATE,style: TextStyle(color: Colors.purple,
                        fontSize: 25,fontWeight: FontWeight.bold),)),
              ],
            ),
      ),
    );
  }


}


