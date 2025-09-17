import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/panel_sc_config.dart';
import '../../../data/messages.dart';
import 'event_config_controller.dart';
class EventConfigPage extends StatelessWidget {

  EventConfigController con = Get.put(EventConfigController());

  //double fontSize = MemoryPanelSc.fontSizeMedium;
  double fontSize = 16;

  EventConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(Messages.EVENT),
      ),
      body: PopScope(
        canPop: false, // Allow popping by default
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          if (didPop) {
            //Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false);
            print('--Route popped successfully with result: $result');
          } else {
            // Handle prevented pop
            print('Pop was prevented.');
          }
          print('--showAutoCloseMessages');
          // Ensure that the context is still valid before showing the message
          // if (Navigator.of(context).canPop()) {
          con.showAutoCloseMessages(context,Messages.NOT_CHANGES,Colors.red[200]!,2);
        },
        child: SafeArea(
          child: Obx(()=> Container(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  //spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                          fixedSize: const Size(200, 50),
                          textStyle: TextStyle(fontSize: fontSize)
                      ),
                      onPressed: () => con.setFilterTotalByEvent(context),
                      child: Text(
                        Messages.TOTAL_BY_EVENT,
                        style: TextStyle(
                            color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _dropDownEventConfig(),
                    SizedBox(height: 20),
                    con.idEventConfig.isNotEmpty ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 50),
                          textStyle: TextStyle(fontSize: fontSize)
                      ),
                      onPressed: () => con.updateEventConfig(),
                      child: Text(
                        Messages.UPDATE,
                        style: TextStyle(
                            color: Colors.black,
                        ),
                      ),
                    ) : SizedBox(height: 50), // Maintain space even if button is not visible
                    //SizedBox(height: 20),
                    Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size(200, 50),
                          textStyle: TextStyle(fontSize: fontSize)
                      ),
                      onPressed: () => con.signOut(),
                      child: Text(
                        Messages.LOGOUT,
                        style: TextStyle(
                            color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }
  Widget _dropDownEventConfig() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      //margin: EdgeInsets.only(top: 10),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_CONFIGURATION,

          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
        items: _dropDownItemsFunction(con.configs),
        value: con.idEventConfig.value == '' ? null : con.idEventConfig.value,
        //icon: Icon(Icons.category),
        onChanged: (option) {
          con.setEventConfig(option.toString());
        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsFunction(List<PanelScConfig> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var item in data) {
      list.add(DropdownMenuItem(
        value: item.id.toString(),
        child: Text(item.name ?? ''),
      ));
    }

    return list;
  }
}
