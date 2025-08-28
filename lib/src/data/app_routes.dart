import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart'; // Keep necessary imports
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/pages/excel/excel_page.dart';
import 'package:solexpress_panel_sc/src/pages/panel_sc_home/panel_sc_home_page.dart';
import 'package:solexpress_panel_sc/src/pages/warehouse/home/warehouse_home_orders_list_page.dart';

import '../pages/accounting/home/accounting_home_page.dart';
import '../pages/accounting/orders/list/accounting_list_delivered_page.dart';
import '../pages/accounting/orders/list/accounting_list_uncompleted_page.dart';
import '../pages/admin/database/categories/create/categories_create_page.dart';
import '../pages/admin/database/categories/handling/categories_handling_page.dart';
import '../pages/admin/database/database_handling_page.dart';
import '../pages/admin/database/groups/products/price/create/product_price_by_group_create_page.dart';
import '../pages/admin/database/groups/products/price/handling/product_price_by_group_handling_page.dart';
import '../pages/admin/database/products/create/products_create_page.dart';
import '../pages/admin/database/products/handling/products_handling_page.dart';
import '../pages/admin/home/admin_home_page.dart';
import '../pages/client/address/create/client_address_create_page.dart';
import '../pages/client/address/list/client_address_list_page.dart';
import '../pages/client/home/client_home_orders_list_all_uncompleted_page.dart';
import '../pages/client/orders/create/client_orders_create_page.dart';
import '../pages/client/orders/detail/client_orders_detail_page.dart';
import '../pages/client/orders/list/client_orders_list_canceled_page.dart';
import '../pages/client/orders/list/client_orders_list_delivered_page.dart';
import '../pages/client/orders/list/client_orders_list_returned_page.dart';
import '../pages/client/orders/list/client_orders_list_shipped_page.dart';
import '../pages/client/orders/map/client_orders_map_page.dart';
import '../pages/client/payments/create/client_pyments_create_page.dart';
import '../pages/client/products/detail/client_products_detail_page.dart';
import '../pages/client/products/list/client_products_list_page.dart';
import '../pages/client/profile/info/client_profile_info_page.dart';
import '../pages/client/profile/update/client_profile_update_page.dart';
import '../pages/client/profile/update/client_profile_update_password_page.dart';
import '../pages/delivery/home/delivery_home_orders_list_page.dart';
import '../pages/delivery/invoice/invoice_number_page.dart';
import '../pages/delivery/orders/detail/delivery_orders_detail_page.dart';
import '../pages/delivery/orders/list/delivery_orders_list_canceled_page.dart';
import '../pages/delivery/orders/list/delivery_orders_list_delivered_page.dart';
import '../pages/delivery/orders/list/delivery_orders_list_returned_page.dart';
import '../pages/delivery/orders/list/delivery_orders_list_shipped_page.dart';
import '../pages/delivery/orders/map/delivery_orders_map_page.dart';
import '../pages/delivery/orders/return/delivery_orders_return_page.dart';
import '../pages/login/login_page.dart';
import '../pages/maps/orders_map_page.dart';
import '../pages/orderspicker/home/orders_picker_home_orders_list_page.dart';
import '../pages/register/register_page.dart';
import '../pages/roles/roles_page.dart';
import '../pages/seller/home/seller_home_orders_list_all_uncompleted_page2.dart';
import '../pages/seller/orders/detail/seller_orders_detail_page.dart';
import '../pages/seller/orders/list/seller_orders_list_canceled_page.dart';
import '../pages/seller/orders/list/seller_orders_list_delivered_page.dart';
import '../pages/seller/orders/list/seller_orders_list_returned_page.dart';
import '../pages/seller/orders/list/seller_orders_list_shipped_page.dart';
import '../pages/seller/orders/map/seller_orders_map_page2.dart';
import '../pages/seller/orders/return/seller_orders_return_page.dart';
import '../pages/seller/societies/societies_list_page.dart';
import '../pages/web/web_page.dart';
import '../utils/image/tool/image_tool_page.dart';
// ... import all your page files

