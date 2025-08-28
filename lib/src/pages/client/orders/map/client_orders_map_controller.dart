import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:socket_io_client/socket_io_client.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/order.dart';
import '../../../../models/response_api.dart';
import '../../../../providers/orders_provider.dart';
import '../../../common/controller_model.dart';

class ClientOrdersMapController extends ControllerModel {
  late String url;
  late Socket socket;

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
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{}.obs;
  Map<PolylineId, Polyline> polylines2 = <PolylineId, Polyline>{}.obs;
  BitmapDescriptor? deliveryMarker;
  BitmapDescriptor? deliverySmallMarker;
  BitmapDescriptor? homeMarker;
  Set<Polyline> polylines = <Polyline>{}.obs;
  StreamSubscription? positionSubscription;
  OrdersProvider ordersProvider = OrdersProvider();
  // no usado todavia, por ahora habilita pasar a entregado en cualquier momento
  double distanceBetween = 0.0;
  double zoomValue = 11 ;
  List<LatLng> points = [];
  bool isPolyLineShowed = false;

  //bool useClientSmallIcon = true;


  ClientOrdersMapController() {



    checkGPS(); // VERIFICAR SI EL GPS ESTA ACTIVO
    setInitialPositionToClientAddress();
    String s = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
    if(s!=''){
      url = '$s${Memory.NODEJS_ROUTE_SOCKET_IO_BASE_DELIVERY}';
      socket = io(url, <String, dynamic> {
        'transports': ['websocket'],
        'autoConnect': false
      });
      connectAndListen();
    }



  }
  void connectAndListen() {
    socket.connect();
    socket.onConnect((data) {
      print('ESTE DISPISITIVO SE CONECTO A SOCKET IO');
    });
    listenPosition();
    listenToDelivered();
  }

  void listenPosition() {
    socket.on('${Memory.NODEJS_ROUTE_SOCKET_POSITION}/${order.id}', (data) {
      double lat =data['lat'];
      double lng =data['lng'];
      if(data['lat'] ==null || data['lng'] ==null){
        showErrorMessages('null/$lat/$lng');
        return;
      } else {
        showSuccessMessages('${Messages.UPDATING_DELIVERY_BOY_POSITION} :$lat,$lng');
      }
      LatLng from =  LatLng(lat,lng);
      LatLng to =  LatLng(order.address?.lat ?? Memory.INITIAL_LATITUDE,
      order.address?.lng ??  Memory.INITIAL_LONGITUDE,);

      distanceBetween = Geolocator.distanceBetween(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude,
      );
      zoomValue = Memory.getGoogleMapZoomValue(distanceBetween);

      animateCameraPosition(order.address?.lat ?? Memory.INITIAL_LATITUDE,
        order.address?.lng ??  Memory.INITIAL_LONGITUDE,);


      addMarker(
          Memory.KEY_DELIVERY,
          lat,
          lng,
          Messages.DELIVERY_BOY,
          '',
          isUseDeliverySmallIcon() ? deliverySmallMarker!: deliveryMarker!
      );

    });
  }

