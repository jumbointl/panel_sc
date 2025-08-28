import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';


import '../../../../data/memory.dart';
import 'delivery_orders_map_controller.dart';

class DeliveryOrdersMapPage extends StatelessWidget {

 DeliveryOrdersMapController con = Get.put(DeliveryOrdersMapController());
  Completer<GoogleMapController> mapController = Completer();
 DeliveryOrdersMapPage({super.key});
  @override
  Widget build(BuildContext context) {

    con.context = context;
    return GetBuilder<DeliveryOrdersMapController> (
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
                  height: MediaQuery.of(context).size.height*0.6,
                  width: double.infinity,
                  child: _googleMaps()
              ),
              SafeArea(
                child: Column(
                  children: [
                    _iconCenterMyLocation(),
                    Spacer(),
                    _cardOrderInfo(context),
                  ],
                ),
              ),
              //_buttonAccept(context)
            ],
          ),
        ));
  }


  Widget _cardOrderInfo(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.30,
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
          _clientInfo(),
          _buttonAccept(context),
        ],
      ),
    );
  }

  Widget _clientInfo() {
    String society ='';
    if(con.order.idSociety==0 || con.order.society==null){
      if(con.order.user!=null ){
        String n = con.order.user!.name ?? '';
        String a = con.order.user!.lastname ?? '';
        society ='$a $n';
      }
    } else {
      society = con.order.society!.name ?? '';

    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      child: Row(
        children: [
          _imageClient(),
          SizedBox(width: 15),
          Text(society  ,
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            maxLines: 1,
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

  Widget _imageClient() {
    return SizedBox(
      height: 50,
      width: 50,
      // padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage(
          image: con.order.user!.image != null
              ? NetworkImage(con.order.user!.image!)
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

  Widget _buttonAccept(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: con.isCloseToDeliveryPosition() == true ? () => con.updateOrderToDelivered(context,con.order) :
            ()=>{con.showErrorMessages('${Messages.MUST_BE_WITHIN_PREDETERMINED_DISTANCE} : ${con.distanceBetween}')},
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(15)
            ),
            child: Text( Messages.DELIVER,
              style: TextStyle(
                  color: Colors.black
              ),
            ),

          ),
          Spacer(),
          ElevatedButton(
            onPressed: () => con.goToOrderReturnPage(con.order),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                padding: EdgeInsets.all(15)
            ),
            child: Text( Messages.RETURN,
              style: TextStyle(
                  color: Colors.black
              ),
            ),

          ),
        ],
      ),
    );
  }

  Widget _googleMaps() {

    return GoogleMap(

      initialCameraPosition: con.initialPosition,
      mapType: MapType.normal,
      cloudMapId: Memory.GOOGLE_MAP_ID,
      //onMapCreated:  (GoogleMapController controller) {mapController.complete(controller);},
      onMapCreated:  con.onMapCreate,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      markers: Set<Marker>.of(con.markers.values),
      polylines: con.polylines,
      //polylines:Set<Polyline>.of(con.polylines.values),

    );
  }
}
