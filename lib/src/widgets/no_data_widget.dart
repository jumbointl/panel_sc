import 'package:flutter/material.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../data/memory.dart';

class NoDataWidget extends StatelessWidget {

  String text = Messages.NO_DATA_FOUND;
  int count =1;
  NoDataWidget({super.key, this.text = '',this.count=1});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
              count%2 == 0 ? Memory.IMAGE_0_ITEMS : Memory.IMAGE_0_ITEMS_2,
              height: 150,
              width: 150,
          ),
          SizedBox(height: 15),
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
