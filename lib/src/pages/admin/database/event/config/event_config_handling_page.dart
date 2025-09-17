



import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'package:solexpress_panel_sc/src/pages/web/web_page.dart';
import '../../../../../data/memory.dart';
import '../../../../../data/messages.dart';
import '../../../../../models/active.dart';
import '../../../../../models/panel_sc_config.dart';
import '../../../../../models/sol_express_event.dart';
import 'event_config_handling_controller.dart';

class EventConfigHandlingPage extends StatelessWidget {
  EventConfigHandlingController controller = Get.put(EventConfigHandlingController());
  bool createPage;
  EventConfigHandlingPage({
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
        title: Text(Messages.CONFIG,style: TextStyle(color: Colors.white,
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
              createPage ? _textFieldConfigName(context) : _textEventDate(context),
              controller.asTemplate.value ? _dropDownConfig(controller.configResults) : Container(),
              createPage ? _dropDowEventDateMultiSelect(context, controller.eventDates)
               :_dropDownConfig(controller.configResults),
              SizedBox(height: 10,),
              _id(context),
              _eventName(context),
              _logoUrl(context),
              _landingUrl(context),
              _barcodeLength(context),
              _placeIdLength(context),
              _showProgressBarEachXTimes(context),
              _timeOffsetMinutes(context),
              _dropDownActive(controller.activeList),

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



  Widget _dropDownConfig(List<PanelScConfig>  list) {
    Color backgroundColor =  controller.asTemplate.value ? Colors.yellow[200]! : Colors.blue[200]!;
    String message = controller.asTemplate.value ? Messages.SELECT_A_TEMPLATE : Messages.SELECT_AN_OPTION;
    String noDataFound = controller.asTemplate.value ? Messages.NO_TEMPLATE_FOUND : Messages.NO_DATA_FOUND;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: controller.configResults.isEmpty ? Colors.white : backgroundColor,
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: DropdownButton(
          elevation: 3,
          hint: Text(
            controller.configResults.isEmpty ? noDataFound :
            '$message (${controller.configResults.length})',

            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
            ),
          ),
          items: _dropDownPosItems(list),
          value: controller.idConfigResult.value == '' ? null : controller.idConfigResult.value ,

          onChanged: (option) {
            controller.idConfigResult.value = option.toString() ;
            int? id =int.tryParse(option.toString());
            if(id!=null && id>0){
              PanelScConfig? ob = controller.getPanelScConfigById(controller.configResults, id);
              controller.setConfigData(ob);
            }

          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownPosItems(List<PanelScConfig> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(

        value: data.id.toString(),

        child: Text(data.eventName ?? ''),

      ));
    }

    return list;
  }

  Widget _textFieldConfigName(BuildContext context){
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

              controller.findConfigByConfigEventName(context);
            },

              child: Text('${Messages.FIND_CONFIG_BY_NAME_FOR_TEMPLATE} (%XXX%)',
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
  Widget _id(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        leading: Text(
          Messages.ID,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        title: TextField(
          readOnly: true,
          controller: controller.idController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            //labelText: Messages.ID,
            border: OutlineInputBorder(),
          ),
        ),

        trailing: SizedBox(
            width: 50, // Adjust width as needed
            height: 50, // Adjust height as needed
            child: controller.logoUrlController.text.isEmpty
                ? Image.asset(MemoryPanelSc.IMAGE_NO_IMAGE, fit: BoxFit.cover)
                : NetworkImageWidget(
              imageUrl: controller.logoUrlController.text,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Image.asset(
                MemoryPanelSc.IMAGE_NO_IMAGE,
                fit: BoxFit.cover,
              ),
            ),
          ),
      ),
    );
  }
  Widget _eventName(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[800],
          ),
          onPressed: () {
            controller.showAutoCloseMessage(context,Messages.TO_ADD_DATE,Messages.NOT_ENABLED,2000);

          },

          child: Text(
            '${Messages.NAME}(${Messages.TO_ADD_DATE})',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        subtitle: TextField(
          readOnly: false,
          maxLength: MemoryPanelSc.MAX_LENGTH_EVENT_NAME,
          controller: controller.eventNameController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            //labelTex: Messages.NAME,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
  Widget _logoUrl(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[800],
          ),
          onPressed: () {
            if (controller.logoUrlController.text.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: NetworkImageWidget(
                      imageUrl: controller.logoUrlController.text,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Text(Messages.NO_IMAGE_FOUND),
                    ),
                  ),
                ),
              );
            }
          },

          child: Text(
            Messages.LOGO,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                ),
          ),
        ),
        subtitle: TextField(
          controller: controller.logoUrlController,
          maxLines: 8,
          maxLength: 255,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            //labelTex: Messages.LOGO,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
  Widget _landingUrl(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue[800],
          ),
          onPressed: () {
            if (controller.landingUrlController.text.isNotEmpty) {
              Get.to(WebPage(url:controller.landingUrlController.text));
            }
          },
          child: Text(
            Messages.LANDING_PAGE,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        subtitle: TextField(
          controller: controller.landingUrlController,
          maxLines: 8,
          maxLength: 255,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            //labelTex: Messages.LANDING_PAGE,
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
  Widget _barcodeLength(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: Text(
          Messages.BARCODE_LENGTH,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 100,
          child: TextField(
            controller: controller.barcodeLengthController,
            maxLength: 2,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              //labelTex: Messages.BARCODE_LENGTH,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
  Widget _placeIdLength(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: ListTile(
          title: Text(
            Messages.PLACE_ID_LENGTH,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          trailing: SizedBox(
            width: 100,
            child: TextField(
              controller: controller.placeIdLengthController,
              maxLength: 1,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                //labelTex: Messages.PLACE_ID_LENGTH,
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _showProgressBarEachXTimes(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: Text(
          Messages.SHOW_PROGRESS_BAR_EACH_X_TIMES,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 100,
          child: TextField(
            controller: controller.showProgressBarEachXTimesController,
            maxLength: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              //labelTex: Messages.SHOW_PROGRESS_BAR_EACH_X_TIMES,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
  Widget _timeOffsetMinutes(BuildContext context){

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: ListTile(
        title: Text(
          Messages.TIME_OFFSET_MINUTES,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        trailing: SizedBox(
          width: 100,
          child: TextField(
            controller: controller.timeOffsetMinutesController,
            maxLength: 5,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              //labelTex: Messages.TIME_OFFSET_MINUTES,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ),
    );
  }
  Widget _textEventDate(BuildContext context){
    String date = '${Messages.EVENT_DATE} : ${controller.configResult?.eventDate  ?? ''}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(date,
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
              BottomNavigationBarItem(icon: Icon(Icons.settings, color: iconColor), label: Messages.SEARCH),
              BottomNavigationBarItem(icon: Icon(Icons.edit, color: iconColor), label: Messages.UPDATE),

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
  Widget _dropDownEventDate(List<String>  list) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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
          items: _dropDownEventDateItems(list),
          value: controller.eventDate.value == '' ? null : controller.eventDate.value ,

          onChanged: (option) {
            //print('Opcion seleccionada ${option}');
            controller.eventDate.value = option.toString() ;
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownEventDateItems(List<String> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(
        value: data,
        child: Text(data),

      ));
    }

    return list;
  }

  Widget _dropDownActive(List<Active>  list) {
    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black, // Set border color to black
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

  Widget _dropDowEventDateMultiSelect(BuildContext context,List<String>  list) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          color: controller.eventDates.isEmpty ? Colors.white : Colors.blue[200],
          border: Border.all(
            color: Colors.black, // Set border color to black
          ),
        ),
      child: Obx(() => Padding(
        padding: const EdgeInsets.only(left: 10,right: 20),
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            controller.eventDates.isEmpty ? Messages.NO_DATE_AVAILABLE
                : '${Messages.DATE_AVAILABLE} (${controller.eventDates.length})',
            style: TextStyle(
              fontSize: 15,
              fontWeight:FontWeight.bold ,
              color: Theme.of(Get.context!).hintColor,
            ),
          ),
          items: list.map((item) {
            return DropdownMenuItem(
              value: item,
              //disable default onTap to avoid closing menu when selecting an item
              enabled: false,
              child: StatefulBuilder(
                builder: (context, menuSetState) {
                  final isSelected = controller.selectedEventDatesItems.contains(item);
                  return InkWell(
                    onTap: () {
                      isSelected
                          ? controller.selectedEventDatesItems.remove(item)
                          : controller.selectedEventDatesItems.add(item);
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
                              item,
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
          value: controller.selectedEventDatesItems.isEmpty ? null : controller.selectedEventDatesItems.first,
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
    List<String?> names = controller.selectedEventDatesItems.map((pos) => pos).toList();
    // Join the names with a comma and space
    return names.join(', ');
  }
}
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final Widget Function(BuildContext, String) placeholder;
  final Widget Function(BuildContext, String, dynamic) errorWidget;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    required this.placeholder,
    required this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder(context, imageUrl);
      },
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
        return Text(Messages.NO_IMAGE_FOUND);
      }
    );
  }
}
