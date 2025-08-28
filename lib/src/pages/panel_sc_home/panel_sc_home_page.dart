import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/memory_panel_sc.dart';
import '../../data/messages.dart';
import '../../models/ticket.dart';
import 'panel_sc_home_controller.dart';
import '../ticket/ticket_page.dart';
import '../video/video_play_list_screen.dart';
class PanelScHomePage extends StatelessWidget {

  late PanelScHomeController con;
  int count = 0;
  late double cardHeight;

  PanelScHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulate API call or data loading
    con = Get.put(PanelScHomeController());
    WidgetsBinding.instance.addPostFrameCallback((_) {

      //con.addCallingTicket(ticket2);
    });

    double videoHeight =   MediaQuery.of(context).size.height*3/4;
    double videoWidth1 = MediaQuery.of(context).size.width*3/4;

    double videoWidth = videoWidth1;
    cardHeight =    MediaQuery.of(context).size.height - videoHeight -65;
    if(con.onlyTv){
      return Scaffold(

        body: SafeArea(
          child: PopScope(
            canPop: true, // Allow popping by default
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (didPop) {
                // Handle successful pop

                print('Route popped successfully with result: $result');
              } else {
                // Handle prevented pop
                print('Pop was prevented.');
              }

              con.signOut();
            },
            //color: Color(0xff2c3fc5),
            child: VideoPlaylistScreen(),),
        ),
      );
    }
    return Scaffold(

      body: SafeArea(
        child: PopScope(
          canPop: true, // Allow popping by default
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              // Handle successful pop

              print('Route popped successfully with result: $result');
            } else {
              // Handle prevented pop
              print('Pop was prevented.');
            }

            con.signOut();
          },
          //color: Color(0xff2c3fc5),
          child:  Column(
            children: [

              Row(
                children: [
                  SizedBox(
                    width: videoWidth,
                    height: videoHeight,
                    child: VideoPlaylistScreen(),
                  ),
                  SizedBox(
                      width: videoWidth/3,
                      height: videoHeight,
                      child: TicketPage()),

                  ],
                ),

                Obx(()=>  SizedBox(
                    height: cardHeight,
                    width: MediaQuery.of(context).size.width,
                    child: showTickets(context, con.callingTickets.obs), // Added ticketCardBig here
                  ),),

              SizedBox(height: 10,),
              Obx(()=>con.isLoading.value ? getProgressBar(context) : Container()),
            ],
          ),
        ),),
    );
  }
  Widget showTickets(BuildContext context, List<Ticket> tickets) {
    if(tickets.isEmpty){
      return Container(child: Center(
        child: Text(
        Messages.EMPTY,
        style: TextStyle(fontSize: MemoryPanelSc.fontSizeExtraBig,
            color: MemoryPanelSc.callingColor,
            fontWeight: FontWeight.bold
        ),
      ),
    ),);
    }
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
      child: Text(
        tickets[0].display(),
        style: TextStyle(fontSize: MemoryPanelSc.fontSizeExtraBig,
            color: MemoryPanelSc.callingColor,
            fontWeight: FontWeight.bold
        ),
      ),
    ),);
  }
  Widget ticketCardBig(BuildContext context, Ticket ticket){

    String display =ticket.display();

    return (ticket.status == TicketStatus.called) ? Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
            display,
            style: TextStyle(fontSize: MemoryPanelSc.fontSizeExtraBig,
                color: MemoryPanelSc.callingColor,
                fontWeight: FontWeight.bold
            ),
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
          style: TextStyle(fontSize: MemoryPanelSc.fontSizeExtraBig,
              color: MemoryPanelSc.receivedColor,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getProgressBar(BuildContext context) {
    int? showProgressBarEachXTimes = MemoryPanelSc.panelScConfig.showProgressBarEachXTimes;
    if(showProgressBarEachXTimes==null || showProgressBarEachXTimes==0){
      return Container();
    }

    if(count<MemoryPanelSc.panelScConfig.showProgressBarEachXTimes!){
      count++;
      return Container();
    }

    count = 0;
    return LinearProgressIndicator(minHeight: 15,color: Colors.purple,);
    /*if(count <20){
      count++;
      return  Container();
    } else {
      count = 0;
      return con.isLoading.value ?
      Container(
          height: 15,
          child: LinearProgressIndicator(minHeight: 15,color: Colors.purple,)) : Container();
    }*/


  }

  /*Widget getDownloadProgressBar(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${Messages.DOWNLOADING}:(${con.currentDownloadFileIndex.value+1}/${con.totalFilesToDownload.value})'
              ' ${con.downloadUrl.value}',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(height: 10),
        LinearProgressIndicator(minHeight: 40,color: Colors.yellow,),
        SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: con.downloadedFiles.length,
            separatorBuilder: (context, index) => Divider(color: Colors.white),
            itemBuilder: (context, index) {
              String fileName = con.downloadedFiles[index];
              return ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text(
                  fileName,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ),
        ),

      ],
    );
    if (con.downloadingFile.value) {

    }

    if (!con.hasValidVideo.value) {
      String text =Messages.NO_VALID_VIDEO ;
      if(con.playlist.isNotEmpty){
        text = '${Messages.VIDEOS_TO_PAY} ${con.playlist.length}';
      }
      return Text(
        text,
        style: TextStyle(fontSize: 40, color: Colors.white),
      );
    }
  }*/
}

