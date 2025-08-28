import 'dart:io';

import 'package:amount_input_formatter/amount_input_formatter.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import 'package:solexpress_panel_sc/src/providers/orders_provider.dart';
import 'package:solexpress_panel_sc/src/providers/warehouses_provider.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/address.dart';
import '../../models/category.dart';
import '../../models/group.dart';
import '../../models/host.dart';
import '../../models/invoice_number.dart';
import '../../models/order.dart';
import '../../models/order_status.dart';
import '../../models/payment.dart';
import '../../models/payment_type.dart';
import '../../models/product.dart';
import '../../models/product_price_by_group.dart';
import '../../models/response_api.dart';
import '../../models/rol.dart';
import '../../models/search_result_list.dart';
import '../../models/society.dart';
import '../../models/status.dart';
import '../../models/user.dart';
import '../../models/vat.dart';
import '../../models/warehouse.dart';
import '../../providers/push_notifications_provider.dart';
import '../../utils/image/tool/image_tool_page.dart';
import 'package:input_dialog/input_dialog.dart';

import '../../utils/relative_time_util.dart';



class ControllerModel extends GetxController {
  static const int RETURN_BUTTON = 1;
  static const int MAP_BUTTON = 2;
  static const int DECLINE_BUTTON = 3;
  static const int SIGN_OUT_BUTTON = 4;
  static const int USER_BUTTON = 5;
  static const int RELOAD_BUTTON = 6;
  static const int UP_BUTTON = 7;
  String? pdfFileName;
  String? excelFileName;
  PushNotificationsProvider pushNotificationsProvider = PushNotificationsProvider();

  File? imageFile;
  int showMessageInSeconds = 3;
  SqlSerchResult? sqlSearchResult = SqlSerchResult();
  BuildContext? context;
  RxBool isLoading = false.obs;
  RxStatus pageStatus = RxStatus.empty();
  final amountFormatter = AmountInputFormatter(
    integralLength: 13,
    groupSeparator: ',',
    fractionalDigits: 0,
    decimalSeparator: '.',
  );
  bool dataLoaded = false;
  ControllerModel({
    
   this.context,
  });

