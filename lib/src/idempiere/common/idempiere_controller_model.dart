import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:amount_input_formatter/amount_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:postgres/postgres.dart';
import 'package:solexpress_panel_sc/src/data/memory_panel_sc.dart';
import 'package:solexpress_panel_sc/src/models/attendance_by_group.dart';
import 'package:solexpress_panel_sc/src/models/object_with_name_and_id.dart';
import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/attendance.dart';
import '../../models/host.dart';
import '../../models/idempiere/idempiere_POS.dart';
import '../../models/idempiere/idempiere_UOM.dart';
import '../../models/idempiere/idempiere_business_partner.dart';
import '../../models/idempiere/idempiere_business_partner_location.dart';
import '../../models/idempiere/idempiere_city.dart';
import '../../models/idempiere/idempiere_country.dart';
import '../../models/idempiere/idempiere_currency.dart';
import '../../models/idempiere/idempiere_location.dart';
import '../../models/idempiere/idempiere_locator.dart';
import '../../models/idempiere/idempiere_object.dart';
import '../../models/idempiere/idempiere_organization.dart';
import '../../models/idempiere/idempiere_price_list.dart';
import '../../models/idempiere/idempiere_price_list_version.dart';
import '../../models/idempiere/idempiere_product.dart';
import '../../models/idempiere/idempiere_product_brand.dart';
import '../../models/idempiere/idempiere_product_category.dart';
import '../../models/idempiere/idempiere_product_line.dart';
import '../../models/idempiere/idempiere_product_price.dart';
import '../../models/idempiere/idempiere_region.dart';
import '../../models/idempiere/idempiere_sales_region.dart';
import '../../models/idempiere/idempiere_tax.dart';
import '../../models/idempiere/idempiere_tax_category.dart';
import '../../models/idempiere/idempiere_tenant_with_detail.dart';
import '../../models/idempiere/idempiere_transaction.dart';
import '../../models/idempiere/idempiere_user.dart';
import '../../models/idempiere/idempiere_user_with_detail.dart';
import '../../models/idempiere/idempiere_warehouse.dart';
import '../../models/invoice_number.dart';
import '../../models/order.dart';
import '../../models/panel_sc_config.dart';
import '../../models/payment.dart';
import '../../models/payment_type.dart';
import '../../models/place.dart';
import '../../models/pos.dart';
import '../../models/search_result_list.dart';
import '../../models/sol_express_event.dart';
import '../../models/ticket.dart';
import '../../models/ticket_owner.dart';
import '../../providers/push_notifications_provider.dart';
import '../../utils/image/tool/image_tool_page.dart';
import 'package:input_dialog/input_dialog.dart';




class IdempiereControllerModel extends GetxController {
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
  RxBool downloadingFile = false.obs;
  RxString downloadUrl = ''.obs;
  RxInt totalFilesToDownload = 0.obs;
  RxInt currentDownloadFileIndex = 0.obs;
  RxBool allFilesDownloaded = false.obs;

  final amountFormatter = AmountInputFormatter(
    integralLength: 13,
    groupSeparator: ',',
    fractionalDigits: 0,
    decimalSeparator: '.',
  );
  bool dataLoaded = false;


