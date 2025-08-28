import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_controller_model.dart';
import 'package:solexpress_panel_sc/src/models/ticket.dart';
import '../../data/memory.dart';
import '../../data/memory_panel_sc.dart';
import '../../models/idempiere/idempiere_user.dart';
class PanelScCallingController extends IdempiereControllerModel {

  late IdempiereUser user ;
  late List<Ticket> callingTickets = <Ticket>[].obs;
  PanelScCallingController(){
    callingTickets.addAll(MemoryPanelSc.newCallingTickets);
    user = getSavedIdempiereUser();
  }

  @override
  void signOut() {

    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}