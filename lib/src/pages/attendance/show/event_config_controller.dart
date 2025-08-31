import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'package:solexpress_panel_sc/src/pages/attendance/common/panel_controller_model.dart';

import '../../../data/memory.dart';
import '../../../models/panel_sc_config.dart';
class EventConfigController extends PanelControllerModel {
  List<PanelScConfig> configs =<PanelScConfig>[].obs;
  RxString idEventConfig = ''.obs;
  RxString idEvent = ''.obs;
  PanelScConfig config = PanelScConfig();
  EventConfigController(){
    init();
  }

  Future<void> init() async {
    List<PanelScConfig> aux = await getEventConfigs();
    if(aux.isNotEmpty){
      configs.addAll(aux);
    }
  }
  void setEventConfig(String configId){
     if(configs.isNotEmpty){
       config = configs.firstWhere((element) => element.id.toString()==configId);
       idEventConfig.value = configId;
       idEvent.value = config.eventId.toString();

     }
  }

  void updateEventConfig() {
    if(config.id!=null){
      MemoryPanelSc.panelScConfig = config;
      String date = DateTime.now().toIso8601String().split('T').first;
      if(config.eventDate!=date){
        Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE,(route)=>false);
      } else {
        Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE, (route) => false);
      }

    }
  }
  void setFilterTotalByEvent(BuildContext context) {
    Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE, (route) => false
        ,arguments: {Memory.KEY_SHOW_TOTAL_ATTENDANCE_BY_EVENT,true});
    //Get.back(result: true);
    /*if(config.id!=null){
      MemoryPanelSc.panelScConfig = config;
      Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE, (route) => false
          ,arguments: {Memory.KEY_SHOW_TOTAL_ATTENDANCE_BY_EVENT,true});
    }*/
  }




}