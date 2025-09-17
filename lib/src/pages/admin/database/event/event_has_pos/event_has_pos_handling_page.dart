



import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/pos.dart';
import '../../../../../models/sol_express_event.dart';
import 'event_has_pos_handling_controller.dart';

class EventHasPosHandlingPage extends StatelessWidget {
  EventHasPosHandlingController controller = Get.put(EventHasPosHandlingController());
  bool createPage;
  EventHasPosHandlingPage({
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
    controller.createPage = createPage;
    screenWith = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(Messages.EVENT_HAS_POS,style: TextStyle(color: Colors.white,
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
              _textFieldFindByEventName(context),
              _dropDownEvents(controller.eventResults),
              _textFieldPosName(context),
              createPage ? _dropDownPosMultiSelect(context,controller.posResults)
               :_dropDownPos(controller.posResults),
            ],
          ),

        ),
      ),

    );

  }


  Widget _dropDownEvents(List<SolExpressEvent> data) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: controller.eventResults.isEmpty ? Colors.white : Colors.blue[200],
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: DropdownButton(
          elevation: 3,
          hint: Text(
            data.isEmpty ?Messages.NO_DATA_FOUND : '${Messages.SELECT_A_VALUE} ${data.length})'
            ,

            style: TextStyle(
              fontSize: 15,
              fontWeight:FontWeight.bold ,
            ),
          ),
          isExpanded: true,
          items: _dropDownEventsItems(data),
          value: controller.idEventResult.value == '' ? null : controller.idEventResult.value,
          onChanged: (option) {
            controller.idEventResult.value = option.toString();
            int? id =int.tryParse(option.toString());
            if(id!=null && id>0){
              SolExpressEvent? ob = controller.getSolExpressEventById(controller.eventResults, id);
              controller.setEventData(ob);
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownEventsItems(List<SolExpressEvent> eventHasPos) {
    List<DropdownMenuItem<String>> list = [];
    for (var solExpressEvent in eventHasPos) {
      list.add(DropdownMenuItem(

        value: solExpressEvent.id.toString(),
        child: Text(solExpressEvent.name ?? ''),
      ));
    }

    return list;
  }


  Widget _dropDownPos(List<Pos>  list) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: controller.posResults.isEmpty ? Colors.white : Colors.blue[200],
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: DropdownButton(
          elevation: 3,
          hint: Text(
            controller.posResults.isEmpty ? Messages.NO_DATA_FOUND :
            '${Messages.SELECT_AN_OPTION} (${controller.posResults.length})',

            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          items: _dropDownPosItems(list),
          value: controller.idPosResult.value == '' ? null : controller.idPosResult.value ,

          onChanged: (option) {
            controller.idPosResult.value = option.toString() ;
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownPosItems(List<Pos> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(

        value: data.id.toString(),

        child: Text(data.name ?? ''),

      ));
    }

    return list;
  }

  Widget _textFieldPosName(BuildContext context){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(onPressed: () async {

              controller.findPosByName(context);
            },

              child: Text('${Messages.FIND_POS_BY_NAME} (%XXX%)',
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textFieldFindByEventName(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: TextButton(onPressed: () async {

        controller.findEventByName(context);
      },
        child: Text('${Messages.FIND_EVENT_BY_NAME} (%XXX%)',
        style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
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
              BottomNavigationBarItem(icon: Icon(Icons.event, color: iconColor), label: Messages.SEARCH),
              BottomNavigationBarItem(icon: Icon(Icons.point_of_sale, color: iconColor), label: Messages.SEARCH),
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

  Widget _dropDownPosMultiSelect(BuildContext context,List<Pos>  list) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: controller.posResults.isEmpty ? Colors.white : Colors.blue[200],
          border: Border.all(
            color: Colors.black, // Set border color to black
          ),
        ),
      child: Obx(() => Padding(
        padding: const EdgeInsets.only(left: 10,right: 20),
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            controller.posResults.isEmpty ? Messages.NO_DATA_FOUND
                : '${Messages.SELECT_A_VALUE} (${controller.posResults.length})',
            style: TextStyle(
              fontSize: 15,
              fontWeight:FontWeight.bold ,
              color: Theme.of(Get.context!).hintColor,
            ),
          ),
          items: list.map((item) {
            return DropdownMenuItem(
              value: item.id.toString(),
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = controller.selectedPosItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? controller.selectedPosItems.remove(item)
                          : controller.selectedPosItems.add(item);
                      //This rebuilds the StatefulWidget to update the button's text
                      //setState(() {});
                      //This rebuilds the dropdownMenu Widget to update the check mark
                      menuSetState(() {});
                    },
                    child: Container(
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          if (isSelected)
                            const Icon(Icons.check_box_outlined)
                          else
                            const Icon(Icons.check_box_outline_blank),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              item.name ?? '',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight:FontWeight.bold ,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }).toList(),
          //Use last selected item as the current value so if we've limited menu height, it scroll to last item.
          value: controller.selectedPosItems.isEmpty ? null : controller.selectedPosItems.last.id?.toString(),
          onChanged: (value) {},
          selectedItemBuilder: (context) {
            return list.map(
                  (item) {
                return Container(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    getSelectedPos(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight:FontWeight.bold ,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                );
              },
            ).toList();
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.only(left: 16, right: 8),
            height: 40,
            width: double.infinity,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
            padding: EdgeInsets.zero,
          ),
        ),
      ))),
    );
  }

  String getSelectedPos() {
    // Extract names from the list of Pos objects
    List<String?> names = controller.selectedPosItems.map((pos) => pos.name).toList();
    // Join the names with a comma and space
    return names.join(', ');
  }
}