  void listenToDelivered() {
    if(socket.connected){
      socket.on('${Memory.NODEJS_ROUTE_SOCKET_DELIVERED}/${order.id}', (data) {
        showSuccessMessages(Messages.DELIVERED);
        Get.offNamedUntil(Memory.ROUTE_CLIENT_HOME_PAGE, (route) => false);
      });
    }
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


  void checkGPS() async {
    deliveryMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP);
    deliverySmallMarker = await createMarkerFromAssets(Memory.IMAGE_DELIVERY_MAP_SMALL);
    homeMarker = await createMarkerFromAssets(Memory.IMAGE_HOME_MAP);
    connectAndListen();
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
  Future<void> setPolylines(LatLng from, LatLng to) async {

    PointLatLng pointFrom = PointLatLng(from.latitude, from.longitude);
    PointLatLng pointTo = PointLatLng(to.latitude, to.longitude);

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
    PolylineId polylineId = PolylineId('poly');
    Polyline polyline = Polyline(
        polylineId: polylineId,
        color: Colors.red,
        points: points,
        width: 5
    );
    polylines2[polylineId] = polyline;
    /*
    if(polylines.isNotEmpty){
      for (var polyline in polylines) {
        polylines.remove(polyline);
        print('removed -- polyle ${polyline.polylineId}');
      }
    } else {
      polylines.add(polyline);
    }

     */

    polylines.add(polyline);

    update();


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

  void updateLocation() async {


    try{
      double latUser = order.address?.lat ??  Memory.INITIAL_LATITUDE;
      double lngUser = order.address?.lng ??  Memory.INITIAL_LONGITUDE;
      await addLabelMarker(
          Memory.KEY_PLACE_OF_DELIVERY,
          latUser,
          lngUser,
          //Messages.PLACE_OF_DELIVERY,
          'C'
      );
      if(order.lat == null  || order.lng ==null || order.address ==null
          || order.address!.lat ==null ||  order.address!.lng ==null){
        showErrorMessages(Messages.POSITION_OF_DELIVERY_BOY_NOT_AVAILEBLE);
        return;
      }

      double latWarehouse = order.lat ??  Memory.INITIAL_LATITUDE;
      double lngWarehouse = order.lng ??  Memory.INITIAL_LONGITUDE;

      await _determinePosition();

      LatLng from = LatLng(order.lat!, order.lng!);
      LatLng to = LatLng(latUser , lngUser);

      distanceBetween = Geolocator.distanceBetween(
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
          latWarehouse,
          lngWarehouse,
          Messages.YOUR_POSITION,
          '',
          isUseDeliverySmallIcon() ? deliverySmallMarker!: deliveryMarker!
      );

      await addLabelMarker(
          Memory.KEY_PLACE_OF_DELIVERY,
          latUser,
          lngUser,
          //Messages.PLACE_OF_DELIVERY,
          'C'
      );

    } catch(e) {
      print('${Messages.ERROR}: $e');
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
    showSuccessMessages('add marker');
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

  void updateToDelivered(BuildContext context) async {
    if (distanceBetween <= 200) {
      order.setOrderStatus(Memory.deliveredOrderStatus);
      ResponseApi responseApi = await ordersProvider.updateOrderStatus(context, order);
      Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
      if (responseApi.success == true) {
        //emitToDelivered();
        Get.offNamedUntil(Memory.ROUTE_DELIVERY_MAN_HOME_PAGE, (route) => false);
      }
    }
    else {
      Get.snackbar('Operacion no permitida', 'Debes estar mas cerca a la posicion de entrega del pedidio');
    }
  }

  void updateToReturned(BuildContext context) async {
    order.setOrderStatus(Memory.returnedOrderStatus);
    ResponseApi responseApi = await ordersProvider.updateOrderStatus(context, order);

    Fluttertoast.showToast(msg: responseApi.message ?? '', toastLength: Toast.LENGTH_LONG);
    if (responseApi.success == true) {
      //emitToDelivered();
      Get.offNamedUntil(Memory.ROUTE_DELIVERY_MAN_HOME_PAGE, (route) => false);
    }
  }

  void onMapCreate(GoogleMapController controller) {
    //controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#212121"}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#212121"}]},{"featureType":"administrative","elementType":"geometry","stylers":[{"color":"#757575"}]},{"featureType":"administrative.country","elementType":"labels.text.fill","stylers":[{"color":"#9e9e9e"}]},{"featureType":"administrative.land_parcel","stylers":[{"visibility":"off"}]},{"featureType":"administrative.locality","elementType":"labels.text.fill","stylers":[{"color":"#bdbdbd"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#181818"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"poi.park","elementType":"labels.text.stroke","stylers":[{"color":"#1b1b1b"}]},{"featureType":"road","elementType":"geometry.fill","stylers":[{"color":"#2c2c2c"}]},{"featureType":"road","elementType":"labels.text.fill","stylers":[{"color":"#8a8a8a"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#373737"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#3c3c3c"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color":"#4e4e4e"}]},{"featureType":"road.local","elementType":"labels.text.fill","stylers":[{"color":"#616161"}]},{"featureType":"transit","elementType":"labels.text.fill","stylers":[{"color":"#757575"}]},{"featureType":"water","elementType":"geometry","stylers":[{"color":"#000000"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#3d3d3d"}]}]');
    isLoading.value = true ;
    mapController.complete(controller);
    isLoading.value = false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    try{
      if(socket.connected){
        socket.disconnect();
      }

    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(Messages.TIME_OUT);
      print(err);
    }catch(e){
      showErrorMessages(Messages.ERROR_SOCKET);
      print(e);
    }
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