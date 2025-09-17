



import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/sol_express_event.dart';
import '../../../../../utils/uppercase_formartter.dart';
import 'events_handling_controller.dart';

class EventsHandlingPage extends StatelessWidget {
  EventsHandlingController controller = Get.put(EventsHandlingController());
  bool createPage;
  EventsHandlingPage({
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
        title: Text(Messages.EVENTS,style: TextStyle(color: Colors.white,
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
              if(!createPage)Center(child: _textFieldFindByName(context)),
              if(!createPage)_dropDownEvents(controller.eventsResult),
              _textFieldId(),
              _textFieldName(),
              if(controller.saveImageLink)_textFieldImage(),
              _textFieldStartDate(context),
              _textFieldEndDate(context),
              _dropDownActive(controller.activeList),
            ],
          ),

        ),
      ),

    );

  }


  Widget _dropDownEvents(List<SolExpressEvent> events) {
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
          events.isEmpty ?Messages.NO_DATA_FOUND : '${Messages.SELECT_A_VALUE} ${events.length})'
          ,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownEventsItems(events),
        value: controller.idSolExpressEventResult.value == '' ? null : controller.idSolExpressEventResult.value,
        onChanged: (option) {
          controller.idSolExpressEventResult.value = option.toString();
          int? id =int.tryParse(option.toString());
          if(id!=null && id>0){
            SolExpressEvent? ob = controller.getSolExpressEventById(controller.eventsResult, id);
            controller.setData(ob);
          }
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownEventsItems(List<SolExpressEvent> events) {
    List<DropdownMenuItem<String>> list = [];
    for (var solExpressEvent in events) {
      list.add(DropdownMenuItem(

        value: solExpressEvent.id.toString(),
        child: Text(solExpressEvent.name ?? ''),
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

  Widget _textFieldId(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10,),

      child: TextField(
        enabled: false,
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
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.nameController,
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
  Widget _textFieldImage(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.imageController,
        keyboardType: TextInputType.text,
        maxLength: 255,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: Messages.IMAGE,
          prefixIcon: Icon(Icons.card_membership),
        ),
      ),
    );
  }
  Widget _textFieldFindByName(BuildContext context){
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      margin: EdgeInsets.only(left: 10,right: 10),
      child: TextButton(
        onPressed: () {  controller.findByName(context);},
        child: Text('${Messages.FIND_BY_NAME} (%XXX%)',
        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
      )
    );

  }


  Widget _textFieldStartDate(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          child: Text(Messages.START_DATE, style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
        ),
        title: TextField(
          onTap: () async {
            final date = await showDatePickerDialog(
              context: context,
              minDate: controller.minDay,
              maxDate: controller.maxDay,
              initialDate: controller.startDate.value,
              selectedDate: controller.startDate.value,
            );
            controller.setStartDate(date);
          },
          textAlign: TextAlign.center,
          //textAlignVertical: TextAlignVertical.center,
          readOnly: true,

          decoration: InputDecoration(
            //filled: true,
            fillColor: Colors.blue[200],
            hintText: Messages.START_DATE,
            border: OutlineInputBorder(),
          ),


          controller: controller.startDateController,
          keyboardType: TextInputType.none,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        ),
      ),
    );

  }

  Widget _textFieldEndDate(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: SizedBox(
          width: 80,
          child: Text(Messages.END_DATE,style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),),
        ),
        title: TextField(
          onTap: () async {
            final date = await showDatePickerDialog(
              context: context,
              minDate: controller.minDay,
              maxDate: controller.maxDay,
              initialDate: controller.endDate.value,
              selectedDate: controller.endDate.value,
            );
            controller.setEndDate(date);
          },
          textAlign: TextAlign.center,
          //textAlignVertical: TextAlignVertical.center,
          readOnly: true,

          decoration: InputDecoration(
            //filled: true,
            fillColor: Colors.blue[200],
            hintText: Messages.END_DATE,
            border: OutlineInputBorder(),
          ),


          controller: controller.endDateController,
          keyboardType: TextInputType.none,
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        ),
      ),
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
