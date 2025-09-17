import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/attendance_by_group.dart';
import 'show_attendance_controller.dart';
import '../../../data/memory_panel_sc.dart';
import '../../../data/messages.dart';
class ShowAttendancePage extends StatelessWidget {

  late ShowAttendanceController con = Get.put(ShowAttendanceController());
  int count = 0;
  final int defaultColumnsWidth = MemoryPanelSc.EVENT_PANEL_COLUMNS_WIDTH;
  Color? backgroundColor = Colors.yellow[200];
  int count2 =0;

  ShowAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {

    // Simulate API call or data loading
    double columns = MediaQuery.of(context).size.width/defaultColumnsWidth;
    if(columns>1){
      con.screenColumns = columns.floor();
    }
    if(con.screenColumns==1){
      con.fontSizeExtraBig = con.fontSizeBig;
      con.fontSizeBig = con.fontSizeMedium;
    }else{
      con.fontSizeExtraBig = con.fontSizeExtraBig;
      con.fontSizeBig = con.fontSizeBig;
      
    } 

    double screenHeight = MediaQuery.of(context).size.height;
    bool screenHeightError = screenHeight<600;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      int interval =3;
      if(con.attendanceByGroups.isEmpty){
        if(con.attendanceLoaded){
          if(count2<3){
            count2++;
            con.showAutoCloseMessages(context,Messages.NO_DATA_FOUND,Colors.green[200]!,interval);
          }

        } else{
          interval = MemoryPanelSc.intervalToRetrieveNewCalledAttendanceByGroups+2;
          con.showAutoCloseQuestionMessages(context,Messages.WAIT_FOR_DATA,Colors.yellow[200]!,interval);
        }

      }
    });



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
          child:  Obx(()=>screenHeightError ? Container(
            child: screenHeightErrorPanel(context),
          ) :SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  con.isLoading.value ? getProgressBar(context) : Container(child: SizedBox(height: 15,)),
                  SizedBox(height: 10,),
                  GestureDetector(
                      onTap: () {
                        con.showEventConfigPage(context);
                      },
                      child: showTotalAttendance(context, con.attendanceByGroups)),
                  SizedBox(height: 10,),
                  SizedBox(
                        height: MediaQuery.of(context).size.height*0.75,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: showTotalAttendanceGridView(context, con.attendanceByGroups),
                        )),


                ],
              ),
            ),
          ),),
        ),),
    );
  }
  Widget eventLogo(BuildContext context){
    String? logoUrl = MemoryPanelSc.panelScConfig.logoUrl;
    return Container(
      //margin: EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey, // Optional background color behind the image
        image: DecorationImage(
          image: (logoUrl == null || logoUrl.isEmpty
              ? AssetImage(MemoryPanelSc.IMAGE_EVENT_LOGO)
              : NetworkImage(logoUrl)) as ImageProvider,
          onError: (exception, stackTrace) => AssetImage(MemoryPanelSc.IMAGE_EVENT_LOGO),
          fit: BoxFit.cover,
        ),
        /*border: Border.all(
          width: 4,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(10),*/
      ),
      width: MemoryPanelSc.EVENT_PANEL_LOGO_WIDTH,
      height: MemoryPanelSc.EVENT_PANEL_LOGO_HEIGHT,
    );

  }
  Widget showTotalAttendance(BuildContext context, List<AttendanceByGroup> attendanceByGroups) {

    if(con.screenColumns>1){
      return showTotalAttendanceLandscape(context, attendanceByGroups);
    }
    //double contaninerHeight = MediaQuery.of(context).size.height*0.13;
    MemoryPanelSc.EVENT_PANEL_LOGO_HEIGHT = 80*MemoryPanelSc.logoSizeAdjustment;
    MemoryPanelSc.EVENT_PANEL_LOGO_WIDTH = 80*MemoryPanelSc.logoSizeAdjustment;

    int total = 0;
    String eventName = MemoryPanelSc.panelScConfig.eventName ?? Messages.EMPTY;
    if(eventName == Messages.EMPTY){
      eventName = MemoryPanelSc.event.name ?? Messages.EMPTY;
    }

    // let int total = attendanceByGroups total
    total = attendanceByGroups.fold(0, (sum, item) => sum + (item.total ?? 0));
    double widthTotalAttendance = (MediaQuery.of(context).size.width-MemoryPanelSc.EVENT_PANEL_LOGO_WIDTH)/5+
        MemoryPanelSc.clockRightMarginAdjustment;
    return Container(
        width: double.infinity,
        //height: contaninerHeight,
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          //spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: eventLogo(context)),
            ),
            //SizedBox(width: widthTotalAttendance), // Add some spacing between logo and text column
            Expanded( // To make the Column take remaining space
              child: Padding(
                padding: const EdgeInsets.only(top:8,bottom:8,right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(eventName,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: con.fontSizeExtraBig,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold,

                      ),

                    ),
                    Text(
                      con.actualTime.value,
                      style: TextStyle(
                        color: MemoryPanelSc.callingColor,
                        fontSize: con.fontSizeExtraBig,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${Messages.ATTENDEES} : $total',
                      style: TextStyle(fontSize: con.fontSizeExtraBig,
                          color: MemoryPanelSc.callingColor,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //Spacer(), // To push the logo to the left and text to the right if needed, or use MainAxisAlignment.spaceBetween
          ],
        ),);
  }
  Widget showTotalAttendanceLandscape(BuildContext context, List<AttendanceByGroup> attendanceByGroups) {
    int total = 0;
    String eventName = MemoryPanelSc.panelScConfig.eventName ?? Messages.EMPTY;

    // let int total = attendanceByGroups total
    total = attendanceByGroups.fold(0, (sum, item) => sum + (item.total ?? 0));
    MemoryPanelSc.EVENT_PANEL_LOGO_HEIGHT = 120*MemoryPanelSc.logoSizeAdjustment;
    MemoryPanelSc.EVENT_PANEL_LOGO_WIDTH = 120*MemoryPanelSc.logoSizeAdjustment;
    double widthTotalAttendance = (MediaQuery.of(context).size.width-120-MemoryPanelSc.EVENT_PANEL_LOGO_WIDTH)/2;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          //spacing: 10, // Row does not have spacing, use SizedBox or MainAxisAlignment
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: eventLogo(context),
            ),
            SizedBox(width: 10), // Add some spacing between logo and text column
            Expanded( // To make the Column take remaining space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
                children: [
                  Center(
                    child: Text(eventName,
                      style: TextStyle(fontSize: con.fontSizeExtraBig,
                          color: Colors.purple,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),

                  Row(
                    //spacing: 10, // Row does not have spacing
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: widthTotalAttendance+MemoryPanelSc.clockRightMarginAdjustment,
                        alignment: Alignment.centerLeft,
                        child: Text('${Messages.ATTENDEES}: $total',
                          style: TextStyle(fontSize: con.fontSizeExtraBig,
                              color: MemoryPanelSc.callingColor,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: widthTotalAttendance,
                        child: Text(
                          con.actualTime.value, // let text  con.actualTime.value aligment end
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: MemoryPanelSc.callingColor,
                            fontSize: con.fontSizeExtraBig,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),);
  }

  Widget attendanceCard(BuildContext context, AttendanceByGroup item) {
    String placeName = item.place?.name ?? '';
    int total = item.total ?? 0;
    return Card(
      child: Container(
        width: double.infinity, // Ensure card takes full width of its grid cell
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
        child: IntrinsicHeight( // Ensures Row children have the same height
          child: Row(
            children: [
              Expanded( // placeName takes the remaining space
                child: Text(placeName, style: TextStyle(fontSize: con.fontSizeBig,
                    fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * (1/5) / con.screenColumns - 10), // Adjust width as needed, /2 because of 2 columns
              Text(total.toString(), style: TextStyle(fontSize: con.fontSizeBig,
                  fontWeight: FontWeight.bold), textAlign: TextAlign.start,),
            ],
          ),
        ),
      ),
    );

  }


  Widget showTotalAttendanceGridView(BuildContext context, List<AttendanceByGroup> attendanceByGroups) {

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: con.screenColumns, //  columns
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 10.0, // Adjust aspect ratio as needed
      ),
      itemCount: attendanceByGroups.length,
      itemBuilder: (context, index) {
        final item = attendanceByGroups[index];
        return attendanceCard(context, item);
      },
    );
  }

  Widget showTotalAttendanceListView(BuildContext context, List<AttendanceByGroup> attendanceByGroups) {
    return ListView.separated(
      itemCount: attendanceByGroups.length,
      separatorBuilder: (context, index) => SizedBox(height: 8.0), // Space between items
      itemBuilder: (context, index) {
        final item = attendanceByGroups[index];
        return attendanceCard(context, item);
      },
    );
  }

  Widget getProgressBar(BuildContext context) {
    int showProgressBarEachXTimes = MemoryPanelSc.intervalToShowProgressBar;
    if(showProgressBarEachXTimes==0){
      return Container(child: SizedBox(height: 15,));
    }

    if(count<showProgressBarEachXTimes){
      count++;
      return Container(child: SizedBox(height: 15,));
    }
    count = 0;
    return LinearProgressIndicator(minHeight: 15,color: Colors.purple,);

  }

  Widget screenHeightErrorPanel(BuildContext context) {

    return Center(
       child: Padding(
         padding: const EdgeInsets.all(8.0),
         child: Text(Messages.SCREEN_HEIGHT_ERROR,),
       )
    );
  }


}