class AppRoutes {
  static final int seconds = Memory.DURATION_TRANSITION_SECUNDS ;
  static final int milliSeconds = Memory.DURATION_TRANSITION_MILLI_SECUNDS ;
  static final int shortSeconds = Memory.DURATION_TRANSITION_SHORT_SECUNDS ;
  static final List<GetPage> pages = [
    GetPage(name: Memory.ROUTE_LOGIN_PAGE, page: ()=>LoginPage(),
    transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_REGISTER_PAGE, page: ()=>RegisterPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_HOME_PAGE, page: ()=>PanelScHomePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_ROLES_PAGE, page: () => RolesPage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_HOME_PAGE, page: () => SellerHomeOrdersListAllUncompletedPage2()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_LIST_DELIVERED_PAGE, page: () => SellerOrdersListDeliveredPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_LIST_SHIPPED_PAGE, page: () => SellerOrdersListShippedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_LIST_RETURNED_PAGE, page: () => SellerOrdersListReturnedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_LIST_CANCELED_PAGE, page: () => SellerOrdersListCanceledPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_SELLER_ORDER_DETAIL_PAGE, page: () => SellerOrdersDetailPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_MAP_PAGE, page: () => SellerOrdersMapPage2()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_RETURN_PAGE, page: () => SellerOrdersReturnPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_SELLER_ORDER_LISTMAP_PAGE, page: () => OrdersMapPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_SOCIETY_LIST_PAGE, page: () => SocietiesListPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_DELIVERY_MAN_HOME_PAGE,
    page: () => DeliveryHomeOrdersListPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_SHIPPED_PAGE, page: () => DeliveryOrdersListShippedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_CANCELED_PAGE, page: () => DeliveryOrdersListCanceledPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_DELIVERED_PAGE, page: () => DeliveryOrdersListDeliveredPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_LIST_RETURNED_PAGE, page: () => DeliveryOrdersListReturnedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_MAP_PAGE, page: () => DeliveryOrdersMapPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_DETAIL_PAGE, page: () => DeliveryOrdersDetailPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_ORDER_RETURN_PAGE, page: () => DeliveryOrdersReturnPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_DELIVERY_MAN_INVOICE_NUMBER_PAGE, page: () => InvoiceNumberPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),


    GetPage(name: Memory.ROUTE_ORDERSPICKER_HOME_PAGE, page: () => OrdersPickerHomeOrdersListPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_USER_PROFILE_INFO_PAGE, page: () => ClientProfileInfoPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_USER_PROFILE_UPDATE_PAGE, page: () => ClientProfileUpdatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_USER_PROFILE_UPDATE_PASSWORD_PAGE, page: () => ClientProfileUpdatePasswordPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_IMAGE_TOOL_PAGE, page: () => ImageToolPage(title: Messages.IMAGE_TOOL,)),
    GetPage(name: Memory.ROUTE_CLIENT_HOME_PAGE, page: () => ClientHomeOrdersListAllUncompletedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_PRODUCTS_LIST_PAGE, page: () => ClientProductsListPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_CLIENT_PRODUCTS_DETAIL_PAGE, page: () => ClientProductsDetailPage(product: GetStorage().read(Memory.KEY_CURRENT_PROCUCT))
    ,transition: Transition.zoom ,
    transitionDuration: Duration(seconds: shortSeconds),),

    GetPage(name: Memory.ROUTE_CLIENT_ORDER_CREATE_PAGE, page: () => ClientOrdersCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ADDRESS_CREATE_PAGE, page: () => ClientAddressCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ADDRESS_LIST_PAGE, page: () => ClientAddressListPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_PAYMENTS_CREATE_PAGE, page: () => ClientPaymentsCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_LIST_DELIVERED_PAGE, page: () => ClientOrdersListDeliveredPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_LIST_CANCELED_PAGE, page: () => ClientOrdersListCanceledPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_LIST_RETURNED_PAGE, page: () => ClientOrdersListReturnedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_LIST_SHIPPED_PAGE, page: () => ClientOrdersListShippedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_DETAIL_PAGE, page: () => ClientOrdersDetailPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_CLIENT_ORDER_MAP_PAGE, page: () => ClientOrdersMapPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_ADMIN_CATEGORIES_CREATE_PAGE, page: () => CategoriesCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_CATEGORIES_HANDLING_PAGE, page: () => CategoriesHandlingPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_PRODUCTS_CREATE_PAGE, page: () => ProductsCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_PRODUCTS_HANDLING_PAGE, page: () => ProductsHandlingPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_DATABASE_HANDLING_PAGE, page: () => DatabaseHandlingPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_CREATE_PAGE, page: () => ProductPriceByGroupCreatePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_HANDLING_PAGE, page: () => ProductPriceByGroupHandlingPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ADMIN_HOME_PAGE, page: () => AdminHomePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ACCOUNTING_HOME_PAGE, page: () => AccountingHomePage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_DELIVERED_PAGE,
    page: () => AccountingListDeliveredPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_UNCOMPLETED_PAGE,
    page: () => AccountingListUncompletedPage()
    ,transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds)),
    GetPage(
      name: Memory.ROUTE_WEB_VIEW_PAGE, // Or AppRoutes.webViewPage
      page: () {
        // 1. Retrieve the URL from arguments
        final dynamic arguments = Get.arguments;
        String urlToLoad = Memory.WEB_URL; // Default or error URL

        if (arguments is String) {
          urlToLoad = arguments;
        } else if (arguments is Map<String, dynamic> && arguments.containsKey('url')) {
          // If you prefer passing arguments as a map: Get.toNamed(..., arguments: {'url': 'your_url'})
          urlToLoad = arguments['url'] as String;
        } else {
          // Handle the case where the URL is not provided or in an unexpected format
          // You could navigate to an error page, show a default page, or throw an error.
          print("Error: URL not provided or in incorrect format for web view page.");
          // For simplicity, returning a GetWebPage with a default/error URL.
          // In a real app, you might want to return a dedicated error widget/page.
          return WebPage(url: 'about:blank'); // Or some error indication page
        }

        if (urlToLoad.isEmpty || !Uri.tryParse(urlToLoad)!.isAbsolute) {
          print("Error: Invalid URL provided: $urlToLoad");
          return Scaffold(
            appBar: AppBar(title: Text("Invalid URL")),
            body: Center(child: Text("The URL '$urlToLoad' is not valid.")),
          );
        }

        // 2. Return your GetWebPage widget, passing the URL
        return WebPage(url: urlToLoad);
      },
      transition: Transition.cupertino, // Or your preferred transition
      transitionDuration: Duration(milliseconds: seconds),
      // Optional: Define bindings if your WebPageController needs specific setup
      // that isn't handled by Get.put within GetWebPage itself.
      // binding: BindingsBuilder(() {
      //   // Get.lazyPut<WebPageController>(() => WebPageController(initialUrl: Get.arguments as String? ?? 'about:blank'), tag: Get.arguments as String?);
      // })
    ),
    GetPage(name: Memory.ROUTE_EXCEL_PAGE,
        page: () => ExcelPage()
        ,transition: Transition.circularReveal ,
        transitionDuration: Duration(seconds: seconds)),
    GetPage(name: Memory.ROUTE_WAREHOUSE_HOME_PAGE, page: () => WarehouseHomeOrdersListPage()
      ,transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),
  ];
}