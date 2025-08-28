import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';


import '../../../../data/memory.dart';
import 'client_orders_map_controller.dart';

class ClientOrdersMapPage extends StatelessWidget {

 ClientOrdersMapController con = Get.put(ClientOrdersMapController());
  Completer<GoogleMapController> mapController = Completer();
  RxBool isLoading = false.obs;
 ClientOrdersMapPage({super.key});
  @override
  Widget build(BuildContext context) {

    isLoading = con.isLoading;
    return GetBuilder<ClientOrdersMapController> (
        builder: (value) =>  Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            title: Text(
              '${Messages.ORDER} # ${con.order.id} ${Messages.FROM} : ${con.order.warehouse?.name!}',
              style: TextStyle(
                  color: Colors.black
              ),
            ),
          ),
          body: Stack(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.67,
                  width: double.infinity,
                  child: _googleMaps()
              ),
              SafeArea(
                child: Column(
                  children: [
                    _iconCenterMyLocation(),
                    Spacer(),
                    isLoading.value ? CircularProgressIndicator() : _cardOrderInfo(context),
                  ],
                ),
              ),
            ],
          ),
        ));
  }


  Widget _cardOrderInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[300]!,
                spreadRadius: 4,
                blurRadius: 6,
                offset: Offset(0, 3)
            )
          ]
      ),
      child: Column(
        children: [
          _listTileAddress(
              con.order.address?.neighborhood ?? '',
              Messages.NEIGHBORHOOD,
              Icons.my_location
          ),
          _listTileAddress(
              con.order.address?.address ?? '',
              Messages.ADDRESS,
              Icons.location_on
          ),
          //Divider(color: Colors.grey, endIndent: 10, indent: 10),
          _deliveryInfo(),
        ],
      ),
    );
  }

  Widget _deliveryInfo() {
    String delivery ='';
    String phone = con.order.delivery!.phone ?? '';
    if(con.order.delivery!=null ){
      String n = con.order.delivery!.name ?? '';
      String a = con.order.delivery!.lastname ?? '';

      delivery ='$a $n';
    } else {
      delivery = Messages.NO_DATA_FOUND;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(
        children: [
          _imageDelivery(),
          SizedBox(width: 15),
          Column(
            children: [
              Text(delivery  ,

                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
                maxLines: 2,
              ),
              Text(phone  ,

                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
                maxLines: 1,
              ),
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.grey[200]
            ),
            child: IconButton(
              onPressed: () => con.callNumber(),
              icon: Icon(Icons.phone, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _imageDelivery() {
    return SizedBox(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: con.order.delivery!.image != null
              ? NetworkImage(con.order.delivery!.image!)
              : AssetImage(Memory.IMAGE_NO_IMAGE) as ImageProvider,
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 50),
          placeholder:  AssetImage(Memory.IMAGE_NO_IMAGE),
        ),
      ),
    );
  }

  Widget _listTileAddress(String title, String subtitle, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          title,
          maxLines: 3,
          style: TextStyle(
              fontSize: 13,
              color: Colors.white

          ),
        ),
        /*
        subtitle: Text(
          subtitle,
          style: TextStyle(
              color: Colors.white
          ),
        ),

         */
        trailing: Icon(iconData, color: Colors.white,),
      ),
    );
  }

  Widget _iconCenterMyLocation() {
    return GestureDetector(
      onTap: () => con.centerPosition(),
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }



  Widget _googleMaps() {
    return GoogleMap(

      initialCameraPosition: con.initialPosition,
      cloudMapId: Memory.GOOGLE_MAP_ID,
      //mapType: MapType.normal,
      //onMapCreated:  (GoogleMapController controller) {mapController.complete(controller);},
      onMapCreated:  con.onMapCreate,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(con.markers.values),
      //polylines: con.polylines,
      polylines:Set<Polyline>.of(con.polylines2.values),

    );
  }
}
