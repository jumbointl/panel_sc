import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/order.dart';
import '../../providers/orders_provider.dart';

class OrdersMapController extends ControllerModel {

  late List<Order> orders;
  double zoomValue = 13 ;
  var googleMapsController = Completer<GoogleMapController>().obs;
  //Set<Polyline> polylines = <Polyline>{}.obs;
  RxMap<PolylineId, Polyline> polylines = RxMap();
  //RxMap<MarkerId, Marker> markers = RxMap();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  var dataList = <math.Point>[].obs;
  var polylineCoordinates = <LatLng>[].obs;
  Color markerColor = Colors.red[600]!;
  CameraPosition initialPosition = CameraPosition(
      target: LatLng(Memory.INITIAL_LATITUDE, Memory.INITIAL_LONGITUDE),
      zoom: 13
  );
  LatLng? addressLatLng;
  var addressName = ''.obs;
  Completer<GoogleMapController> mapController = Completer();
  String country ='';
  String city ='';
  String neighborhood ='';
  Position? position;
  bool isClose = false;

  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? deliverySmallMarker;
  BitmapDescriptor? homeMarker;

  StreamSubscription? positionSubscription;
  OrdersProvider ordersProvider = OrdersProvider();
  // no usado todavia, por ahora habilita pasar a entregado en cualquier momento
  double distanceBetween = 0.0;

  List<LatLng> points = [];
  bool isPolyLineShowed = false;



  //bool useDeliverySmallIcon = true;


  OrdersMapController() {

    renewData();
    checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
    //print('order ${order.toJson()}');

  }