  void goToHomePage(){
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_HOME_PAGE,(route)=>false);
  }
  void goToRolesPage(){
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_ROLES_PAGE,(route)=>false);
  }
  void returnToPreviousPage(){

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

  void signOut() async {

    IdempiereUser user = getSavedIdempiereUser();

    bool b = GetStorage().read(Memory.KEY_REMEMBER_ME) ?? false;
    if (b) {
      GetStorage().remove(Memory.KEY_IDEMPIERE_USER);
    } else {
      user.token = null;
      user.refreshToken = null;
      user.tokenCreatedAt = null;
      user.refreshTokenCreatedAt = null;
      GetStorage().write(Memory.KEY_IDEMPIERE_USER, user);
    }
    Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false);
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

  IdempiereUser getSavedIdempiereUser(){
    var data = GetStorage().read(Memory.KEY_IDEMPIERE_USER) ?? {};

    if(data is IdempiereUser){
      return data;
    } else if (data is Map<String,dynamic>){
      return IdempiereUser.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_IDEMPIERE_USER);
      return IdempiereUser();
    }

  }
  void saveIdempiereUser(IdempiereUser data){
    GetStorage().write(Memory.KEY_IDEMPIERE_USER,data.toJson());
  }
  void saveIdempiereUserList(List<IdempiereUser> data){
    GetStorage().write(Memory.KEY_IDEMPIERE_USERS_LIST,data);
  }
  List<IdempiereUser> getSavedIdempiereUserList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_USERS_LIST) ?? [];
    if(res is List<IdempiereUser>){
      return res ;
    }
    List<IdempiereUser> list = IdempiereUser.fromJsonList(res);
    return list;
  }
  
  IdempiereObject getSavedIdempiereObject(){
    var data = GetStorage().read(Memory.KEY_IDEMPIERE_OBJECT) ?? {};

    if(data is IdempiereObject){
      return data;
    } else if (data is Map<String,dynamic>){
      return IdempiereObject.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_IDEMPIERE_OBJECT);
      return IdempiereObject();
    }

  }
  void saveIdempiereObject(IdempiereObject data){
    GetStorage().write(Memory.KEY_IDEMPIERE_OBJECT,data.toJson());
  }



  void saveIdempiereBusinessPartnersList(List<IdempiereBusinessPartner> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LIST,data);
  }

  List<IdempiereBusinessPartner> getSavedIdempiereBusinessPartnersList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LIST) ?? [];
    if(res is List<IdempiereBusinessPartner>){
      return res ;
    }
    List<IdempiereBusinessPartner> list = IdempiereBusinessPartner.fromJsonList(res);
    return list;
  }

  void removeSavedIdempiereBusinessPartnersList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LIST) ;
  }

  void saveIdempiereProductsCategoriesList(List<IdempiereProductCategory> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRODUCT_CATEGORY_LIST,data);
  }

  List<IdempiereProductCategory> getSavedIdempiereProductsCategoriesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRODUCT_CATEGORY_LIST) ?? [];
    if(res is List<IdempiereProductCategory>){
      return res ;
    }
    List<IdempiereProductCategory> list = IdempiereProductCategory.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereProductsCategoriesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRODUCT_CATEGORY_LIST) ;
  }

  void saveIdempiereProductsBrandsList(List<IdempiereProductBrand> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRODUCT_BRAND_LIST,data);
  }

  List<IdempiereProductBrand> getSavedIdempiereProductsBrandsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRODUCT_BRAND_LIST) ?? [];
    if(res is List<IdempiereProductBrand>){
      return res ;
    }
    List<IdempiereProductBrand> list = IdempiereProductBrand.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereProductsBrandsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRODUCT_BRAND_LIST) ;
  }







  void saveIdempiereObjectList(List<IdempiereObject> data){
    GetStorage().write(Memory.KEY_IDEMPIERE_OBJECTS_LIST,data);
  }
  
  
  List<IdempiereObject> getSavedIdempiereObjectList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_OBJECTS_LIST) ?? [];
    if(res is List<IdempiereObject>){
      return res ;
    }
    List<IdempiereObject> list = IdempiereObject.fromJsonList(res);
    return list;
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

  Host getSavedUserHost(){
    var data = GetStorage().read(Memory.KEY_USER_HOST) ?? {};

    if(data is Host){
      return data;
    } else if (data is Map<String,dynamic>){
      return Host.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_USER_HOST);
      return Host();
    }

  }
  void saveUserHost(Host data){

    GetStorage().write(Memory.KEY_USER_HOST,data);
  }
  void removeSavedUserHost(){
    GetStorage().remove(Memory.KEY_USER_HOST) ;
  }



  List<IdempiereProduct> getSavedShoppingBag(){
    List<IdempiereProduct> idempiereProducts = [];
    if (GetStorage().read(Memory.KEY_SHOPPING_BAG) != null) {

      if (GetStorage().read(Memory.KEY_SHOPPING_BAG) is List<IdempiereProduct>) {
        idempiereProducts = GetStorage().read(Memory.KEY_SHOPPING_BAG);
      }
      else {
        idempiereProducts = IdempiereProduct.fromJsonList(GetStorage().read(Memory.KEY_SHOPPING_BAG));
      }
    }
    return idempiereProducts;
  }
  void saveShoppingBag(List<IdempiereProduct> data){
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
  void saveCurrentProduct(IdempiereProduct data) {
    GetStorage().write(Memory.KEY_CURRENT_PROCUCT,data);
  }
  void removeSavedCurrentProduct(){
    GetStorage().remove(Memory.KEY_CURRENT_PROCUCT) ;
  }
  IdempiereProduct getSavedCurrentProduct(){
    var data = GetStorage().read(Memory.KEY_CURRENT_PROCUCT) ?? {};

    if(data is IdempiereProduct){
      return data;
    } else if (data is Map<String,dynamic>){
      return IdempiereProduct.fromJson(data);
    } else {
      GetStorage().remove(Memory.KEY_CURRENT_PROCUCT);
      return IdempiereProduct();
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
  void saveClientCategoriesList(List<IdempiereProductCategory> data, int userId){

    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$userId';
    GetStorage().write(key,data);
    DateTime now = Memory.getDateTimeNowLocal();
    GetStorage().write(keyCreatedAt,now.toIso8601String());

  }
  Future<List<IdempiereProductCategory>?> getSavedClientCategoriesList(int userId) async{
    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$userId';
    List<dynamic>? res = GetStorage().read(key);
    if(res == null){
      return null;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    String saved  = GetStorage().read(keyCreatedAt) ?? '';
    DateTime? createdAt  = DateTime.tryParse(saved);
    if(createdAt==null){
      return null;
    }
    var diff = now.difference(createdAt);
    if(diff.inHours > Memory.SAVED_CLIENT_LIST_EXPIRE_TIME_IN_HOURS){
      return null;
    }
    List<IdempiereProductCategory> list = IdempiereProductCategory.fromJsonList(res);
    return list;
  }
  void removeSavedClientCategoriesList(int userId){
    String key = '${Memory.KEY_CLIENT_CATEGORIES_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT}_$userId';
    GetStorage().remove(key);
    GetStorage().remove(keyCreatedAt);
  }
  void saveClientProductsList(List<IdempiereProduct> data,int userId){
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$userId';

    GetStorage().write(key,data);
    DateTime now = Memory.getDateTimeNowLocal();
    GetStorage().write(keyCreatedAt,now.toIso8601String());

  }
  Future<List<IdempiereProduct>?> getSavedClientProductsList(int userId) async{
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$userId';
    List<dynamic>? res = GetStorage().read(key);
    if(res== null){
      return null;
    }
    DateTime now = Memory.getDateTimeNowLocal();
    String saved  = GetStorage().read(keyCreatedAt) ?? '';
    DateTime? createdAt  = DateTime.tryParse(saved);
    if(createdAt==null){
      return null;
    }

    var diff = now.difference(createdAt);
    if(diff.inHours > Memory.SAVED_CLIENT_LIST_EXPIRE_TIME_IN_HOURS ){
      return null;
    }

    if(res is List<IdempiereProduct>) {
      return res;
    } if(res is Map<String,dynamic>) {
      List<IdempiereProduct> list = IdempiereProduct.fromJsonList(res);
      return list;
    } else {
      return null;
    }


  }
  void removeSavedClientProductsList(int userId){
    String key = '${Memory.KEY_CLIENT_PRODUCTS_LIST}_$userId';
    String keyCreatedAt = '${Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT}_$userId';
    GetStorage().remove(key);
    GetStorage().remove(keyCreatedAt);

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
  IconButton buttonMore() {
    return IconButton(
        onPressed: () => !isLoading.value ?  buttonMorePressed():{},
        icon: Icon(
          Icons.more_vert,
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


  dynamic getActionButtons(){
    return <Widget>[buttonHome(),popUpMenuButton()];

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
        actionPopMenu(result);
        print(result); // Handle what happens when an item is selected
      },

      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
          value: IdempiereControllerModel.UP_BUTTON,
          child: Row(
            children: [

              Text(Messages.ROL),
              Spacer(),
              const Icon(Icons.group,color: Colors.black,),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: IdempiereControllerModel.USER_BUTTON,
          child: Row(
            children: [

              Text(Messages.USER),
              Spacer(),
              const Icon(Icons.person,color: Colors.black,),
            ],
          ),
        ),
        PopupMenuItem<int>(
          value: IdempiereControllerModel.SIGN_OUT_BUTTON,
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
        value: IdempiereControllerModel.RETURN_BUTTON,
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
        value: IdempiereControllerModel.DECLINE_BUTTON,
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
        value: IdempiereControllerModel.DECLINE_BUTTON,
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
  void actionPopMenu(int option){
    switch(option){
      case IdempiereControllerModel.RETURN_BUTTON:
        buttonReturnPressed();
        break;
      case IdempiereControllerModel.DECLINE_BUTTON:
        buttonDeclinedPressed();
        break;
      case IdempiereControllerModel.USER_BUTTON:
        buttonUserPressed();
        break;
      case IdempiereControllerModel.SIGN_OUT_BUTTON:
        signOut();
        break;
      case IdempiereControllerModel.UP_BUTTON:
        buttonUpPressed();
        break;
    }
  }
  buttonHomePressed() {}

  buttonDeclinedPressed() {}

  buttonReturnPressed() {}


  void reloadData() {

  }

  void buttonListPressed() {}

  void buttonWebPressed() {

  }
  void buttonExcelPressed() {

  }

  void buttonWhatsappPressed() {

  }

  void buttonSendPressed() {

  }
  void buttonPdfPressed() {

  }

  int getPositionById(List<IdempiereProductCategory> categories, int id) {
    for(int i=0; i<categories.length;i++){
      if(categories[i].id==id){
        return i;
      }
    }
    return 0;
  }
  void extractCategoriesFromProductsList(List<IdempiereProduct> productsList, List<IdempiereProductCategory> categories) {
    categories.clear();
    IdempiereProductCategory category = IdempiereProductCategory(id: Memory.ALL_CATEGORIES_ID, identifier: Messages.ALL_CATEGORIES);
    categories.add(category);
    if (productsList.isEmpty) {
      return;
    }
    isLoading.value = true;
    for (int i = 0; i < productsList.length; i++) {
      IdempiereProductCategory category = productsList[i].mProductCategoryID ??
          IdempiereProductCategory();
      bool exist = false;
      for (int j = 0; j < categories.length; j++) {
        if (category.id != null && categories[j].id == category.id) {
          exist = true;
          break;
        }
      }
      if (!exist) {
        categories.add(category);
      }
    }
    isLoading.value = false;
  }

  void saveIdempiereCountriesList(List<IdempiereCountry> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_COUNTRY_LIST,data);
  }

  List<IdempiereCountry> getSavedIdempiereCountriesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_COUNTRY_LIST) ?? [];
    if(res is List<IdempiereCountry>){
      return res ;
    }
    List<IdempiereCountry> list = IdempiereCountry.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereCountriesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_COUNTRY_LIST) ;
  }

  void saveIdempiereCitiesList(List<IdempiereCity> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_CITY_LIST,data);
  }

  List<IdempiereCity> getSavedIdempiereCitiesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_CITY_LIST) ?? [];
    if(res is List<IdempiereCity>){
      return res ;
    }
    List<IdempiereCity> list = IdempiereCity.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereCitiesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_CITY_LIST) ;
  }

  void saveIdempiereCurrenciesList(List<IdempiereCurrency> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_CURRENCY_LIST,data);
  }

  List<IdempiereCurrency> getSavedIdempiereCurrenciesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_CURRENCY_LIST) ?? [];
    if(res is List<IdempiereCurrency>){
      return res ;
    }
    List<IdempiereCurrency> list = IdempiereCurrency.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereCurrenciesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_CURRENCY_LIST) ;
  }
  void saveIdempiereRegionsList(List<IdempiereRegion> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_REGION_LIST,data);
  }

  List<IdempiereRegion> getSavedIdempiereRegionsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_REGION_LIST) ?? [];
    if(res is List<IdempiereRegion>){
      return res ;
    }
    List<IdempiereRegion> list = IdempiereRegion.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereRegionsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_REGION_LIST) ;
  }
  void saveIdempiereSalesRegionsList(List<IdempiereSalesRegion> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_SALES_REGION_LIST,data);
  }

  List<IdempiereSalesRegion> getSavedIdempiereSalesRegionsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_SALES_REGION_LIST) ?? [];
    if(res is List<IdempiereSalesRegion>){
      return res ;
    }
    List<IdempiereSalesRegion> list = IdempiereSalesRegion.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereSalesRegionsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_SALES_REGION_LIST) ;
  }
  void saveIdempiereLocationsList(List<IdempiereLocation> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_LOCATION_LIST,data);
  }

  List<IdempiereLocation> getSavedIdempiereLocationsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_LOCATION_LIST) ?? [];
    if(res is List<IdempiereLocation>){
      return res ;
    }
    List<IdempiereLocation> list = IdempiereLocation.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereLocationsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_LOCATION_LIST) ;
  }
  void saveIdempiereLocatorsList(List<IdempiereLocator> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_LOCATOR_LIST,data);
  }

  List<IdempiereLocator> getSavedIdempiereLocatorsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_LOCATOR_LIST) ?? [];
    if(res is List<IdempiereLocator>){
      return res ;
    }
    List<IdempiereLocator> list = IdempiereLocator.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereLocatorsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_LOCATOR_LIST) ;
  }
  void saveIdempiereWarehousesList(List<IdempiereWarehouse> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_WAREHOUSE_LIST,data);
  }

  List<IdempiereWarehouse> getSavedIdempiereWarehousesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_WAREHOUSE_LIST) ?? [];
    if(res is List<IdempiereWarehouse>){
      return res ;
    }
    List<IdempiereWarehouse> list = IdempiereWarehouse.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereWarehousesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_WAREHOUSE_LIST) ;
  }
  void saveIdempiereOrganizationsList(List<IdempiereOrganization> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_ORGANIZATION_LIST,data);
  }

  List<IdempiereOrganization> getSavedIdempiereOrganizationsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_ORGANIZATION_LIST) ?? [];
    if(res is List<IdempiereOrganization>){
      return res ;
    }
    List<IdempiereOrganization> list = IdempiereOrganization.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereOrganizationsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_ORGANIZATION_LIST) ;
  }
  void saveIdempiereUserWithDetailsList(List<IdempiereUserWithDetail> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_USER_WITH_DETAIL_LIST,data);
  }
  List<IdempiereUserWithDetail> getSavedIdempiereUserWithDetailsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_USER_WITH_DETAIL_LIST) ?? [];
    if(res is List<IdempiereUserWithDetail>){
      return res ;
    }
    List<IdempiereUserWithDetail> list = IdempiereUserWithDetail.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereUserWithDetailsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_USER_WITH_DETAIL_LIST) ;
  }
  void saveIdempiereProductsLinesList(List<IdempiereProductLine> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRODUCT_LINE_LIST,data);
  }

  List<IdempiereProductLine> getSavedIdempiereProductsLinesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRODUCT_LINE_LIST) ?? [];
    if(res is List<IdempiereProductLine>){
      return res ;
    }
    List<IdempiereProductLine> list = IdempiereProductLine.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereProductsLinesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRODUCT_LINE_LIST) ;
  }
  void saveIdempiereTaxesCategoriesList(List<IdempiereTaxCategory> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_TAX_CATEGORY_LIST,data);
  }

  List<IdempiereTaxCategory> getSavedIdempiereTaxesCategoriesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_TAX_CATEGORY_LIST) ?? [];
    if(res is List<IdempiereTaxCategory>){
      return res ;
    }
    List<IdempiereTaxCategory> list = IdempiereTaxCategory.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereTaxesCategoriesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_TAX_CATEGORY_LIST) ;
  }
  void saveIdempiereTaxesList(List<IdempiereTax> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_TAX_LIST,data);
  }

  List<IdempiereTax> getSavedIdempiereTaxesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_TAX_LIST) ?? [];
    if(res is List<IdempiereTax>){
      return res ;
    }
    List<IdempiereTax> list = IdempiereTax.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereTaxesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_TAX_LIST) ;
  }

  void saveIdempiereTenantWithDetailsList(List<IdempiereTenantWithDetail> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_TENANT_WITH_DETAIL_LIST,data);
  }
  List<IdempiereTenantWithDetail> getSavedIdempiereTenantWithDetailsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_TENANT_WITH_DETAIL_LIST) ?? [];
    if(res is List<IdempiereTenantWithDetail>){
      return res ;
    }
    List<IdempiereTenantWithDetail> list = IdempiereTenantWithDetail.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereTenantWithDetailsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_TENANT_WITH_DETAIL_LIST) ;
  }

  void saveIdempiereBusinessPartnerLocationsList(List<IdempiereBusinessPartnerLocation> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LOCATIONS_LIST,data);
  }

  List<IdempiereBusinessPartnerLocation> getSavedIdempiereBusinessPartnerLocationsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LOCATIONS_LIST) ?? [];
    if(res is List<IdempiereBusinessPartnerLocation>){
      return res ;
    }
    List<IdempiereBusinessPartnerLocation> list = IdempiereBusinessPartnerLocation.fromJsonList(res);
    return list;
  }

  void removeSavedIdempiereBusinessPartnerLocationsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_BUSINESS_PARTNERS_LOCATIONS_LIST) ;
  }
  void saveIdempierePriceListsList(List<IdempierePriceList> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRICE_LISTS_LIST,data);
  }
  List<IdempierePriceList> getSavedIdempierePriceListsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRICE_LISTS_LIST) ?? [];
    if(res is List<IdempierePriceList>){
      return res ;
    }
    List<IdempierePriceList> list = IdempierePriceList.fromJsonList(res);
    return list;
  }
  void removeSavedIdempierePriceListsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRICE_LISTS_LIST) ;
  }
  void saveIdempiereProductsPricesList(List<IdempiereProductPrice> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRODUCT_PRICE_LIST,data);
  }

  List<IdempiereProductPrice> getSavedIdempiereProductsPricesList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRODUCT_PRICE_LIST) ?? [];
    if(res is List<IdempiereProductPrice>){
      return res ;
    }
    List<IdempiereProductPrice> list = IdempiereProductPrice.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereProductsPricesList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRODUCT_PRICE_LIST) ;
  }


  void saveIdempierePriceListVersionList(List<IdempierePriceListVersion> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_PRICE_LIST_VERSION_LIST,data);
  }
  List<IdempierePriceListVersion> getSavedIdempierePriceListVersionList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_PRICE_LIST_VERSION_LIST) ?? [];
    if(res is List<IdempierePriceListVersion>){
      return res ;
    }
    List<IdempierePriceListVersion> list = IdempierePriceListVersion.fromJsonList(res);
    return list;
  }
  void removeSavedIdempierePriceListVersionList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_PRICE_LIST_VERSION_LIST) ;
  }
  void saveIdempiereTransactionsList(List<IdempiereTransaction> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_TRANSACTION_LIST,data);
  }

  List<IdempiereTransaction> getSavedIdempiereTransactionsList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_TRANSACTION_LIST) ?? [];
    if(res is List<IdempiereTransaction>){
      return res ;
    }
    List<IdempiereTransaction> list = IdempiereTransaction.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereTransactionsList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_TRANSACTION_LIST) ;
  }
  void saveIdempierePOSList(List<IdempierePOS> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_POS_LIST,data);
  }

  List<IdempierePOS> getSavedIdempierePOSList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_POS_LIST) ?? [];
    if(res is List<IdempierePOS>){
      return res ;
    }
    List<IdempierePOS> list = IdempierePOS.fromJsonList(res);
    return list;
  }
  void removeSavedIdempierePOSList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_POS_LIST) ;
  }
  void saveIdempiereUOMList(List<IdempiereUOM> data) {

    GetStorage().write(Memory.KEY_IDEMPIERE_UOM_LIST,data);
  }

  List<IdempiereUOM> getSavedIdempiereUOMList(){
    List<dynamic> res = GetStorage().read(Memory.KEY_IDEMPIERE_UOM_LIST) ?? [];
    if(res is List<IdempiereUOM>){
      return res ;
    }
    List<IdempiereUOM> list = IdempiereUOM.fromJsonList(res);
    return list;
  }
  void removeSavedIdempiereUOMList(){
    GetStorage().remove(Memory.KEY_IDEMPIERE_UOM_LIST) ;
  }

  String getFileNameFromUrl(String url) {
    Uri? uri = Uri.tryParse(url);

    if(uri==null){
      return '';
    }
    String fileName = uri.path.split("/").last;
    print('Filename : $fileName');
    // Handle potential query parameters or hash in the filename
    if (fileName.contains('?')) {
      fileName = fileName.split('?')[0];
    }
    if (fileName.contains('#')) {
      fileName = fileName.split('#')[0];
    }
    return fileName;
  }
  Future<String> downloadVideo(String videoUrl) async {
    late http.Response response;
    try {
      response = await http.head(Uri.parse(videoUrl));
      // A status code of 200 (OK) indicates the resource exists.
      // Other success codes (e.g., 204 No Content) might also indicate existence
      // depending on the server's behavior for HEAD requests.
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error checking URL: $e');
      return '';
    }
    if(response.statusCode != 200){
      print('Error checking URL: $videoUrl');
      return '';
    }
    String fileName = getFileNameFromUrl(videoUrl);
    print('----------------------------File: $fileName');
    if(fileName.isEmpty){
      return '';
    }

    try {
      final File?  file = await FileDownloader.downloadFile(

        url: videoUrl,
        name: fileName, // Optional: Name of the downloaded file
        subPath: MemoryPanelSc.FILE_SUB_PATH,
        onProgress: (String? fileName, double progress) {
          // Handle progress updates (e.g., show a progress indicator)
          downloadingFile.value = true;
          downloadUrl.value = videoUrl;
          // You can update a progress variable here to show in the UI
          // For example, if you have a RxDouble progressValue = 0.0.obs;
          // progressValue.value = progress;
          print('Downloading $fileName: $progress%');
        },
        onDownloadCompleted: (String path) {
          // Handle successful download (e.g., play the video)
          print('Download completed at: $path');
          // Initialize and play the video using video_player
        },
        onDownloadError: (String error) {
          // Handle download errors
          print('Download error: $error');
          downloadingFile.value = false;
        },
      );
      print('File downloaded to: ${file?.path ?? '---'}');
      //return fileName;
      return file?.path ?? '';
    } catch (e) {
      print('Error: $e');
      return '';
    } finally {
      downloadingFile.value = false;
      downloadUrl.value = '';
    }
  }
  Future<String> downloadField(String subPath,String fileUrl) async {
    late http.Response response;
    try {
      response = await http.head(Uri.parse(fileUrl));
      // A status code of 200 (OK) indicates the resource exists.
      // Other success codes (e.g., 204 No Content) might also indicate existence
      // depending on the server's behavior for HEAD requests.
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error checking URL: $e');
      return '';
    }
    if(response.statusCode != 200){
      print('Error checking URL: $fileUrl');
      return '';
    }
    String fileName = getFileNameFromUrl(fileUrl);
    print('----------------------------File: $fileName');
    if(fileName.isEmpty){
      return '';
    }

    try {
      final File?  file = await FileDownloader.downloadFile(

        url: fileUrl,
        name: fileName, // Optional: Name of the downloaded file
        subPath: subPath,
        onProgress: (String? fileName, double progress) {
          // Handle progress updates (e.g., show a progress indicator)
          downloadingFile.value = true;
          downloadUrl.value = fileUrl;
          // You can update a progress variable here to show in the UI
          // For example, if you have a RxDouble progressValue = 0.0.obs;
          // progressValue.value = progress;
          print('Downloading $fileName: $progress%');
        },
        onDownloadCompleted: (String path) {
          // Handle successful download (e.g., play the video)
          print('Download completed at: $path');
          // Initialize and play the video using video_player
        },
        onDownloadError: (String error) {
          // Handle download errors
          print('Download error: $error');
          downloadingFile.value = false;
        },
      );
      print('File downloaded to: ${file?.path ?? '---'}');
      //return fileName;
      downloadingFile.value = false;
      return file?.path ?? '';
    } catch (e) {
      print('Error: $e');
      downloadingFile.value = false;
      return '';
    }
  }
  Future<void> deleteSavedFile(String path, String fileName) async {
    try {
      final file = File('$path/$fileName');

      if (await file.exists()) {
        await file.delete();
        print('File "$fileName" deleted successfully!');
      } else {
        print('File "$fileName" does not exist.');
      }
    } catch (e) {
      print('Error deleting file "$fileName": $e');
    }
  }

  Future<File> getLocalFileWithPath(String path, String fileName) async {
    return File('$path/$fileName');
  }
  Future<bool> checkHttpSiteExists(String url) async {
    try {
      final response = await http.head(Uri.parse(url)); // Using http.head for efficiency
      return response.statusCode == 200; // Check for a successful status code
    } catch (e) {
      // Handle network errors or invalid URLs
      print('Error checking URL: $e');
      return false;
    }
  }
  Future<String?> showInputDialog(BuildContext context,String title, String hint,String value) async {
    TextEditingController textController = TextEditingController();
    textController.text = value;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            keyboardType: TextInputType.text,
            controller: textController,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Messages.CANCEL),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog without returning a value
              },
            ),
            TextButton(
              child: Text(Messages.OK),
              onPressed: () {
                Navigator.of(context).pop(textController.text); // Dismiss and return the entered text
              },
            ),
          ],
        );
      },
    );
  }
  Future<String?> showInputNumericDialog(BuildContext context,String title, String hint,String value) async {
    TextEditingController textController = TextEditingController();
    textController.text = value;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            keyboardType: TextInputType.number,
            controller: textController,
            decoration: InputDecoration(hintText: hint),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Messages.CANCEL),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog without returning a value
              },
            ),
            TextButton(
              child: Text(Messages.OK),
              onPressed: () {
                Navigator.of(context).pop(textController.text); // Dismiss and return the entered text
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> getPanelScConfiguration()async{
    // String fileName = getFileNameFromUrl(MemoryPanelSc.configurationFileUrl) ?? '';
    // String localFileName = '${MemoryPanelSc.FILE_DOWNLOAD_PATH}/$fileName';
    // File file = File(localFileName);
    // if(!await file.exists()){
    //   fileName  = await downloadField(MemoryPanelSc.FILE_SUB_PATH, fileName);
    //
    // }
    // if(fileName.isEmpty){
    //   fileName = MemoryPanelSc.configurationFileUrl;
    // }


    late List<String> lines;
    lines = await readNetworkFileLines(MemoryPanelSc.configurationFileUrl);
    if(lines.isNotEmpty){
      String line = lines[0];

      if(line.isNotEmpty){
        try{
          PanelScConfig panelScConfig = panelScConfigFromJson(line);
          MemoryPanelSc.panelScConfig = panelScConfig;
          print('------------------read config---MemoryPanelSc.panelScConfig---------------${MemoryPanelSc.panelScConfig.toJson()}');
        } catch(e) {
          print(e.toString());
        }
      } else {
        /*List<String> lines = await readLocalFileLines(localFileName);
        if(lines.isNotEmpty){
          return;
        }*/

        print('------------------read config---------------------no lines');
      }


    }


  }
  Future<List<String>> readNetworkFileLines(String url) async {
    List<String> lines = [];
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // File content received successfully
        final String fileContent = response.body;
        // Split the content into results
        final Iterable<String> results = LineSplitter.split(fileContent);
        for (final String line in results) {
          if(line.isNotEmpty) lines.add(line);
        }
        return lines;
      } else {
        // Handle HTTP errors (e.g., 404 Not Found)
        //throw Exception('Failed to load file from network: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle network or other errors
      //throw Exception('Error reading network file: $e');
      return [];
    }
  }

  void buttonMorePressed() {

  }

}
