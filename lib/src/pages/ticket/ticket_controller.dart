import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/models/ticket.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';
import '../../data/memory.dart';
import '../../data/memory_panel_sc.dart';
import '../../models/user.dart';
class TicketController extends ControllerModel {

  late User user ;
  final List<Ticket> callingTickets = MemoryPanelSc.callingTickets;
  TicketController(){
    user = getSavedUser();
  }

  @override
  void signOut() {

    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

}