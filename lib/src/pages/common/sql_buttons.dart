import 'package:flutter/material.dart';

import '../../data/memory.dart';
import 'sql_buttons_controller.dart';

class SqlButtons {
  SqlButtonsController? con ;

  void setController(SqlButtonsController? controller){
     con = controller;
  }


  Widget getCompleteBar(BuildContext context) {
    double iconSize = 36 ;
    double buttomWidth = 50 ;
    double buttomHeight = 50 ;
    double space = 8;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height: buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_FIND),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.findButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_UPDATE),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.updateButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_DELITE),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.deleteButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_CREATE),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.createButtomPressed(context): Memory.functionNotEnabledYet();

                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_REFRESH),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.clearButtomPressed(context): Memory.functionNotEnabledYet();

                },
              )
          ),

        ],
      ),
    );

  }
  Widget getInsertBar(BuildContext context) {
    double iconSize = 36 ;
    double buttomWidth = 50 ;
    double buttomHeight = 50 ;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height: buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_CREATE),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.createButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),

        ],
      ),
    );

  }
  Widget getEditBar(BuildContext context) {
    double iconSize = 36 ;
    double buttomWidth = 50 ;
    double buttomHeight = 50 ;
    double space = 8;
    return  Container(
      margin: EdgeInsets.only(left: 10,right: 10),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: Memory.COLOR_BUTTOM_BAR,  // Set the desired background color
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height: buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_FIND),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.findButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_UPDATE),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.updateButtomPressed(context): Memory.functionNotEnabledYet();
                },
              )
          ),
          SizedBox(width: space,),
          ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: buttomWidth, height:  buttomHeight),
              child: IconButton(
                icon: Image.asset(Memory.IMAGE_REFRESH),
                iconSize: iconSize,
                onPressed: () {
                  con!=null ? con!.clearButtomPressed(context): Memory.functionNotEnabledYet();

                },
              )
          ),

        ],
      ),
    );

  }

}
