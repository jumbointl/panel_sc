import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import 'client_address_map_controller.dart';

class ClientAddressMapPage extends StatelessWidget {

  ClientAddressMapController con = Get.put(ClientAddressMapController());
  Completer<GoogleMapController> mapController = Completer();
  ClientAddressMapPage({super.key});
  @override
  Widget build(BuildContext context) {

    return Obx(() => Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        title: Text(
          Messages.LOCATE_YOUR_ADDRESS_ON_THE_MAP,
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          _iconMyLocation(),
          _cardAddress(),
          _buttonAccept(context)
        ],
      ),
    ));
  }

  Widget _buttonAccept(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 30),
      child: ElevatedButton(
        onPressed: () => con.selectRefPoint(context),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.all(15)
        ),
        child: Text(
          Messages.SELECT_THIS_POINT,
          style: TextStyle(
            color: Colors.black
          ),
        ),

      ),
    );
  }

  Widget _cardAddress() {
    return Container(
      width: double.infinity,
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: 30),
      child: Card(
        color: Colors.grey[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            con.addressName.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconMyLocation() {
    return Container(
      margin: EdgeInsets.only(bottom: 40),
      child: Center(
        child: Image.asset(
            Memory.IMAGE_MY_LOCATION,
            width: 65,
            height: 65,
        ),
      ),
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      cloudMapId: Memory.GOOGLE_MAP_ID,
      onMapCreated:  (GoogleMapController controller) {mapController.complete(controller);},
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
          con.initialPosition = position;
      },

      onCameraIdle: () async {
        await con.setLocationDraggableInfo(); // EMPEZAR A OBTNER LA LAT Y LNG DE LA POSICION CENTRAL DEL MAPA
      },
    );
  }
}
