import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
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
        centerTitle: true,
        title: Text(Messages.EVENT),
      ),
      body: SafeArea(
        child: Obx(()=> Container(
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => con.setFilterTotalByEvent(context),
                  child: Text(
                    Messages.TOTAL_BY_EVENT,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ),
                _dropDownEventConfig(),
                con.idEventConfig.isNotEmpty ? ElevatedButton(
                  onPressed: () => con.updateEventConfig(),
                  child: Text(
                    Messages.UPDATE,
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      ),),
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
          Messages.SELECT_A_FUNCTION,

          style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black
          ),
        ),
        items: _dropDownItemsFunction(con.configs),
        value: con.idEventConfig.value == '' ? null : con.idEventConfig.value,
        icon: Icon(Icons.category),
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
