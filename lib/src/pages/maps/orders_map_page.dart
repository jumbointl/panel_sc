import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../data/memory.dart';
import 'orders_map_controller.dart';

class OrdersMapPage extends StatelessWidget {

  OrdersMapController con = Get.put(OrdersMapController());
  RxBool isLoading = false.obs;
  OrdersMapPage({super.key});
  @override
  Widget build(BuildContext context) {
    isLoading = con.isLoading;
    return GetBuilder<OrdersMapController> (
        builder: (value) =>  Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //buttonBack(),
                isLoading.value ? CircularProgressIndicator() : Text(
                  Messages.ORDERS,
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [

              SafeArea(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height*0.9,
                    width: double.infinity,
                    child: _googleMaps()
                ),
              ),
              //_buttonAccept(context)
            ],
          ),
        ));
  }
  Widget buttonBack(){
    return SafeArea(
      child: Container(
        //margin: EdgeInsets.only(top: 10, left: 20),
        alignment: Alignment.topLeft,
        child: IconButton(

          //onPressed: controller.buttonBackPressed,
          onPressed: ()=>{Get.toNamed(Memory.ROUTE_SELLER_HOME_PAGE),},
          icon: Icon(Icons.arrow_back_ios,
            color: Colors.white,
            size: 30,),

        ),
      ),
    );
  }
  Widget _googleMaps() {

    return GoogleMap(

      initialCameraPosition: con.initialPosition,
      cloudMapId: Memory.GOOGLE_MAP_DARK_ID,
      polylines: Set<Polyline>.of(con.polylines.values),
      markers: Set<Marker>.of(con.markers.values),
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        isLoading.value = true;
        if (con.googleMapsController.value.isCompleted) {
          con.googleMapsController.value = Completer();
        } else {
          con.googleMapsController.value.complete(controller);
        }
        isLoading.value = false;
      },

    );
  }



}
