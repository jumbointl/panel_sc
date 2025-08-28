import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/order.dart';
import '../../../../providers/orders_provider.dart';

class SellerOrdersMapController2 extends ControllerModel {


  Order order = Order.fromJson(Get.arguments[Memory.KEY_ORDER]);
  late CameraPosition initialPosition ;
  LatLng? addressLatLng;
  var addressName = ''.obs;
  Completer<GoogleMapController> mapController = Completer();
  String country ='';
  String city ='';
  String neighborhood ='';
  Position? position;
  bool isClose = false;
  double distanceToAllowFireDeliveryBottom = Memory.VALUE_OF_METER_DELIVERY_BOY_IS_CLOSED_TO_CLIENT;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Map<PolylineId, Polyline> polylines2 = <PolylineId, Polyline>{}.obs;
  //PolylineId polylineId = PolylineId('poly');
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? deliverySmallMarker;
  BitmapDescriptor? homeMarker;
  //Set<Polyline> polylines = <Polyline>{}.obs;
  StreamSubscription? positionSubscription;
  OrdersProvider ordersProvider = OrdersProvider();
  // no usado todavia, por ahora habilita pasar a entregado en cualquier momento
  double distanceBetween = 0.0;
  double zoomValue = 11 ;
  List<LatLng> points = [];
  bool isPolyLineShowed = false;
  int count = 1;

  @override
  void onInit() {
    // TODO: implement onInit
    isLoading.value = true;
    super.onInit();
    checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
    setInitialPositionToClientAddress();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    isLoading.value = false;
  }
  void setInitialPositionToClientAddress(){
    if(order.address!=null && order.address!.lat!=null && order.address!.lng!=null ){
      initialPosition = CameraPosition(
          target: LatLng(order.address!.lat!, order.address!.lng!),
          zoom: zoomValue
      );
    } else {
      initialPosition = CameraPosition(
          target: LatLng(Memory.INITIAL_LATITUDE, Memory.INITIAL_LONGITUDE),
          zoom: zoomValue
      );
    }
  }
  void setInitialPositionToWarehouseAddress(){
    if(order.warehouse!=null && order.warehouse!.lat!=null && order.warehouse!.lng!=null ){
      initialPosition = CameraPosition(
          target: LatLng(order.warehouse!.lat!, order.warehouse!.lng!),
          zoom: zoomValue
      );
    } else {
      initialPosition = CameraPosition(
          target: LatLng(Memory.INITIAL_LATITUDE, Memory.INITIAL_LONGITUDE),
          zoom: zoomValue
      );
    }
  }

  Future setLocationDraggableInfo() async {

    double lat = initialPosition.target.latitude;
    double lng = initialPosition.target.longitude;

    List<Placemark> address = await placemarkFromCoordinates(lat, lng);

    if (address.isNotEmpty) {
      String direction = address[0].thoroughfare ?? '';
      String street = address[0].subThoroughfare ?? '';
      city = address[0].locality ?? '';
      String department = address[0].administrativeArea ?? '';
      country = address[0].country ?? '';
      neighborhood = address[0].subLocality ?? '';
      addressName.value = '$direction #$street, $city, $department';
      addressLatLng = LatLng(lat, lng);
      print('LAT Y LNG: ${addressLatLng?.latitude ?? 0} ${addressLatLng?.longitude ?? 0}');
    }

  }


