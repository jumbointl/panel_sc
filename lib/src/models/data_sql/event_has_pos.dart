import 'package:solexpress_panel_sc/src/models/sol_express_event.dart';

import '../pos.dart';

class EventHasPos {
  SolExpressEvent? event;
  Pos? pos;
  EventHasPos({this.event,this.pos});
  get posId => pos?.id;
  get eventId => event?.id;
  get posName => pos?.name;
  get eventName => event?.name;
  get eventImage => event?.image;
  get eventStartDate => event?.eventStartDate;
  get eventEndDate => event?.eventEndDate;
  get eventActive => event?.active;
  get posActive => pos?.active;
  get posFunctionId => pos?.functionId;
  get posCode => pos?.posCode;




}