  void setRols(User myUser) {
    if (myUser.roles!.length > 1) {
      for(int i=0; i < myUser.roles!.length; i++){

        switch ( myUser.roles![i].id) {
          case 1:
            myUser.roles![i] = Memory.ROL_ADMIN;
            break;
          case 2:
            myUser.roles![i] = Memory.ROL_DELIVERY_MAN;
            break;
          case 3:
            myUser.roles![i] = Memory.ROL_CLIENT;
            break;
          case 4:
            myUser.roles![i] = Memory.ROL_ORDERSPICKER;
            break;

        }

      }
    } else { // SOLO UN ROL
      myUser.roles = <Rol>[Memory.ROL_CLIENT];
    }

  }
  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_HOME_PAGE,(route)=>false);
  }
  void goToRolesPage(){
    Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE,(route)=>false);
  }
  void returnToPreviousPage(){
    Get.offNamedUntil(Memory.PAGE_TO_RETURN_FROM_CLIENT_PRODUCTS_LIST,(route)=>false);
  }


  Future<void> goToImageToolPage() async {
    imageFile = await Get.to(ImageToolPage(title: Messages.IMAGE_TOOL,));
    if(imageFile!=null){
      update();
    }
  }
  String? getFirebaseFileName(String url) {

    Uri? uri = Uri.tryParse(url);
    if(uri==null){
      return null;
    }
    //print(uri);

    //String fileName = uri.pathSegments.last.split("/o/").last;
    String file = uri.path.split("/o/").last;
    String  fileName = file.replaceAll('%2F', '/');
    //print('Filename : $fileName');
    if(fileName==''){
      return null;

    }
    return fileName;
  }

  void signOut() {

    GetStorage().remove(Memory.KEY_SHOPPING_BAG);
    GetStorage().remove(Memory.KEY_ADDRESS);
    GetStorage().remove(Memory.KEY_ORDERS);
    GetStorage().remove(Memory.KEY_ORDER);
    GetStorage().remove(Memory.KEY_AUTO_LOGIN);

    for(var key in Memory.keyToRemoveAtSignOut){
      GetStorage().remove(key);

    }
    removeSavedSocietiesList();
    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }
  Host getHostFromId(List<Host> listHost, int? parse) {
    if (parse == null) {
      return Host();
    }
    Host host = Host();
    for (var item in listHost) {
      if (item.id == parse) {
        host = item;
        break;
      }
    }
    return host;
  }
  String? getNameByIdFromObjectWithNameAndId(List<ObjectWithNameAndId>? list, int? id){
     if(list==null || list.isEmpty){
       return null;
     }
     for(int i=0; i<list.length;i++){
       ObjectWithNameAndId ob = list[i];
       if(ob.id==id){
         return ob.name;
       }
     }
     return null;
  }
  Category? getCategoryByIdFromSqlSearchResult(int? id){
    if(sqlSearchResult!.getList()==null || sqlSearchResult!.getList()!.isEmpty){
      return null;
    }
    Category? ob = sqlSearchResult!.getObjectById(id);
    return ob;

  }
  Category? getCategoryById(List<Category>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Category ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Payment? getPaymentById(List<Payment>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Payment ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  OrderStatus? getOrderStatusById(List<OrderStatus>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      OrderStatus ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  int  getPositionById(List<ObjectWithNameAndId>? list, int? id){
    if(list==null || list.isEmpty){
      return -1;
    }
    for(int i=0; i<list.length;i++){
      ObjectWithNameAndId ob = list[i];
      if(ob.id==id){
        return i ;
      }
    }
    return -1;
  }
  Group? getGroupById(List<Group>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Group ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Product? getProductById(List<Product>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Product ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  ProductPriceByGroup? getProductWithPriceById(List<ProductPriceByGroup>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      ProductPriceByGroup ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  void replaceProductById(List<Product>? list, Product data){
    if(list==null || list.isEmpty){
      return;
    }
    for(int i=0; i<list.length;i++){
      Product ob = list[i];
      if(ob.id==data.id){
        list[i] = data;
        break;
      }
    }
  }
  User? getUserById(List<User>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      User ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Society? getSocietyById(List<Society>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Society ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Vat? getVatById(List<Vat>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Vat ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Status? getStatusById(List<Status>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Status ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  Rol? getRolById(List<Rol>? list, int? id){
    if(list==null || list.isEmpty){
      return null;
    }
    for(int i=0; i<list.length;i++){
      Rol ob = list[i];
      if(ob.id==id){
        return ob ;
      }
    }
    return null;
  }
  void showErrorMessages(String message){
    Fluttertoast.showToast(
      msg: '${Messages.ERROR} : $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red[300],
      textColor: Colors.black,
      fontSize: 16.0,);
  }
  void showSuccessMessages(String message){
    Fluttertoast.showToast(
      msg: '${Messages.SUCCESS} : $message',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.lightBlue[300],
      textColor: Colors.black,
      fontSize: 16.0,);

  }
  String? getExtension(String? name){
    if(name==null){
      return '';
    }
    String s = name.split('.').last;
    return s;
  }

  Future<String> getTextFromDialog(BuildContext context, String title) async {
    final result = await InputDialog.show(
      context: context,
      title: title,
      cancelText: Messages.CANCEL,
      okText: Messages.CONFIRM,
    );
    if(result!=null){
      return  result.toString();
    }
    return '';


  }
  void saveFirebaseNotificationToken(){
    User user = getSavedUser();

    if(user.id !=null){
      pushNotificationsProvider.saveFirebaseNotificationToken(user);
    }

  }

  Map<String,String> getHeaders(){
    return Memory.getHeaders();
  }
  void saveUser(var data,String? password){


    if(data is ResponseApi){

      User user = User.fromJson(data.data);
      // para usar con postman
      print('session created at ${user.sessionToken}');
      user.password = password;
      GetStorage().write(Memory.KEY_USER,user);
    } else if(data is User) {
      GetStorage().write(Memory.KEY_USER,data.toJson());
    } else {
      return;
    }



    Memory.getHeaders();
  }
  User getSavedUser(){
    return Memory.getSavedUser();


  }


  Society getSavedClientSociety(){
    var data = GetStorage().read(Memory.KEY_CLIENT_SOCIETY) ?? {};

    if(data is Society){
      return data;
    } else if (data is Map<String,dynamic>){
      return Society.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_CLIENT_SOCIETY);
      return Society();
    }

  }
  void saveClientSociety(Society data){
    GetStorage().write(Memory.KEY_CLIENT_SOCIETY,data.toJson());
  }
  void saveSocietiesList(List<Society> data){
    GetStorage().write(Memory.KEY_SOCIETIES_LIST,data);
  }
  List<Society> getSavedSocietiesList(){
       List<dynamic> res = GetStorage().read(Memory.KEY_SOCIETIES_LIST) ?? [];
       List<Society> list = Society.fromJsonList(res);
    return list;
  }
  void saveClientCategoriesList(List<Category> data, int societyId){

    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$societyId';
    Memory.keyToRemoveAtSignOut.add(key);
    Memory.keyToRemoveAtSignOut.add(keyCreatedAt);
    Memory.keysToRemoveAfterOrderCreate.add(key);
    Memory.keysToRemoveAfterOrderCreate.add(keyCreatedAt);
    GetStorage().write(key,data);
    DateTime now = Memory.getDateTimeNowLocal();
    GetStorage().write(keyCreatedAt,now.microsecondsSinceEpoch);

  }
  Future<List<Category>?> getSavedClientCategoriesList(int societyId) async{
    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$societyId';
    List<dynamic>? res = GetStorage().read(key);
    if(res == null){
      return null;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    int saved  = GetStorage().read(keyCreatedAt) ?? 0;
    DateTime? createdAt  = RelativeTimeUtil.getDateTimeFromSavedGetStorageMicrosecondsSinceEpochLocal(saved);
    if(createdAt==null){
      return null;
    }
    var diff = now.difference(createdAt);
    if(diff.inHours > Memory.SAVED_CLIENT_LIST_EXPIRE_TIME_IN_HOURS){
      return null;
    }
    List<Category> list = Category.fromJsonList(res);
    return list;
  }

  void saveClientProductsList(List<Product> data,int societyId){
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$societyId';
    Memory.keyToRemoveAtSignOut.add(key);
    Memory.keyToRemoveAtSignOut.add(keyCreatedAt);
    Memory.keysToRemoveAfterOrderCreate.add(key);
    Memory.keysToRemoveAfterOrderCreate.add(keyCreatedAt);

    GetStorage().write(key,data);
    DateTime now = Memory.getDateTimeNowLocal();
    GetStorage().write(keyCreatedAt,now.microsecondsSinceEpoch);

  }
  Future<List<Product>?> getSavedClientProductsList(int societyId) async{
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$societyId';
    List<dynamic>? res = GetStorage().read(key);
    if(res== null){
      return null;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    int saved  = GetStorage().read(keyCreatedAt) ?? 0;
    DateTime? createdAt  = RelativeTimeUtil.getDateTimeFromSavedGetStorageMicrosecondsSinceEpochLocal(saved);
    if(createdAt==null){
      return null;
    }

    var diff = now.difference(createdAt);
    if(diff.inHours > Memory.SAVED_CLIENT_LIST_EXPIRE_TIME_IN_HOURS ){
      return null;
    }

    if(res is List<Product>) {
      return res;
    } if(res is Map<String,dynamic>) {
      List<Product> list = Product.fromJsonList(res);
      return list;
    } else {
      return null;
    }


  }
  void removeSavedClientProductsList(int societyId){
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$societyId';
    GetStorage().remove(key);
    GetStorage().remove(keyCreatedAt);
    Memory.keyToRemoveAtSignOut.remove(key);
    Memory.keyToRemoveAtSignOut.remove(keyCreatedAt);
    Memory.keysToRemoveAfterOrderCreate.remove(key);
    Memory.keysToRemoveAfterOrderCreate.remove(keyCreatedAt);


  }

  void removeSavedSocietiesList(){
    GetStorage().remove(Memory.KEY_CLIENT_SOCIETY);
    GetStorage().remove(Memory.KEY_SOCIETIES_LIST);

  }
  void removeSavedClientCategoriesList(int societyId){
    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$societyId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$societyId';
    GetStorage().remove(key);
    GetStorage().remove(keyCreatedAt);
    Memory.keyToRemoveAtSignOut.remove(key);
    Memory.keyToRemoveAtSignOut.remove(keyCreatedAt);
    Memory.keysToRemoveAfterOrderCreate.remove(key);
    Memory.keysToRemoveAfterOrderCreate.remove(keyCreatedAt);

  }
  Address getSavedAddress(){
      var data = GetStorage().read(Memory.KEY_ADDRESS) ?? {};

      if(data is Address){
        return data;
      } else if (data is Map<String,dynamic>){
        return Address.fromJson(data);
      } else {
        GetStorage().remove(Memory.KEY_ADDRESS);
        return Address();
      }

  }
  void saveAddress(Address data){

    GetStorage().write(Memory.KEY_ADDRESS,data);
  }
  Host getSavedHost(){
    var data = GetStorage().read(Memory.KEY_HOST) ?? {};

    if(data is Host){
      return data;
    } else if (data is Map<String,dynamic>){
      return Host.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_HOST);
      return Host();
    }

  }
  void saveHost(Host data){

    GetStorage().write(Memory.KEY_HOST,data);
  }
  void removeSavedHost(){
    GetStorage().remove(Memory.KEY_HOST) ;
  }


  List<Product> getSavedShoppingBag(){
    List<Product> products = [];
    if (GetStorage().read(Memory.KEY_SHOPPING_BAG) != null) {

      if (GetStorage().read(Memory.KEY_SHOPPING_BAG) is List<Product>) {
        products = GetStorage().read(Memory.KEY_SHOPPING_BAG);
      }
      else {
        products = Product.fromJsonList(GetStorage().read(Memory.KEY_SHOPPING_BAG));
      }
    }
    return products;
  }
  void saveShoppingBag(List<Product> data){
    GetStorage().write(Memory.KEY_SHOPPING_BAG,data);
  }
  void removeShoppingBag(){
    GetStorage().remove(Memory.KEY_SHOPPING_BAG) ;
  }
  void removeSavedAddress(){
    GetStorage().remove(Memory.KEY_ADDRESS) ;
  }
  Order getSavedOrder(){
    var data = GetStorage().read(Memory.KEY_ORDER) ?? {};

    if(data is Order){
      return data;
    } else if (data is Map<String,dynamic>){
      return Order.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_ORDER);
      return Order();
    }

  }
  void saveOrder(Order data){

    GetStorage().write(Memory.KEY_ORDER,data);
  }
  void removeSavedOrder(){
    GetStorage().remove(Memory.KEY_ORDER) ;
  }

  void savePayment(Payment data){

    GetStorage().write(Memory.KEY_PAYMENT,data);
  }
  void removeSavedPayment(){
    GetStorage().remove(Memory.KEY_PAYMENT) ;
  }
  Payment getSavedPayment(){
    var data = GetStorage().read(Memory.KEY_PAYMENT) ?? {};

    if(data is Payment){
      return data;
    } else if (data is Map<String,dynamic>){
      return Payment.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_PAYMENT);
      return Payment();
    }

  }
  void savePaymentType(PaymentType data){

    GetStorage().write(Memory.KEY_PAYMENT_TYPE,data);
  }
  void removeSavedPaymentType(){
    GetStorage().remove(Memory.KEY_PAYMENT_TYPE) ;
  }
  PaymentType getSavedPaymentType(){
    var data = GetStorage().read(Memory.KEY_PAYMENT_TYPE) ?? {};

    if(data is PaymentType){
      return data;
    } else if (data is Map<String,dynamic>){
      return PaymentType.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_PAYMENT_TYPE);
      return PaymentType();
    }

  }
  void saveCurrentProduct(Product data) {
    GetStorage().write(Memory.KEY_CURRENT_PROCUCT,data);
  }
  void removeSavedCurrentProduct(){
    GetStorage().remove(Memory.KEY_CURRENT_PROCUCT) ;
  }
  Product getSavedCurrentProduct(){
    var data = GetStorage().read(Memory.KEY_CURRENT_PROCUCT) ?? {};

    if(data is Product){
      return data;
    } else if (data is Map<String,dynamic>){
      return Product.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_CURRENT_PROCUCT);
      return Product();
    }

  }

  void saveInvoiceUsed(InvoiceNumber data){

    GetStorage().write(Memory.KEY_INVOICE_SAVED,data);
  }
  void removeSavedInvoiceUsed(){
    GetStorage().remove(Memory.KEY_INVOICE_SAVED) ;
  }
  InvoiceNumber getSavedInvoiceUsed(){
    var data = GetStorage().read(Memory.KEY_INVOICE_SAVED) ?? {};

    if(data is InvoiceNumber){
      return data;
    } else if (data is Map<String,dynamic>){
      return InvoiceNumber.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_INVOICE_SAVED);
      return InvoiceNumber();
    }

  }
  void saveReturnOrder(Order data){

    GetStorage().write(Memory.KEY_RETURN_ORDER,data);
  }
  void removeSavedReturnOrder(){
    GetStorage().remove(Memory.KEY_RETURN_ORDER) ;
  }
  Order getSavedReturnOrder(){
    var data = GetStorage().read(Memory.KEY_RETURN_ORDER) ?? {};

    if(data is Order){
      return data;
    } else if (data is Map<String,dynamic>){
      return Order.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_RETURN_ORDER);
      return Order();
    }

  }

  IconButton buttonBack() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonBackPressed():{},
        icon: Icon(
          Icons.arrow_back,
          color: Colors.black,
        )
    );
  }
  IconButton buttonWeb() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonWebPressed():{},
        icon: Icon(
          Icons.web,
          color: Colors.black,
        )
    );
  }
  IconButton buttonExcel() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonExcelPressed():{},
        icon: Icon(
          Icons.table_view,
          color: Colors.black,
        )
    );
  }
  IconButton buttonPdf() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonPdfPressed():{},
        icon: Icon(
          Icons.picture_as_pdf,
          color: Colors.black,
        )
    );
  }
  IconButton buttonWhatsapp() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonWhatsappPressed():{},
        icon: Image(
          image: AssetImage(Memory.IMAGE_WHATSAPP),
          color: Colors.green, // Optional: Set color if needed
        )
    );
  }
  IconButton buttonSend() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonSendPressed():{},
        icon: Icon(
          Icons.send,
          color: Colors.black,
        )
    );
  }
  IconButton buttonNext() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonNextPressed():{},
        icon: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        )
    );
  }
  IconButton buttonStore() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonStorePressed():{},
        icon: Icon(
          Icons.storefront,
          color: Colors.black,
        )
    );
  }
  IconButton buttonList() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonListPressed():{},
        icon: Icon(
          Icons.list,
          color: Colors.black,
        )
    );
  }
  IconButton buttonUp() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonUpPressed():{},
        icon: Icon(
          Icons.arrow_upward,
          color: Colors.black,
        )
    );
  }
  IconButton buttonDown() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonDownPressed():{},
        icon: Icon(
          Icons.arrow_downward,
          color: Colors.black,
        )
    );
  }
  IconButton buttonMap() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonMapPressed():{},
        icon: Icon(
          Icons.map,
          color: Colors.black,
        )
    );
  }
  IconButton buttonUser() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonUserPressed():{},
        icon: Icon(
          Icons.person,
          color: Colors.black,
        )
    );
  }
  IconButton buttonSignOut() {
    return IconButton(
        onPressed: () => !isLoading.value ?  signOut():{},
        icon: Icon(
          Icons.logout,
          color: Colors.black,
        )
    );
  }
  IconButton buttonDelivery() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonDeliveryPressed():{},
        icon: Icon(
          Icons.delivery_dining,
          color: Colors.black,
        )
    );
  }
  IconButton buttonHistory() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonHistoryPressed():{},
        icon: Icon(
          Icons.history,
          color: Colors.black,
        )
    );
  }
  IconButton buttonHome() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonHomePressed():{},
        icon: Icon(
          Icons.home,
          color: Colors.black,
        )
    );
  }
  IconButton buttonDeclined() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonDeclinedPressed():{},
        icon: Icon(
          Icons.close,
          color: Colors.black,
        )
    );
  }
  IconButton buttonReturn() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonReturnPressed():{},
        icon: Icon(
          Icons.u_turn_left,
          color: Colors.black,
        )
    );
  }
  IconButton buttonReload() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonReloadPressed():{},
        icon: Icon(
          Icons.autorenew,
          color: Colors.black,
        )
    );
  }

  void goToClientProductPage(){
    Get.offNamedUntil(Memory.ROUTE_CLIENT_ORDER_LIST_PAGE,(route)=>false);
  }
  dynamic getActionButtons(){
    return <IconButton>[buttonHome()];

  }
  double getMaximumInputFieldWidth(BuildContext context){
    double width = MediaQuery.of(context).size.width;
    if(width>Memory.minimumWideScreenWidth) {
      return Memory.minimumWideScreenWidth*0.8;
    }
    return width*0.8;
  }
  double getMarginsForMaximumColumns(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    double columnsWidth = getMaximumInputFieldWidth(context);
    double dif = screenWidth - columnsWidth;
    double marginsHorizontal = dif/2* 0.9;
    return marginsHorizontal;
  }
  buttonNextPressed() {

  }
  buttonUpPressed() {
      Get.offNamedUntil(Memory.ROUTE_ROLES_PAGE, (route)=>false);
  }

  buttonBackPressed() {
    Get.back();
  }


  buttonDownPressed() {


  }

  buttonStorePressed() {
  }

  buttonMapPressed() {

  }

  buttonUserPressed() {
    Get.toNamed(Memory.ROUTE_USER_PROFILE_INFO_PAGE);
  }

  buttonDeliveryPressed() {


  }
  buttonReloadPressed() {
    reloadData();

  }
  buttonHistoryPressed() {


  }
  PopupMenuButton popUpMenuButton(){
    return PopupMenuButton<int>(
      onSelected: (int result) {
        acctionPopMenu(result);
        print(result); // Handle what happens when an item is selected
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: ControllerModel.UP_BUTTON,
          child: Row(
            children: [

              Text(Messages.ROL),
              Spacer(),
              const Icon(Icons.group,color: Colors.black,),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: ControllerModel.USER_BUTTON,
          child: Row(
            children: [

              Text(Messages.USER),
              Spacer(),
              const Icon(Icons.person,color: Colors.black,),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: ControllerModel.SIGN_OUT_BUTTON,
          child: Row(
            children: [
              Text(Messages.LOGOUT),
              Spacer(),
              const Icon(Icons.logout,color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }
  List<PopupMenuItem> getPopMenu(){
    return [
      // PopupMenuItem 1
      PopupMenuItem(
        value: ControllerModel.RETURN_BUTTON,
        // row with 2 children
        child: Row(
          children: [
            const Icon(Icons.u_turn_left),
            SizedBox(width: 10,),
            Text(Messages.RETURNED)
          ],
        ),
      ),
      // PopupMenuItem 2
      PopupMenuItem(
        value: ControllerModel.DECLINE_BUTTON,
        // row with two children
        child: Row(
          children: [
            const Icon(Icons.close),
            SizedBox(
              width: 10,
            ),
            Text(Messages.DESIST)
          ],
        ),
      ),
      PopupMenuItem(
        value: ControllerModel.DECLINE_BUTTON,
        // row with two children
        child: Row(
          children: [
            const Icon(Icons.unpublished),
            SizedBox(
              width: 10,
            ),
            Text(Messages.DESIST)
          ],
        ),
      ),
    ];
  }
  void acctionPopMenu(int option){
    switch(option){
      case ControllerModel.RETURN_BUTTON:
        buttonReturnPressed();
        break;
      case ControllerModel.DECLINE_BUTTON:
        buttonDeclinedPressed();
        break;
      case ControllerModel.USER_BUTTON:
        buttonUserPressed();
        break;
      case ControllerModel.SIGN_OUT_BUTTON:
        signOut();
        break;
      case ControllerModel.UP_BUTTON:
        buttonUpPressed();
        break;
    }
  }
  buttonHomePressed() {}

  buttonDeclinedPressed() {}

  buttonReturnPressed() {}
  Future<void> updateOrderToDelivered(BuildContext context,Order order) async {

    if(order.credit!=null && order.credit!.id == Memory.CREDIT_WITH_INVOICE_AT_DELIVERY_ID){
      Get.toNamed(Memory.ROUTE_DELIVERY_MAN_INVOICE_NUMBER_PAGE,arguments: {Memory.KEY_ORDER: order.toJson(),});
      return;


    } else if(order.idPaymentType == Memory.PAYMENT_CASH_ON_DELIVERY_ID){
      String m =Memory.currencyFormatter.format(order.total);
      if (!await confirm(
        context,
        title: Text(Messages.DID_YOU_RECEIVE_THE_ORDER_AMOUNT,style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold
        ),),
        content: Text(m,style: TextStyle(
            color: Colors.redAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
        textOK:  Text(Messages.YES,style: TextStyle(
            color: Colors.redAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold
        ),),
        textCancel: Text(Messages.NO, style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),

      )) {
        print('pressedCancel');
        return ;
      }
    }

    OrdersProvider ordersProvider = OrdersProvider();
    order.setOrderStatus(Memory.deliveredOrderStatus);
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateOrderStatus(context,order);
    isLoading.value = false;
    if (responseApi.success == true) {
      Get.offNamedUntil(Memory.PAGE_TO_RETURN_AFTER_DELIVERY, (route) => false);
    }

  }
  Future<void> updateOrderToCanceled(BuildContext context, Order order) async {
    order.setOrderStatus(Memory.canceledOrderStatus);
    OrdersProvider ordersProvider = OrdersProvider();
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateOrderStatus(context,order);
    isLoading.value = false;
    if (responseApi.success == true) {
      Get.offNamedUntil(Memory.ROUTE_SELLER_HOME_PAGE, (route) => false);
    }

  }
  Future<void> updateOrderToSettlement(BuildContext context, Order order) async {
    order.setOrderStatus(Memory.settlementOrderStatus);
    OrdersProvider ordersProvider = OrdersProvider();
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateOrderToSettlement(context,order);
    isLoading.value = false;
    if (responseApi.success == true) {
      buttonReloadPressed();
    }

  }
  Future<void> updateOrderToShipped(BuildContext context, Order order) async {
    User user = getSavedUser();
    WarehousesProvider warehousesProvider = WarehousesProvider();
    if(order.warehouse == null || order.warehouse?.lat == null || order.warehouse?.lng==null){
      if(user.warehouse==null){
        List<Warehouse>? warehouses = await warehousesProvider.getById(null, user.id!);
        if (warehouses==null || warehouses.isEmpty) {
          showErrorMessages('${Messages.WAREHOUSE} : ${Messages.USER}');
          return;
        } else {
          user.warehouse = warehouses[0];
          order.warehouse = user.warehouse ;
        }

      } else {
        order.warehouse = user.warehouse ;
      }
    }
    order.lat = order.warehouse?.lat;
    order.lng = order.warehouse?.lat;
    OrdersProvider ordersProvider = OrdersProvider();
    order.setOrderStatus(Memory.shippedOrderStatus);
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateToShipped(context,order);
    isLoading.value = false;
    if (responseApi.success == true) {
      Get.offNamedUntil(Memory.ROUTE_SELLER_HOME_PAGE, (route) => false);
    }

  }
  Future<void> updateOrderToPaidAndSetDeliveryIdNull(BuildContext context, Order order) async {
    OrdersProvider ordersProvider = OrdersProvider();
    order.setOrderStatus(Memory.paidApprovedOrderStatus);
    isLoading.value = true;
    ResponseApi responseApi = await ordersProvider.updateToPaidAndSetDeliveryIdNull(context,order);
    isLoading.value = false;
    if (responseApi.success == true) {
      Get.offNamedUntil(Memory.ROUTE_SELLER_HOME_PAGE, (route) => false);
    }

  }
  void goToOrderReturnPage(Order order){
    if(order.id==null){
      showErrorMessages(Messages.ORDERS);
    }
    saveReturnOrder(order);
    Get.toNamed(Memory.ROUTE_SELLER_ORDER_RETURN_PAGE,
        arguments: {Memory.KEY_ORDER: order.toJson(),});
  }
  void removeKeysAfterOrderCreate(Order order){
    removeSavedClientCategoriesList(order.idSociety!);
    removeSavedClientProductsList(order.idSociety!);
    Memory.clientCategoriesList = null ;
    Memory.clientProductsList = null ;

    for (var element in Memory.keysToRemoveAfterOrderCreate) {
      GetStorage().remove(element);
    }
  }
  void reloadData() {

  }

  void buttonListPressed() {}

  void buttonWebPressed() {
    Get.toNamed(
      Memory.ROUTE_WEB_VIEW_PAGE,
      arguments: Memory.WEB_URL,
    );
  }
  void buttonExcelPressed() {
    Get.toNamed(
      Memory.ROUTE_EXCEL_PAGE,
    );
  }

  void buttonWhatsappPressed() {

  }

  void buttonSendPressed() {

  }
  void buttonPdfPressed() {

  }
  Society? readSocietyFromGetArgument(String key){
    var data = Get.arguments[key];
    if(data ==null){
      return null;
    }
    Society society = Society();
    if(data is Society){
      society = data;
    } else if(data is Map<String,dynamic>){
      society = Society.fromJson(data);
    } else {
      return null;
    }
    return society;

  }

}