  void checkGPS() async {
    deliveryMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP);
    deliverySmallMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP_SMALL);
    homeMarker = await createMarkerFromAssets(Memory.IMAGE_HOME_MAP);
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    print('locationenabled $isLocationEnabled');
    if (isLocationEnabled == true) {
      updateLocation();
    }
    else {
      bool locationGPS = await location.Location().requestService();
      if (locationGPS == true) {
        updateLocation();
      }
    }
  }
  Future<BitmapDescriptor> createMarkerFromAssets(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor descriptor = await BitmapDescriptor.asset(
        configuration, path
    );

    return descriptor;
  }

  bool useWarehouseLocation(){
    double latWarehouse = order.warehouse?.lat ??  Memory.INITIAL_LATITUDE;
    double lngWarehouse = order.warehouse?.lng ??  Memory.INITIAL_LONGITUDE;
    bool usePositionWarehouse = false;

    if(position!=null){
      if((latWarehouse-position!.latitude.abs())>0.1){
        usePositionWarehouse = true;
      }
      if((lngWarehouse-position!.longitude).abs()>0.1){
        usePositionWarehouse = true;
      }
    }
    return usePositionWarehouse;
  }
  void saveLocation() async {
    if (position != null) {
      order.address?.lat = position!.latitude;
      order.address?.lng = position!.longitude;
      await ordersProvider.updateLatLng(order);
    }
  }
  void updateLocation() async {

    try{
      double latUser = order.address?.lat ??  Memory.INITIAL_LATITUDE;
      double lngUser = order.address?.lng ??  Memory.INITIAL_LONGITUDE;
      double latWarehouse = order.warehouse?.lat ??  Memory.INITIAL_LATITUDE;
      double lngWarehouse = order.warehouse?.lng ??  Memory.INITIAL_LONGITUDE;

      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)

      // Para emulador de android studio, no consigue posicion inicial
      bool usePositionWarehouse = useWarehouseLocation();

      saveLocation();

      LatLng from = LatLng(position?.latitude ?? latWarehouse, position?.longitude ?? lngWarehouse);
      LatLng to = LatLng(latUser , lngUser);

      double distanceBetween = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );

      zoomValue = Memory.getGoogleMapZoomValue(distanceBetween);
      animateCameraPosition(position?.latitude ?? Memory.INITIAL_LATITUDE,
        position?.longitude ??  Memory.INITIAL_LONGITUDE,);

      addMarker(
          Memory.KEY_DELIVERY,
          usePositionWarehouse ? latWarehouse : position?.latitude ?? latWarehouse,
          usePositionWarehouse ? lngWarehouse : position?.longitude ?? lngWarehouse,
          Messages.YOUR_POSITION,
          '',
          isUseDeliverySmallIcon() ? deliverySmallMarker!: deliveryMarker!
      );

      await addLabelMarker(
        Memory.KEY_PLACE_OF_DELIVERY,
        latUser,
        lngUser,
        'C'
      );

      await setPolylines(from, to);
      LocationSettings locationSettings = LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 1
      );
      positionSubscription = Geolocator.getPositionStream(
          locationSettings: locationSettings,
      ).listen((Position pos ) async { // POSICION EN TIEMPO REAL
        position = pos;


        if(position!=null){
          distanceBetween = Geolocator.distanceBetween(
            position!.latitude,
            position!.longitude,
            to.latitude,
            to.longitude,
          );
          from = LatLng(position!.latitude, position!.longitude);

          zoomValue = Memory.getGoogleMapZoomValue(distanceBetween);
          addMarker(
              Memory.KEY_DELIVERY,
              position?.latitude ?? latWarehouse,
              position?.longitude ?? lngWarehouse,
              Messages.DELIVERY_BOY,
              '',
              isUseDeliverySmallIcon() ? deliverySmallMarker!: deliveryMarker!
          );
          if(isPolyLineShowed){
            animateCameraPosition(position?.latitude ?? latWarehouse, position?.longitude ?? lngWarehouse);
          } else {
            animateCameraPosition(to.latitude , to.longitude);
            isPolyLineShowed = true;
          }

        }
      });

    } catch(e) {
      print('${Messages.ERROR}: $e');
    }
  }
  Future<void> setPolylines(LatLng from, LatLng to) async {

    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);
    String id ='poly$count';

    late PolylineId polylineId;
    polylineId = PolylineId(id);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
      googleApiKey: Memory.GOOGLE_MAP_API_KEY,
      request: PolylineRequest(
        origin: pointFrom, //PointLatLng(_originLatitude, _originLongitude),
        destination: pointTo, //PointLatLng(_destLatitude, _destLongitude),
        mode: TravelMode.driving,
        //wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );
    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
      //print('point ${point.latitude} ,${point.longitude} ');
    }
    Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.red,
        points: points,
        width: 5
    );
    polylines2[polylineId] = polyline;
    //polylines.add(polyline);

    update();


  }
  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {
    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content)
    );
    markers[id] = marker;

    update();
  }
  Future<void> addLabelMarker(
      String markerId,
      double lat,
      double lng,
      String title,

      ) async {
    MarkerId id = MarkerId(markerId);

    Marker pinMarker = await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: id,
        position: LatLng(lat,lng),

      ),
      shape: MarkerShape.pin,
      title: title,
      backgroundColor: Colors.purple,
      pinOptions: PinMarkerOptions(diameter: 32),
    );
    markers[id] = pinMarker ;
    update();
  }

  Future animateCameraPosition(double lat, double lng) async {
    GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat, lng),
          zoom: zoomValue,
          bearing: 0
      )
    ));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }


    return await Geolocator.getCurrentPosition();
  }

  void callNumber() async{
    String number = order.user?.phone ?? ''; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
  void centerToClentHomePosition() {
    if (order.address!= null) {
      animateCameraPosition(order.address!.lat!, order.address!.lng!);
    }
  }
  void centerPosition() {
    if (position != null) {
      animateCameraPosition(position!.latitude, position!.longitude);
    }
  }




  void onMapCreate(GoogleMapController controller) {
    mapController.complete(controller);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    positionSubscription?.cancel();
  }

  bool isUseDeliverySmallIcon() {
    bool useDeliverySmallIcon = false;
    if(zoomValue>16){
      useDeliverySmallIcon = true;
    } else {
      useDeliverySmallIcon = false;
    }
    return useDeliverySmallIcon;
  }





}