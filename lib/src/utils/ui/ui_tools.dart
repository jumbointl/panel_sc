import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/memory.dart';


class UiTools {



  static void singOut(){
    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }
  static Widget getButtomSignOut(){
    return SafeArea(child: Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 10, right: 20),

      child: IconButton(onPressed: ()=>singOut(),
        icon: Icon(Icons.logout,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }

}