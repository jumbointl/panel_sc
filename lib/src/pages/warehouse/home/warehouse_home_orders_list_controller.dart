import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/warehouse/home/warehouse_orders_list_controller.dart';

import '../../../data/messages.dart';
import '../../../models/order.dart';
import '../../../models/order_status.dart';
import '../../../models/user.dart';

class WarehouseHomeOrdersListController extends WarehouseOrdersListController {
  late Socket socket ;
  late int warehouseId=1;
  Timer? _timer;
  bool connectToSocket = false;
  final Completer<bool> completer = Completer();

  WarehouseHomeOrdersListController(){
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = Memory.ROUTE_WAREHOUSE_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY = Memory.ROUTE_WAREHOUSE_HOME_PAGE;
    removeSavedSocietiesList();
    orderStatus.add(Memory.allUncompletedOrderStatus);
    User user = getSavedUser();
    if(user.idWarehouse!=null){
      warehouseId = user.idWarehouse!;
    }
    if(connectToSocket){
      connectAndListen();
    }
    //_startTimer();
    //pageRefreshTime.value = 1;

  }


  @override
  void onClose() {
    _timer?.cancel();
    try{
      if(socket.connected){
        socket.disconnect();
      }
    } catch (e){
      print(e);
    }

    super.onClose();
  }

  Future<bool> connectAndListen() async {
    String s = GetStorage().read(Memory.KEY_APP_HOST_WITH_HTTP) ?? '';
    if(s!=''){
      socket = io('$s${Memory.NODEJS_ROUTE_SOCKET_IO_BASE_DELIVERY}', <String, dynamic> {
        'transports': ['websocket'],
        'autoConnect': false
      });
    }
    try{
      if(socket.disconnected){

        socket.connect();
        socket.onConnect((data) {
          print('ESTE DISPISITIVO SE CONECTO A SOCKET IO WAREHOUSE $warehouseId');
          //pageTitle.value = Messages.ON_LINE;
        });


        if(socket.connected){
          listenToNewOrder();
        }



      }

      return true;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      showErrorMessages(Messages.TIME_OUT);

      print(err);
      return false;
    }catch(e){
      showErrorMessages(Messages.ERROR_SOCKET);
      print(e);
      return false;
    }

  }
  void listenToNewOrder() async{
    if(socket.connected){
      socket.on('${Memory.NODEJS_ROUTE_SOCKET_NEW_ORDER}/$warehouseId', (data) async {
        print('New Order ${Memory.NODEJS_ROUTE_SOCKET_NEW_ORDER}/$warehouseId');
        print(data);
      });
    }
  }
  @override
  buttonReloadPressed() async {
    _reloadOrders();
  }

  void _reloadOrders() {
    isLoading.value = true;
    orders!.clear();
    totalAmount.value =0;
    totalOrders.value =0;
    pageRefreshTime++;
    OrderStatus data = orderStatus[0];
    orderStatus.removeAt(0);
    orderStatus.insert(0, data);
    isLoading.value = false;
  }
  Future<void> _startTimer() async {
    _timer?.cancel();
    // Start a new timer that repeats every x minutes
    try{
      _timer = Timer.periodic(Duration(minutes: Memory.PAGE_REFRESH_TIME_IN_MINUTES), (timer) {
        print('-------------------------timer re started ');
        _reloadOrders();
      });
    } catch (e){
      print(e);
    }



  }


  @override
  Future<List<Order>?> getSellerOrderByStatus(BuildContext? pageContext, OrderStatus status) async {
    if(dataLoaded){
      isLoading.value = false;
      return orders;
    }

    isLoading.value = true;
    int idOrderStatus = status.id!;
    dataLoaded = true;
    orders = await ordersProvider.getSellerOrderByStatus(context, idOrderStatus);
    isLoading.value = false;
    if(orders!=null && orders!.isNotEmpty){
      totalOrders.value = orders!.length;
      double total = 0;
      for (var data in orders!) {
        if(data.total!=null){
          total = total + data.total!;
        }

      }
      totalAmount.value =total;
    }




    return orders;
  }

}