  void checkGPS() async {
    deliveryMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP);
    deliverySmallMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP_SMALL);
    homeMarker = await createMarkerFromAssets(Memory.IMAGE_HOME_MAP);
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    print('locationenabled $isLocationEnabled');
    if (isLocationEnabled == true) {
      updateLocation();
    }else {
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



  void updateLocation() async {

    try{
      double latWarehouse =  Memory.INITIAL_LATITUDE;
      double lngWarehouse =  Memory.INITIAL_LONGITUDE;

      await _determinePosition();
      position = await Geolocator.getLastKnownPosition(); // LAT Y LNG (ACTUAL)

      //LatLng from = LatLng(latWarehouse, lngWarehouse);

      animateCameraPosition(position?.latitude ?? Memory.INITIAL_LATITUDE,
        position?.longitude ??  Memory.INITIAL_LONGITUDE,);

      for (var order in orders) {
        if(order.address!=null && order.address!.lat !=null && order.address!.lng !=null){
          String name = order.user!.name ?? Messages.CLIENT ;
          String lastname = order.user!.lastname ?? '' ;
          int i = order.idOrderStatus!;
          double color = BitmapDescriptor.hueMagenta;
          switch(i){
            case 0:
              color = BitmapDescriptor.hueRose;
              break;
            case 5:
              color = BitmapDescriptor.hueYellow;
              break;
            case 9:
              color = BitmapDescriptor.hueCyan;
              break;
            case 29:
              color = BitmapDescriptor.hueGreen;
              break;
            case 39:
              color = BitmapDescriptor.hueRed;
              break;
            case 49:
              color = BitmapDescriptor.hueBlue;
              break;


          }

          //addLabelMarker(order.id!.toString(), order.address!.lat!, order.address!.lng!,'');
          addMarker('C${order.id!.toString()}', order.address!.lat!, order.address!.lng!,
              '$lastname $name',order.address!.name!,
            BitmapDescriptor.defaultMarkerWithHue(color),);
        }

      }

    } catch(e) {
      print('${Messages.ERROR}: $e');
    }
  }
  void onMapCreate(GoogleMapController controller) {
    //controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    mapController.complete(controller);
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

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

  bool isUseDeliverySmallIcon() {
    bool useDeliverySmallIcon = false;
    if(zoomValue>16){
      useDeliverySmallIcon = true;
    } else {
      useDeliverySmallIcon = false;
    }
    return useDeliverySmallIcon;
  }

  void renewData() {

    if (GetStorage().read(Memory.KEY_ORDERS) is List<Order>) {
      orders = GetStorage().read(Memory.KEY_ORDERS);
    }
    else {
      orders = Order.fromJsonList(GetStorage().read(Memory.KEY_ORDERS));
    }


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
      backgroundColor: markerColor,
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
  /*
  algo() async {
    var polyline = <LatLng>[].obs;

    var pickUp = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP);
    var dest = await createMarkerFromAssets(Memory.IMAGE_HOME_MAP);

    await location.getLocation().then((l) async {
      var isOnPath = utils.PolyUtils.isLocationOnPathTolerance(
          math.Point(
            l.longitude!,
            l.latitude!,
          ),
          dataList,
          false,
          8);

      if (isOnPath) {
        math.Point currentPoint = math.Point(l.longitude!, l.latitude!);

        if (polylineCoordinates.value.length > 1) {
          var x = polylineCoordinates.value.indexWhere((e) {
            var dis = utils.SphericalUtils.computeDistanceBetween(
                currentPoint, math.Point(e.longitude, e.latitude));
            return (dis <= 5 && dis >= 0);
          });

          if (x == 0) {
            polylineCoordinates.value.removeAt(0);
          } else {
            if (x != -1) {
              polylineCoordinates.value.removeRange(0, x);
            }
          }
        }

        polyline.clear();
        polyline.value = [
          LatLng(l.latitude!, l.longitude!),
          ...polylineCoordinates.value,
        ];

        addPolyLine(polyline);
        markers.clear();

        cameraZoom.value = 18;
        Set<Circle> circles2 = {
          Circle(
            circleId: const CircleId("pickup"),
            center: LatLng(l.latitude!, l.longitude!),
            fillColor: Colors.blue.shade100.withOpacity(0.5),
            strokeColor: Colors.blue.shade100.withOpacity(0.1),
            radius: 20,
          )
        };
        circles.value = circles2;
        addMarker(
          position: LatLng(l.latitude!, l.longitude!),
          id: "pickup",
          rotation: l.heading!,
          descriptor: BitmapDescriptor.fromBytes(pickUp),
          anchor: const Offset(0.5, 0.5),
        );
        addMarker(
          position: LatLng(destLatitude.value, destLatitude.value),
          id: "dest",
          rotation: l.heading!,
          descriptor: BitmapDescriptor.fromBytes(dest),
          anchor: const Offset(0.5, 0.5),
        );

        updateCameraPositionForNavigation();
      } else {
        if (polyloading.value == false) {
          await getData();
        }
      }
    });
  }
  Future getPolyline() async {
    await googleService
        .getPolylineData(LatLng(pickLatitude.value, pickLongitude.value),
        LatLng(destLatitude.value, destLongitude.value))
        .then((data) {
      if (data["status"].toString() == "true") {
        latlngbounds.value = LatLngBounds(
            southwest: LatLng(double.parse(data["southwest"]["lat"].toString()),
                double.parse(data["southwest"]["lng"].toString())),
            northeast: LatLng(double.parse(data["northeast"]["lat"].toString()),
                double.parse(data["northeast"]["lng"].toString())));
        polylineCoordinates.clear();
        dataList.clear();
        encodedPolyline.value = data["polyline"].toString();
        polylineCoordinates.value = decodeEncodedPolyline(data["polyline"]);
        dataList.value =
            List<math.Point>.from(polylineCoordinates.map((element) {
              return math.Point(element.longitude, element.latitude);
            })).toList();
        time.value = mapConversion(data["time"].toString());
        timeWithoutParse.value = data["time"].toString();

        distance.value = data["distance"].toString();
      } else {
        if (Get.isDialogOpen == null || Get.isDialogOpen == false) {
          ResponseDialogue(type: "error", h1: "Error", h2: data["data"]);
        }
      }
    });
  }







   */



}