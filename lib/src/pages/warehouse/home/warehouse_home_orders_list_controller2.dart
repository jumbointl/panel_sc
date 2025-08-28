import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import '../../../data/messages.dart';
import '../../../models/order.dart';
import '../../../models/user.dart';
import 'warehouse_orders_list_controller.dart';

class WarehouseHomeOrdersListController extends WarehouseOrdersListController {

  late Socket socket ;
  late int warehouseId=1;
  late OrderStatus status;
  late var isConnected = false.obs;
  var pageTitle = 'OFF LINE'.obs;
  WarehouseHomeOrdersListController(){
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = Memory.ROUTE_WAREHOUSE_HOME_PAGE;
    Memory.PAGE_TO_RETURN_AFTER_DELIVERY = Memory.ROUTE_WAREHOUSE_HOME_PAGE;
    removeSavedSocietiesList();
    orderStatus.add(Memory.allUncompletedOrderStatus);

    User user = getSavedUser();
    if(user.idWarehouse!=null){
      warehouseId = user.idWarehouse!;
    }
    connectAndListen();
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
          isConnected.value = true;
          //pageTitle.value = Messages.ON_LINE;
        });

        /*
        if(socket.connected){
          listenToNewOrder();
        }

         */

      }

      return true;
    } on TimeoutException catch (err) {
      /// here is the response if api call time out
      /// you can show snackBar here or where you handle api call
      pageTitle.value = Messages.OFF_LINE;
      showErrorMessages(Messages.TIME_OUT);
      isConnected.value = false;

      print(err);
      return false;
    }catch(e){
      pageTitle.value = Messages.OFF_LINE;
      isConnected.value = false;
      showErrorMessages(Messages.ERROR_SOCKET);
      print(e);
      return false;
    }

  }
  void listenToNewOrder() async{
    if(socket.connected){
      socket.on('${Memory.NODEJS_ROUTE_SOCKET_NEW_ORDER}/$warehouseId', (data) async {
        print('New Order ${Memory.NODEJS_ROUTE_SOCKET_NEW_ORDER}/$warehouseId');
        isLoading.value = false;
        int idOrderStatus = status.id!;
        List<Order>? res = await ordersProvider.getSellerOrderByStatus(context, idOrderStatus);
        orders!.clear();
        if(res==null || res.isEmpty){
          orders!.addAll(res!);
        }

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



        isLoading.value = true;

        return orders;
      });
    }
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
  }
}