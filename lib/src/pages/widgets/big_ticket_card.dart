import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';

import '../../data/memory_panel_sc.dart';
import '../../data/messages.dart';
import '../../models/ticket.dart';
import '../panel_sc_home/panel_sc_home_controller.dart';

class BigTicketCard extends StatelessWidget {
  const BigTicketCard({
    super.key,
    required this.con,
    required this.context,
    required this.ticket,
  });

  final PanelScHomeController con;
  final BuildContext context;
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {

    String place = ticket.place?.name ?? 'LUGAR';
    String placeId = ticket.place?.id?.toString() ?? 'ID';

    String name = ticket.owner?.name ?? Messages.PATIENT;
    String display ='$name $place $placeId';
    con.speedCallingTickets(ticket);

    return (ticket.status == TicketStatus.called) ? Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: BlinkText(
            display,
            style: TextStyle(fontSize: 48.0, color: Colors.redAccent),
            beginColor: Colors.orange,
            endColor: MemoryPanelSc.callingColor,
            times: 10,
            duration: Duration(seconds: 5)
        ),
      ),
    ) : Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
            display,
            style: TextStyle(fontSize: 48.0, color: MemoryPanelSc.receivedColor),
        ),
      ),
    );
  }
}