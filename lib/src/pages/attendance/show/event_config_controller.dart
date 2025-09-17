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
      MemoryPanelSc.showTotalAttendanceByEvent = false;
      String date = DateTime.now().toIso8601String().split('T').first;
      String dateConfig = config.eventDate ?? '';
      if(dateConfig.isNotEmpty){
        dateConfig = dateConfig.split(' ').first;
      }
      print('------------------ $dateConfig ,$date ,${dateConfig==date}');
      if(dateConfig!=date){
        print('-----------------ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE');
        Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE,(route)=>false);
      } else {
        print('------------------ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE $dateConfig ,$date ,${dateConfig==date}');
        Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE,
                (route) => false);
      }

    } else {
      Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE,
              (route) => false);
    }
  }
  void setFilterTotalByEvent(BuildContext context) {
    MemoryPanelSc.showTotalAttendanceByEvent = true;
    Get.offNamedUntil(Memory.ROUTE_PANEL_SC_SHOW_ATTENDANCE_LIVE_PAGE, (route) => false);

  }

}