import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/pages/panel_sc_calling/panel_sc_calling_controller.dart';
import '../../data/memory_panel_sc.dart';
import '../../data/messages.dart';
import '../../models/department.dart';
import '../../models/ticket.dart';
class PanelScCallingPage extends StatelessWidget {

  late PanelScCallingController con = Get.put(PanelScCallingController());
  late List<Ticket> callingTickets = con.callingTickets;
  PanelScCallingPage({super.key}){
    con = Get.put(PanelScCallingController());
  }
  Color callingColor = MemoryPanelSc.callingColor;
  Color calledColor = MemoryPanelSc.receivedColor;
  List<TicketStatus> ticketsStatus = TicketStatus.values;

  @override
  Widget build(BuildContext context) {
    return Obx(() => DefaultTabController(
        length: ticketsStatus.length,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: ticketsStatus.map((status) => Tab(text: status.toString().split('.').last.toUpperCase())).toList(),
            ),
          ),
          body: TabBarView(
            children: ticketsStatus.map((status) {
              List<Ticket> filteredTickets = con.callingTickets.where((ticket) => ticket.status == status).toList();
              // Add the "LAST CALLS" header for the "called" status tab, if it's the first item.
              // Adjust logic if "LAST CALLS" should always be present or based on different criteria.
              bool isCalledTab = status == TicketStatus.called;

              return
                  Container(
                    margin: EdgeInsets.only(top: 20,right: 10,bottom: 20),
                    child: ListView.separated(
                      shrinkWrap: true,
                      // Add 1 for the header if it's the "called" tab and there are items
                      itemCount: (isCalledTab && filteredTickets.isNotEmpty ? 1 : 0) + filteredTickets.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        if (isCalledTab && index == 0 && filteredTickets.isNotEmpty) {
                          return lastCallsCard(context);
                        }
                        // Adjust index for accessing filteredTickets if header is present
                        final ticketIndex = isCalledTab && filteredTickets.isNotEmpty ? index -1 : index;
                        if (ticketIndex < 0 || ticketIndex >= filteredTickets.length) return SizedBox.shrink(); // Should not happen with correct itemCount
                        return filteredTickets[ticketIndex].status == TicketStatus.called ? callingTicketCard(context, filteredTickets[ticketIndex])
                            : receivedTicketCard(context, filteredTickets[ticketIndex]);
                      },
                    ),
                  );

            }).toList(),
          ),
        ),
      ),
    );
  }
  Widget lastCallsCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
         Messages.LAST_CALLS.toUpperCase(),
          style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig, color: MemoryPanelSc.callingColor),
        ),
      ),
    );
  }

  Widget callingTicketCard(BuildContext context, Ticket ticket) {

    String place = ticket.place?.name ?? 'LUGAR';
    place = place.toUpperCase();

    if(place.contains('CONSULTORIO')){
      place = place.replaceAll('CONSULTORIO', 'CONS:');
    }

    String name = ticket.owner?.name ?? Messages.PATIENT;
    String display ='$name $place';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          spacing: 5,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                display.toUpperCase(),
                style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig, color: MemoryPanelSc.callingColor),
              ),
            ),

          ],
        ),
      ),
    );


    /*return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          spacing: 5,
          children: [
            Text(
                display.toUpperCase(),
                style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig, color: MemoryPanelSc.callingColor),
            ),
            Text(
                place.toUpperCase(),
                style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig, color: MemoryPanelSc.callingColor),
            ),
          ],
        ),
      ),
    );*/
  }
  Widget receivedTicketCard(BuildContext context, Ticket ticket) {


    String place = ticket.place?.name ?? 'LUGAR';
    String placeId = ticket.place?.id?.toString() ?? 'ID';

    String name = ticket.owner?.name ?? Messages.PATIENT;
    String display ='$name  #${ticket.id ?? ''}';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Column(
          spacing: 5,
          children: [
            Text(
                display,
                style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig,
                    fontWeight: FontWeight.bold,
                    color: MemoryPanelSc.receivedColor),
            ),
            Text(
                '$place $placeId',
                style: TextStyle(fontSize: MemoryPanelSc.fontSizeBig, color: MemoryPanelSc.receivedColor,
                fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }



  Widget cardTicket(BuildContext context, Ticket ticket) {

    String place = ticket.place?.name ?? 'LUGAR';
    String placeId = ticket.place?.id?.toString() ?? 'ID';

    double cardHeight = 100;
    String date = ticket.calledTime ?? '';
    Color color = getWarningColor(ticket.department ?? Department(id: 0, name: 'NOT FOUND'));
    return GestureDetector(
      onTap: () {
      },
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 10, left: 10, right: 10),
            width:  MediaQuery.of(context).size.width*0.25-20,
            height: cardHeight,
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Container(
                      height: 35,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: color,
                        //color: Colors.amber,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Text('${ticket.name}',
                              textAlign: TextAlign.center,
                              style:  TextStyle(
                                fontSize: MemoryPanelSc.fontSizeBig,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 40, left: 10, right: 10),
                    child: Row(
                      children: [
                        Text(place,textAlign: TextAlign.left,),
                        Spacer(),
                        Text(placeId,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: MemoryPanelSc.fontSizeBig,
                          ),),
                      ],
                    ),

                  ),


                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Color getWarningColor(Department data) {
    if(data.id == null || data.id == 1){
      return Colors.red;
    } else if(data.id ==2){
      return Colors.yellow;
    } else {
      return Colors.cyan;
    }
  }
}
