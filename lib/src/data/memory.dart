
import 'package:amount_input_formatter/amount_input_formatter.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';
import 'package:solexpress_panel_sc/src/models/order_status.dart';
import 'package:solexpress_panel_sc/src/models/payment_type.dart';
import 'package:solexpress_panel_sc/src/models/seles_type.dart';
import 'package:solexpress_panel_sc/src/models/status.dart';
import 'package:solexpress_panel_sc/src/models/vat.dart';

import '../models/credit.dart';
import '../models/currency.dart';
import '../models/host.dart';
import '../models/idempiere/idempiere_user.dart';
import '../models/product.dart';
import '../models/rol.dart';
import '../models/society.dart';
import '../models/user.dart';
import '../models/category.dart';

class Memory {
    static const int EVENT_PANEL =2;
    static const int SC_PANEL =1;
    static const int ALL_PANEL =3;
    static int TYPE_OF_PANEL = EVENT_PANEL;

    // sin http://
    static final bool isIdempiereApp = true;
    static const String APP_HOST_NAME_WITHOUT_HTTP_TEST ='192.168.188.101';
    static const String APP_HOST_NAME_WITHOUT_HTTP_PRODUCTION ='erp-sc.plantelmedico.com';
    static String APP_HOST_NAME_WITHOUT_HTTP ='erp-sc.plantelmedico.com';
    //static const String APP_POSTGRESQL_HOST_NAME ='erp-sc.plantelmedico.com';
    //con http://
    static const String APP_HOST_WITH_HTTP_TEST ='http://192.168.188.101';
    static const String APP_HOST_WITH_HTTP_PRODUCTION ='http://erp-sc.plantelmedico.com';
    static String APP_HOST_WITH_HTTP ='http://erp-sc.plantelmedico.com';
    static bool isDeliveredOrder = false;
    static DateTime deliveryDateLocal = Memory.getDateTimeNowLocal();
    static DateTime orderCreatePageOpenedAtDateTimeLocal = Memory.getDateTimeNowLocal();
    static String WEB_URL='https://app.solexpresspy.com/';
    static final int SESSION_TOKEN_EXPIRE_IN_DAYS = 7;
    static final int TOKEN_EXPIRE_MINUTES = 60;
    static final int REFRESH_TOKEN_EXPIRE_MINUTES = 1440;
    static const int ALL_CATEGORIES_ID = 0;

    static int PAGE_REFRESH_TIME_IN_MINUTES = 5;
    //static Map<String,String>  headers  ={};
    static bool TESTING_MODE = true;
    static bool widescreen = false;
    static int SAVED_CLIENT_LIST_EXPIRE_TIME_IN_HOURS =2 ;
    static List<Color> colorsAppBarOdd =[Colors.cyan.shade300,Colors.purple.shade300];
    static List<Color> colorsAppBarEven =[Colors.purple.shade300,Colors.cyan.shade300];
    static double minimumWideScreenWidth = 700;
    static double minimumWideScreenColumWidth = 380;
    static int TIMEZONE_OFFSET = -3;
    static int DURATION_TRANSITION_SECUNDS = 2;
    static int DURATION_TRANSITION_MILLI_SECUNDS = 500;
    static int DURATION_TRANSITION_SHORT_SECUNDS = 1;
    static bool SAVE_USER_SESSION = true;
    static int FIREBASE_NOTIFICATION_TOKEN_EXPIRES_DAYS = 29;
    static double VALUE_OF_METER_DELIVERY_BOY_IS_CLOSED_TO_CLIENT = 200.0;
    static bool CHECK__DELIVERY_BOY_IS_CLOSED_TO_CLIENT = true;
    static bool VAT_INCLUDED_MODE = true;
    static String COMPANY_NAME ='SOL EXPRESS S.A.';
    static final String GOOGLE_MAP_API_KEY='';
    static final String GOOGLE_MAP_ID='4bccfd143ec9333b';
    static final String GOOGLE_MAP_DARK_ID='6ff125cdca88de663790d815';
    static final int ID_ISSUER=1;
    static const Color COLOR_IS_DEBIT_TRANSACTION = Color(0xFF6FD0B9);
    static Color COLOR_IS_CREDIT_TRANSACTION = Colors.purple[200]!;
    static Host productionHost =Host(id:1,name: APP_HOST_WITH_HTTP_PRODUCTION,url: APP_HOST_WITH_HTTP_PRODUCTION,active:1);
    static Host testHost =Host(id:2,name: APP_HOST_WITH_HTTP_TEST,url: APP_HOST_WITH_HTTP_TEST,active:1);
    static Host? customHost =Host(id:3,name: 'CUSTOM SERVER',url: 'http://192.168.188.101:8090',active:1);

    static List<Host> listHost =<Host>[productionHost,testHost];

    static List<Product>? clientProductsList =<Product>[];
    static List<Category>? clientCategoriesList =<Category>[];
    static Society? clientSociety = Society();

    static final amountFormatter = AmountInputFormatter(
        integralLength: 13,
        groupSeparator: ',',
        fractionalDigits: 0,
        decimalSeparator: '.',
    );
    static final currencyFormatter = NumberFormat.currency(
        locale: 'es_PY',symbol: 'Gs',decimalDigits: 0);

    static final numberFormatter = NumberFormat.decimalPatternDigits
        (locale: 'es_PY',decimalDigits: 0);

    static final numberFormatter2Digit = NumberFormat.decimalPatternDigits
        (locale: 'es_PY',decimalDigits: 2);


    static final List<String> keysToRemoveAfterOrderCreate =[Memory.KEY_SHOPPING_BAG,
        Memory.KEY_ADDRESS,Memory.KEY_CURRENT_PROCUCT,Memory.KEY_DELIVERY_DATE
        ,Memory.KEY_CLIENT_CATEGORIES_LIST,Memory.KEY_CLIENT_PRODUCTS_LIST,
        Memory.KEY_CLIENT_CATEGORIES_LIST_CREATED_AT,Memory.KEY_CLIENT_PRODUCTS_LIST_CREATED_AT];
    static final List<String> keyToRemoveAtSignOut =[];
    static const int DEFAULT_DELIVERY_MAN_ID =2;
    static const int DEFAULT_WAREHOUSE_ID =1;
    static const int CREDIT_WITH_INVOICE_AT_DELIVERY_ID=2;
    static final String CREDIT_WITH_INVOICE_AT_DELIVERY_NAME='CREDITO CON FACTURA';
    static final Credit creditWithInvoice =Credit(id:CREDIT_WITH_INVOICE_AT_DELIVERY_ID,name: CREDIT_WITH_INVOICE_AT_DELIVERY_NAME);

    static const int ORDER_STATUS_UNCOMPLETED_ID=-1;
    static const int ORDER_STATUS_CANCELED_ID=0;
    static const int ORDER_STATUS_CREATE_ID=1;
    static const int ORDER_STATUS_MODIFIED_ID=3;
    static const int ORDER_STATUS_PAID_APPROVED_ID=5;
    static const int ORDER_STATUS_PREPARED_ID=9;
    static const int ORDER_STATUS_SHIPPED_ID=29;
    static const int ORDER_STATUS_RETURNED_ID=39;
    static const int ORDER_STATUS_DELIVERED_ID=49;
    static const int ORDER_STATUS_SETTLEMENT_ID=91;
    static final String ORDER_STATUS_CANCELED_NAME='CANCELADO ';
    static final String ORDER_STATUS_CREATE_NAME='CREADO';
    static final String ORDER_STATUS_MODIFIED_NAME='MODIFICADO';
    static final String ORDER_STATUS_PAID_APPROVED_NAME='PAGADO';
    static final String ORDER_STATUS_PREPARED_NAME='PREPARADO';
    static final String ORDER_STATUS_SHIPPED_NAME='ENVIADO';
    static final String ORDER_STATUS_RETURNED_NAME='RETORNADO';
    static final String ORDER_STATUS_DELIVERED_NAME='ENTREGADO';
    static final String ORDER_STATUS_UNCOMPLETED_NAME='NO COMPLETADO';
    static final String ORDER_STATUS_SETTLEMENT_NAME='FINIQUITO';

    /*
    static final String ORDER_STATUS_TOTAL_SHIPPING_STARTED_NAME='ENVIO TOTAL INICIADO';
    static final String ORDER_STATUS_TOTAL_RECEPTION_CONFIRMED_NAME='RECEPCION TOTAL CONFIRMADA';
    static final String ORDER_STATUS_TOTAL_RETURN_INITIATED_NAME='RETORNO TOTAL INICIADO';


     */



    static final OrderStatus canceledOrderStatus =OrderStatus(id:ORDER_STATUS_CANCELED_ID,name: ORDER_STATUS_CANCELED_NAME);
    static final OrderStatus createOrderStatus =OrderStatus(id:ORDER_STATUS_CREATE_ID,name: ORDER_STATUS_CREATE_NAME);
    static final OrderStatus modifiedOrderStatus =OrderStatus(id:ORDER_STATUS_MODIFIED_ID,name: ORDER_STATUS_MODIFIED_NAME);
    static final OrderStatus paidApprovedOrderStatus =OrderStatus(id:ORDER_STATUS_PAID_APPROVED_ID,name: ORDER_STATUS_PAID_APPROVED_NAME);
    static final OrderStatus preparedOrderStatus =OrderStatus(id:ORDER_STATUS_PREPARED_ID,name: ORDER_STATUS_PREPARED_NAME);
    static final OrderStatus shippedOrderStatus =OrderStatus(id:ORDER_STATUS_SHIPPED_ID,name: ORDER_STATUS_SHIPPED_NAME);
    static final OrderStatus returnedOrderStatus =OrderStatus(id:ORDER_STATUS_RETURNED_ID,name: ORDER_STATUS_RETURNED_NAME);
    static final OrderStatus deliveredOrderStatus =  OrderStatus(id:ORDER_STATUS_DELIVERED_ID,name: ORDER_STATUS_DELIVERED_NAME);
    static final OrderStatus allUncompletedOrderStatus =OrderStatus(id:ORDER_STATUS_UNCOMPLETED_ID,name: ORDER_STATUS_UNCOMPLETED_NAME);
    static final OrderStatus settlementOrderStatus =OrderStatus(id:ORDER_STATUS_SETTLEMENT_ID,name: ORDER_STATUS_SETTLEMENT_NAME);
    /*
    static final OrderStatus totalShippingStartedOrderStatus =OrderStatus(id:ORDER_STATUS_TOTAL_SHIPPING_STARTED_ID,name: ORDER_STATUS_TOTAL_SHIPPING_STARTED_NAME);
    static final OrderStatus totalReceptionConfirmedOrderStatus =OrderStatus(id:ORDER_STATUS_TOTAL_RECEPTION_CONFIRMED_ID,name: ORDER_STATUS_TOTAL_RECEPTION_CONFIRMED_NAME);
    static final OrderStatus totalReturnStartedOrderStatus =OrderStatus(id:ORDER_STATUS_TOTAL_RETURN_INITIATED_ID,name: ORDER_STATUS_TOTAL_SHIPPING_STARTED_NAME);



     */


    static final Currency defaultCurrency =Currency(id:1,name: 'GUARANI', idCurrencyRate: 1,
        currencyRate:1, shortName: 'PYG', countryCode: 'PRY',countryName: 'PARAGUAY',defaultSelection: 1
            ,active: 1);

    static final Currency pryCurrency =Currency(id:1,name: 'GUARANI', idCurrencyRate: 1,
        currencyRate:1, shortName: 'PYG', countryCode: 'PRY',countryName: 'PARAGUAY',defaultSelection: 1,active: 1);

    static final int PAYMENT_UNDEFINED_ID=0;
    static final int PAYMENT_CASH_ID=1;
    static final int PAYMENT_CASH_ON_DELIVERY_ID=20;
    static final int PAYMENT_PRE_APPROVED_CREDIT_ID=30;

    static final int PAYMENT_CREDIT_CARD_ID=40;
    static final int PAYMENT_DEBIT_CARD_ID=50;
    static final int PAYMENT_BANK_TRANSFER_ID=60;

    static final String PAYMENT_UNDEFINED='NO DEFINIDO';
    static final String PAYMENT_CASH_NAME='EFECTIVO';
    static final String PAYMENT_CASH_ON_DELIVERY_NAME='EFECTIVO CONTRA ENTREGA';
    static final String PAYMENT_PRE_APPROVED_CREDIT_NAME='CREDITO PREAPROBADO';

    static final String PAYMENT_CREDIT_CARD_NAME='TARJETA DE CREDITO';
    static final String PAYMENT_DEBIT_CARD_NAME='TARJETA DE DEBITO';
    static final String PAYMENT_BANK_TRANSFER_NAME='TRANSFERENCIA BANCARIA';

    static final PaymentType defaultPayment =PaymentType(id:PAYMENT_CASH_ID,name: PAYMENT_CASH_NAME);
    static final PaymentType undefinedPayment =PaymentType(id:PAYMENT_UNDEFINED_ID,name: PAYMENT_UNDEFINED);
    static final PaymentType cashPayment =PaymentType(id:PAYMENT_CASH_ID,name: PAYMENT_CASH_NAME);
    static final PaymentType cashOnDeliveryPayment =PaymentType(id:PAYMENT_CASH_ON_DELIVERY_ID,name: PAYMENT_CASH_ON_DELIVERY_NAME);
    static final PaymentType preApprovedCreditPayment =PaymentType(id:PAYMENT_PRE_APPROVED_CREDIT_ID,name: PAYMENT_PRE_APPROVED_CREDIT_NAME);

    static final PaymentType creditCardPayment =PaymentType(id:PAYMENT_CREDIT_CARD_ID,name: PAYMENT_CREDIT_CARD_NAME);
    static final PaymentType debitCardPayment =PaymentType(id:PAYMENT_DEBIT_CARD_ID,name: PAYMENT_DEBIT_CARD_NAME);
    static final PaymentType bankTransferPayment =PaymentType(id:PAYMENT_BANK_TRANSFER_ID,name: PAYMENT_BANK_TRANSFER_NAME);
    static List<PaymentType> paymentsAvailable =[cashPayment,cashOnDeliveryPayment, preApprovedCreditPayment];

    static int DEFAULT_IDEMPIERE_PRODUCT_CATEGORY_ID =-1;


    static int DEFAULT_CATEGORY_ID =1;
    static int DEFAULT_GROUP_ID = 1;
    static int DEFAULT_SOCIETY_NO_NAME_ID = 0;
    static int DEFAULT_SALES_TYPE_CASH= 1;

    static const int TIME_OUT_SECOND = 10;
    static Color PRIMARY_COLOR = Colors.green;
    static Color SCAFFOLD_BACKGROUND_COLOR = Colors.lightGreen.shade300;
    static const BAR_BACKGROUND_COLOR = Colors.amber;
    static const BAR_ACTIVE_COLOR = Colors.white;
    static const BAR_INACTIVE_COLOR = Colors.grey;
    static int CROPPED_IMAGE_WINDOWS_WIDTH = 512;
    static int CROPPED_IMAGE_WINDOWS_HEIGT = 512;
    static int COMPRESSED_ICON_IMAGE_HEIGT = 128;
    static int COMPRESSED_ICON_IMAGE_WIDTH = 128;
    static Color COLOR_BUTTOM_BAR = Colors.amber;
    static List<int> active =[1,0];
    static List<Category> categoriesList =<Category>[];
    static List<Product> productsList =<Product>[];
    static List<Society> societiesList =<Society>[];
    static List<User> usersList =<User>[];
    static List<Status> statusList=<Status>[];
    static List<Vat> vatsList =<Vat>[];
    static double RADIO_IMAGE_USER = 80;

    //-25.513013283996237, -54.60993905659135
    static const double INITIAL_LATITUDE = -25.513013283996237;
    static const double INITIAL_LONGITUDE = -54.60993905659135;
    //static LIST<> =<>[];
    static final String CASH_SELL ='VENTA AL CONTADO';
    static final String CREDIT_SELL ='VENTA POR CREDITO';




    static final SalesType cashSalesType = SalesType(id: 1, name: CASH_SELL,active: 1);
    static final SalesType creditSalesType = SalesType(id: 0, name: CREDIT_SELL,active: 1);
    static final SalesType defaultSalesType = cashSalesType;

    static double getGoogleMapZoomValue(double distanceBetween){
        double zoomValue = 9;
        if(distanceBetween<200){
            zoomValue = 16.5;
        } else if(distanceBetween<500){
            zoomValue = 16;
        } else if(distanceBetween<1500){
            zoomValue = 14.2;
        } else if(distanceBetween<2500){
            zoomValue = 13.4;
        } else if(distanceBetween<5000){
            zoomValue = 12.7;
        } else if(distanceBetween<7500) {
            zoomValue = 11.9;
        } else if(distanceBetween<10000){
            zoomValue = 11.4;
        } else if(distanceBetween<15000){
            zoomValue = 10.7;
        }  else {
            zoomValue = 10;
        }
        print('distance between $distanceBetween , zoom value $zoomValue');
        return zoomValue;
    }
    static ThemeData THEME_WAREHOUSE = ThemeData(
        scaffoldBackgroundColor: Colors.grey[500],
        primaryColor: PRIMARY_COLOR,
        colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: PRIMARY_COLOR,
            onPrimary: Colors.grey.shade800,
            secondary: Colors.blue,
            onSecondary: Colors.grey.shade800,
            error: Colors.grey.shade800,
            onError: Colors.grey.shade800,
            surface: Colors.grey.shade500, //backgroud
            onSurface: Colors.black)
    );
    static ThemeData THEME_2 = ThemeData(
        scaffoldBackgroundColor: Colors.lightGreen.shade300,
        primaryColor: PRIMARY_COLOR,
        colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: PRIMARY_COLOR,
        onPrimary: Colors.grey,
        secondary: Colors.blue,
        onSecondary: Colors.grey,
        error: Colors.grey,
        onError: Colors.grey,
        surface: Colors.lightGreen.shade300, //backgroud
        onSurface: Colors.black)
    );
    static ThemeData THEME = ThemeData(
        //scaffoldBackgroundColor: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
        highlightColor: const Color(0xFF6FD0B9),
        canvasColor: const Color(0xFFFDF5EC),
        bottomSheetTheme:BottomSheetThemeData(backgroundColor: Colors.amber[200]),
        textTheme: TextTheme(
        headlineSmall: ThemeData.light()
            .textTheme
            .headlineSmall!
            .copyWith(color: const Color(0xFF6FD0B9)),
        ),
        iconTheme: IconThemeData(
            color: Colors.grey[600],
        ),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6FD0B9),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFE8C855)),
                foregroundColor: WidgetStateColor.resolveWith(
                    (states) => Colors.white,
                ),
            ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
                ),
                side: WidgetStateBorderSide.resolveWith(
                (states) => const BorderSide(color: Color(0xFFBC764A))),
            ),
        ),
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
            ),
            ),
        ),
        iconButtonTheme: IconButtonThemeData(
            style: ButtonStyle(
                foregroundColor: WidgetStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
                ),
            ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
            surface: const Color(0xFFFDF5EC), //backgroud color
            primary: const Color(0xFFD0996F),
        ),
    );
    static void functionNotEnabledYet(){
        Get.snackbar(Messages.ERROR, Messages.FUNTION_NOT_ENABLED_YED);
    }
    //static Product currentProduct = Product();
    static final String KEY_APP_HOST_WITH_HTTP ='app_host_with_http';
    static final String KEY_HOST ='host';
    static final String KEY_USER_HOST ='user_host';
    static final String KEY_IS_USING_LOCAL_HOST ='is_using_local_host';
    static final String KEY_APP_HOST_NAME_WITHOUT_HTTP ='app_host_name_without_http';
    static final String KEY_SHOPPING_BAG ='shopping_bag';
    static final String KEY_IS_DEBIT_TRANSACTION ='is_debit_transaction';
    static final String KEY_IS_DELIVERED_ORDER ='is_delivered_order';
    static final String KEY_DELIVERY_DATE ='delivery_date';
    static final String KEY_CURRENT_PROCUCT ='current_product';
    static final String KEY_DO_LOGIN ='do_login';
    static final String KEY_AUTO_LOGIN ='auto_login';
    static final String KEY_REMEMBER_ME ='remember_me';
    static final String KEY_RETURN_ITEM_LIST ='shopping_bag';
    static final String KEY_NEW_ORDER ='new_order';
    static final String KEY_INVOICE_SAVED ='invoice_saved';
    static final String KEY_ORDERS ='orders';
    static final String KEY_ORDER ='order';
    static final String KEY_RETURN_ORDER ='return_order';
    static final String KEY_LAST_ORDER ='last_order';
    static final String KEY_ADDRESS ='address';
    static final String KEY_DELIVERY ='delivery';
    static final String KEY_USER_HOME ='user_home';
    static final String KEY_USER ='user';
    static final String KEY_PAYMENT ='payment';
    static final String KEY_PAYMENT_TYPE ='payment_type';
    static final String KEY_CLIENT_SOCIETY ='client_society';
    static final String KEY_CLIENT_CATEGORIES_LIST ='client_categories';
    static final String KEY_CLIENT_CATEGORIES_LIST_CREATED_AT ='client_categories_created_at';
    static final String KEY_CLIENT_PRODUCTS_LIST ='client_products_list';
    static final String KEY_CLIENT_PRODUCTS_LIST_CREATED_AT ='client_products_list_created_at';
    static final String KEY_SOCIETIES_LIST ='societies_list';
    static final String KEY_NOTIFICATION_TOKEN ='notification_token';
    static final String KEY_PLACE_OF_DELIVERY ='place_of_delivery';

    static final String KEY_IDEMPIERE_FILTERS ='idempiere_filters';
    static final String KEY_IDEMPIERE_USER='idempiere_user';
    static final String KEY_IDEMPIERE_USERS_LIST='idempiere_users_list';
    static final String KEY_IDEMPIERE_OBJECT = 'idempiere_object';
    static final String KEY_IDEMPIERE_OBJECTS_LIST = 'idempiere_objects_list';
    static final String KEY_IDEMPIERE_BUSINESS_PARTNERS_LIST='idempiere_business_partners_list';
    static final String KEY_IDEMPIERE_BUSINESS_PARTNERS_LOCATIONS_LIST='idempiere_business_partners_locations_list';
    static final String KEY_IDEMPIERE_PRODUCT_CATEGORY_LIST ='idempiere_product_category_list';
    static final String KEY_IDEMPIERE_PRODUCT_BRAND_LIST ='idempiere_product_brand_list';
    static final String KEY_IDEMPIERE_PRODUCT_LINE_LIST ='idempiere_product_line_list';
    static final String KEY_IDEMPIERE_PRODUCT_PRICE_LIST ='idempiere_product_price_list';
    static final String KEY_IDEMPIERE_COUNTRY_LIST ='idempiere_country_list';
    static final String KEY_IDEMPIERE_CITY_LIST ='idempiere_city_list';
    static final String KEY_IDEMPIERE_POS_LIST ='idempiere_pos_list';
    static final String KEY_IDEMPIERE_UOM_LIST ='idempiere_uom_list';
    static final String KEY_IDEMPIERE_REGION_LIST ='idempiere_region_list';
    static final String KEY_IDEMPIERE_SALES_REGION_LIST ='idempiere_sales_region_list';
    static final String KEY_IDEMPIERE_CURRENCY_LIST ='idempiere_currency_list';
    static final String KEY_IDEMPIERE_LOCATION_LIST ='idempiere_location_list';
    static final String KEY_IDEMPIERE_LOCATOR_LIST ='idempiere_locator_list';
    static final String KEY_IDEMPIERE_WAREHOUSE_LIST ='idempiere_warehouse_list';
    static final String KEY_IDEMPIERE_ORGANIZATION_LIST ='idempiere_organization_list';
    static final String KEY_IDEMPIERE_USER_WITH_DETAIL_LIST ='idempiere_user_with_details_list';
    static final String KEY_IDEMPIERE_TENANT_WITH_DETAIL_LIST ='idempiere_tenant_with_details_list';
    static final String KEY_IDEMPIERE_TAX_CATEGORY_LIST ='idempiere_tax_category_list';
    static final String KEY_IDEMPIERE_TAX_LIST ='idempiere_tax_list';
    static final String KEY_IDEMPIERE_TRANSACTION_LIST ='idempiere_transaction_list';
    static final String KEY_IDEMPIERE_PRICE_LISTS_LIST ='idempiere_price_lists_list';
    static final String KEY_IDEMPIERE_PRICE_LIST_VERSION_LIST ='idempiere_price_list_versions_list';

    static String ROUTE_IDEMPIERE_WEB_VIEW_PAGE ='/idempiere/web/view';
    static String ROUTE_IDEMPIERE_EXCEL_PAGE ='/idempiere/excel';
    static String ROUTE_IDEMPIERE_LOGIN_PAGE ='/idempiere'; // login_page
    static String ROUTE_IDEMPIERE_REGISTER_PAGE ='/idempiere/register';
    static String ROUTE_IDEMPIERE_HOME_PAGE ='/idempiere/home_old';
    static String ROUTE_IDEMPIERE_HOME_PAGE_1 ='/idempiere/home_old/1';
    static String ROUTE_IDEMPIERE_HOME_PAGE_2 ='/idempiere/home_old/2';
    static String ROUTE_IDEMPIERE_CONFIGURATION_PAGE ='/idempiere/configuration';
    static String ROUTE_IDEMPIERE_ROLES_PAGE = '/idempiere/roles';
    static String ROUTE_IDEMPIERE_IMAGE_TOOL_PAGE = '/utils/image/tool';

    static String ROUTE_IDEMPIERE_OBJECT_DETAIL_PAGE ='/idempiere/object/detail';

    static String ROUTE_IDEMPIERE_PRODUCTS_LIST_PAGE = '/idempiere/products/list';
    static String ROUTE_IDEMPIERE_PRODUCTS_HOME_PAGE = '/idempiere/products/home_old';
    static String ROUTE_IDEMPIERE_PRODUCTS_CATEGORIES_LIST_PAGE= '/idempiere/products/categories/list';
    static String ROUTE_IDEMPIERE_PRODUCTS_CATEGORIES_HOME_PAGE= '/idempiere/products/categories/home_old';
    static String ROUTE_IDEMPIERE_PRODUCTS_BRANDS_LIST_PAGE= '/idempiere/products/brands/list';
    static String ROUTE_IDEMPIERE_PRODUCTS_BRANDS_HOME_PAGE= '/idempiere/products/brands/home_old';
    static String ROUTE_IDEMPIERE_PRODUCTS_LINES_LIST_PAGE= '/idempiere/products/lines/list';
    static String ROUTE_IDEMPIERE_PRODUCTS_LINES_HOME_PAGE= '/idempiere/products/lines/home_old';
    static String ROUTE_IDEMPIERE_PRODUCTS_PRICES_LIST_PAGE= '/idempiere/products/prices/list';
    static String ROUTE_IDEMPIERE_PRODUCTS_PRICES_HOME_PAGE= '/idempiere/products/prices/home_old';

    static String ROUTE_IDEMPIERE_BUSINESS_PARTNERS_LIST_PAGE = '/idempiere/business_partners/list';
    static String ROUTE_IDEMPIERE_BUSINESS_PARTNERS_HOME_PAGE = '/idempiere/business_partners/home_old';
    static String ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_LIST_PAGE = '/idempiere/business_partners_locations/list';
    static String ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_HOME_PAGE = '/idempiere/business_partners_locations/home_old';

    static String ROUTE_IDEMPIERE_COUNTRIES_LIST_PAGE = '/idempiere/countries/list';
    static String ROUTE_IDEMPIERE_COUNTRIES_HOME_PAGE = '/idempiere/countries/home_old';
    static String ROUTE_IDEMPIERE_CITIES_LIST_PAGE = '/idempiere/cities/list';
    static String ROUTE_IDEMPIERE_CITIES_HOME_PAGE = '/idempiere/cities/home_old';
    static String ROUTE_IDEMPIERE_POS_LIST_PAGE = '/idempiere/pos/list';
    static String ROUTE_IDEMPIERE_POS_HOME_PAGE = '/idempiere/pos/home_old';
    static String ROUTE_IDEMPIERE_UOM_LIST_PAGE = '/idempiere/uom/list';
    static String ROUTE_IDEMPIERE_UOM_HOME_PAGE = '/idempiere/uom/home_old';
    static String ROUTE_IDEMPIERE_REGIONS_LIST_PAGE = '/idempiere/regions/list';
    static String ROUTE_IDEMPIERE_REGIONS_HOME_PAGE = '/idempiere/regions/home_old';
    static String ROUTE_IDEMPIERE_SALES_REGIONS_LIST_PAGE = '/idempiere/sales_regions/list';
    static String ROUTE_IDEMPIERE_SALES_REGIONS_HOME_PAGE = '/idempiere/sales_regions/home_old';
    static String ROUTE_IDEMPIERE_LOCATIONS_LIST_PAGE = '/idempiere/locations/list';
    static String ROUTE_IDEMPIERE_LOCATIONS_HOME_PAGE = '/idempiere/locations/home_old';
    static String ROUTE_IDEMPIERE_LOCATORS_LIST_PAGE = '/idempiere/locators/list';
    static String ROUTE_IDEMPIERE_LOCATORS_HOME_PAGE = '/idempiere/locators/home_old';
    static String ROUTE_IDEMPIERE_WAREHOUSES_LIST_PAGE = '/idempiere/warehouses/list';
    static String ROUTE_IDEMPIERE_WAREHOUSES_HOME_PAGE = '/idempiere/warehouses/home_old';
    static String ROUTE_IDEMPIERE_ORGANIZATIONS_LIST_PAGE = '/idempiere/organizations/list';
    static String ROUTE_IDEMPIERE_ORGANIZATIONS_HOME_PAGE = '/idempiere/organizations/home_old';

    static String ROUTE_IDEMPIERE_CURRENCIES_LIST_PAGE = '/idempiere/currencies/list';
    static String ROUTE_IDEMPIERE_CURRENCIES_HOME_PAGE = '/idempiere/currencies/home_old';

    static String ROUTE_IDEMPIERE_TAXES_LIST_PAGE = '/idempiere/taxes/list';
    static String ROUTE_IDEMPIERE_TAXES_HOME_PAGE = '/idempiere/taxes/home_old';
    static String ROUTE_IDEMPIERE_TAXES_CATEGORIES_LIST_PAGE = '/idempiere/tax_categories/list';
    static String ROUTE_IDEMPIERE_TAXES_CATEGORIES_HOME_PAGE = '/idempiere/tax_categories/home_old';

    static String ROUTE_IDEMPIERE_USER_WITH_DETAILS_LIST_PAGE = '/idempiere/user_with_details/list';
    static String ROUTE_IDEMPIERE_USER_WITH_DETAILS_HOME_PAGE = '/idempiere/user_with_details/home_old';

    static String ROUTE_IDEMPIERE_TENANT_WITH_DETAILS_LIST_PAGE = '/idempiere/tenant_with_details/list';
    static String ROUTE_IDEMPIERE_TENANT_WITH_DETAILS_HOME_PAGE = '/idempiere/tenant_with_details/home_old';

    static String ROUTE_IDEMPIERE_PRICE_LISTS_LIST_PAGE = '/idempiere/price_lists/list';
    static String ROUTE_IDEMPIERE_PRICE_LISTS_HOME_PAGE = '/idempiere/price_lists/home_old';

    static String ROUTE_IDEMPIERE_PRICE_LIST_VERSIONS_LIST_PAGE = '/idempiere/price_list_versions/list';
    static String ROUTE_IDEMPIERE_PRICE_LIST_VERSIONS_HOME_PAGE = '/idempiere/price_list_versions/home_old';
    static String ROUTE_IDEMPIERE_TRANSACTIONS_LIST_PAGE = '/idempiere/transactions/list';
    static String ROUTE_IDEMPIERE_TRANSACTIONS_HOME_PAGE = '/idempiere/transactions/home_old';


    static String ROUTE_WEB_VIEW_PAGE ='/web/view';
    static String ROUTE_EXCEL_PAGE ='/excel';
    static String ROUTE_LOGIN_PAGE ='/'; // login_page
    static String ROUTE_REGISTER_PAGE ='/register';
    static String ROUTE_HOME_PAGE ='/home_old';
    static String ROUTE_ROLES_PAGE = '/roles';
    static String ROUTE_IMAGE_TOOL_PAGE = '/utils/image/tool';



    static String ROUTE_SELLER_ORDER_LIST_PAGE_1 = '/seller/orders/list1';
    static String ROUTE_SELLER_ORDER_LIST_PAGE_2 = '/seller/orders/list2';
    static String ROUTE_SELLER_ORDER_LIST_PAGE_3 = '/seller/orders/list3';
    static String ROUTE_SELLER_ORDER_LIST_PAGE_4 = '/seller/orders/list4';
    static String ROUTE_SELLER_ORDER_CREATE_PAGE = '/seller/orders/create';
    static String ROUTE_SELLER_PRODUCTS_DETAIL_PAGE = '/seller/orders/products/detail';
    static String ROUTE_SELLER_ORDER_LIST_DELIVERED_PAGE = '/seller/orders/listDelivered';
    static String ROUTE_SELLER_ORDER_LIST_SHIPPED_PAGE = '/seller/orders/listShipped';
    static String ROUTE_SELLER_ORDER_LIST_CANCELED_PAGE = '/seller/orders/listCanceled';
    static String ROUTE_SELLER_ORDER_LIST_RETURNED_PAGE = '/seller/orders/listReturned';
    static String ROUTE_SELLER_ORDER_DETAIL_PAGE = '/seller/orders/detail';
    static String ROUTE_SELLER_ORDER_MAP_PAGE = '/seller/orders/map';
    static String ROUTE_SELLER_ORDER_RETURN_PAGE = '/seller/orders/return';
    static String ROUTE_SELLER_ORDER_LISTMAP_PAGE = '/seller/orders/listMap';
    static String ROUTE_SELLER_HOME_PAGE = '/seller/home_old';
    static String ROUTE_SELLER_PRODUCTS_LIST_PAGE = '/seller/products/list';
    static String ROUTE_SOCIETY_LIST_PAGE = '/societies/list';

    static String ROUTE_ADDERESS_LIST_PAGE = '/client/address/list';
    static String ROUTE_ADMIN_HOME_PAGE = '/admin/home_old';
    static String ROUTE_ADMIN_DATABASE_HANDLING_PAGE = '/admin/database';

    static String ROUTE_ADMIN_CATEGORIES_CREATE_PAGE = '/admin/categories/create';
    static String ROUTE_ADMIN_CATEGORIES_HANDLING_PAGE = '/admin/categories/handling';
    static String ROUTE_ADMIN_PRODUCTS_CREATE_PAGE = '/admin/products/create';
    static String ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_CREATE_PAGE = '/admin/groups/products/create';
    static String ROUTE_ADMIN_PRODUCTS_HANDLING_PAGE = '/admin/products/handling';
    static String ROUTE_ADMIN_PRODUCTS_PRICE_BY_GROUP_HANDLING_PAGE = '/admin/groups/products/handling';

    static String ROUTE_DELIVERY_MAN_ORDER_LIST_PAGE = '/delivery/orders/list';
    static String ROUTE_DELIVERY_MAN_HOME_PAGE = '/delivery/home_old';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_SHIPPED_PAGE = '/delivery/orders/listShipped';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_PAGE_2 = '/delivery/orders/listAllUncompleted';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_DELIVERED_PAGE = '/delivery/orders/listDelivered';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_CANCELED_PAGE = '/delivery/orders/listCanceled';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_RETURNED_PAGE = '/delivery/orders/listReturned';
    static String ROUTE_DELIVERY_MAN_ORDER_DETAIL_PAGE = '/delivery/orders/detail';
    static String ROUTE_DELIVERY_MAN_ORDER_RETURN_PAGE = '/delivery/orders/return';
    static String ROUTE_DELIVERY_MAN_ORDER_MAP_PAGE = '/delivery/orders/map';
    static String ROUTE_DELIVERY_MAN_ORDER_LIST_ALL_UNCOMPLETED_PAGE = '/delivery/orders/listAllUncompleted';
    static String ROUTE_DELIVERY_MAN_INVOICE_NUMBER_PAGE = '/delivery/invoice/number';
    static String ROUTE_CLIENT_HOME_PAGE = '/client/home_old';

    static String ROUTE_CLIENT_PRODUCTS_LIST_PAGE = '/client/products/list';
    static String ROUTE_CLIENT_PRODUCTS_DETAIL_PAGE = '/client/products/detail';

    static String ROUTE_CLIENT_ORDER_LIST_DELIVERED_PAGE = '/client/orders/listDelivered';
    static String ROUTE_CLIENT_ORDER_LIST_CANCELED_PAGE = '/client/orders/listCanceled';
    static String ROUTE_CLIENT_ORDER_LIST_RETURNED_PAGE = '/client/orders/listReturned';
    static String ROUTE_CLIENT_ORDER_LIST_SHIPPED_PAGE = '/client/orders/listShipped';
    static String ROUTE_CLIENT_ORDER_MAP_PAGE = '/client/orders/map';
    static String ROUTE_CLIENT_ORDER_LIST_PAGE = '/client/orders/list';
    static String ROUTE_CLIENT_ORDER_DETAIL_PAGE = '/client/orders/detail';
    static String ROUTE_CLIENT_ORDER_PAYMENT_PAGE = '/client/orders/payment';
    static String ROUTE_CLIENT_ORDER_CREATE_PAGE = '/client/orders/create';
    static String ROUTE_CLIENT_ADDRESS_LIST_PAGE = '/client/address/list';
    static String ROUTE_CLIENT_ADDRESS_CREATE_PAGE = '/client/address/create';
    static String ROUTE_CLIENT_ADDRESS_UPDATE_PAGE = '/client/address/update';

    static String ROUTE_CLIENT_PAYMENTS_CREATE_PAGE = '/client/payments/create';


    static String PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITH_CREDIT = ROUTE_CLIENT_PRODUCTS_LIST_PAGE;
    static String PAGE_TO_RETURN_AFTER_ORDER_CREATE_WITHOUT_CREDIT = ROUTE_CLIENT_PAYMENTS_CREATE_PAGE;
    static String PAGE_TO_RETURN_AFTER_ORDER_PAYMENT_CREATE = ROUTE_CLIENT_HOME_PAGE;
    static String PAGE_TO_RETURN_FROM_CLIENT_PRODUCTS_LIST = ROUTE_CLIENT_HOME_PAGE;

    static String PAGE_TO_RETURN_AFTER_DELIVERY_INVOICE_PAGE = ROUTE_DELIVERY_MAN_HOME_PAGE;
    static String PAGE_TO_RETURN_AFTER_DELIVERY = ROUTE_DELIVERY_MAN_HOME_PAGE;
    static String PAGE_TO_RETURN_FROM_ORDERS_RETURN_PAGE = ROUTE_DELIVERY_MAN_HOME_PAGE;

    static String ROUTE_ACCOUNTING_HOME_PAGE = '/accounting/home_old';
    static String ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_DELIVERED_PAGE = '/accounting/order/listDelivered';
    static String ROUTE_ACCOUNTING_SOCIETY_ORDER_LIST_UNCOMPLETED_PAGE = '/accounting/order/listUncompleted';

    static String ROUTE_USER_PROFILE_INFO_PAGE= '/client/profile/info';
    static String ROUTE_USER_PROFILE_UPDATE_PAGE= '/client/profile/update';
    static String ROUTE_USER_PROFILE_UPDATE_PASSWORD_PAGE = '/client/profile/updatePassword';
    static String ROUTE_ORDERSPICKER_ORDER_LIST_PAGE = '/orderspicker/orders/list';
    static String ROUTE_ORDERSPICKER_HOME_PAGE = '/orderspicker/home_old';
    static String ROUTE_WAREHOUSE_HOME_PAGE = '/warehouse/home_old';
    static String SOCIETY= 'SOCIEDAD';
    static String SELLER= 'VENDEDOR';
    static String ADMIN = 'ADMINISTRADOR';
    static String DELIVERY_MAN = 'REPARTIDOR';
    static String USUARIO = 'USUARIO';
    static String CLIENT = 'CLIENTE';
    static String ORDERS = 'ORDENES';
    static String CATEGORIES = 'CATEGORIAS';
    static String PRODUCTS = 'PRODUCTOS';
    static String ORDERS_PICKER = 'PREPARADOR DE PEDIDOS';
    static String ACCOUNTING = 'CONTABILIDAD';
    static String WAREHOUSE = 'DEPOSITO';
    static String POS = 'POS';

    //post
    static final String IDEMPIERE_ENDPOINT_AUTH_LOGIN = '/auth/tokens';
    static final String IDEMPIERE_ENDPOINT_AUTH_ROLES = '/auth/roles';
    static final String IDEMPIERE_ENDPOINT_AUTH_ORGANIZATIONS = '/auth/organizations';
    static final String IDEMPIERE_ENDPOINT_AUTH_WAREHOUSES = '/auth/warehouses';
    static final String IDEMPIERE_ENDPOINT_AUTH_LANGUAGE = '/auth/language';
    static final String IDEMPIERE_ENDPOINT_AUTH_REFRESH = '/auth/refresh';
    static final String IDEMPIERE_ENDPOINT_AUTH_LOGOUT = '/auth/logout';
    static final String IDEMPIERE_ENDPOINT_PRODUCTS = '/models/m_product';
    static final String IDEMPIERE_ENDPOINT_PRODUCTS_CATEGORY = '/models/M_Product_Category';
    static final String IDEMPIERE_ENDPOINT_BUSINESS_PARTNER = '/models/c_bpartner';
    static final String IDEMPIERE_ENDPOINT_BUSINESS_PARTNER_LOCATION = '/models/c_bpartner_location';
    static final String IDEMPIERE_ENDPOINT_TAX_CATEGORY = '/models/C_TaxCategory';
    static final String IDEMPIERE_ENDPOINT_PRODUCTS_BRAND = '/models/MOLI_ProductBrand';
    static final String IDEMPIERE_ENDPOINT_PRODUCTS_LINE = '/models/MOLI_ProductLine';
    static final String IDEMPIERE_ENDPOINT_PRODUCTS_PRICE = '/models/m_productprice';
    static final String IDEMPIERE_ENDPOINT_TAX = '/models/C_Tax';
    static final String IDEMPIERE_ENDPOINT_TRANSACTION = '/models/m_transaction';
    static final String IDEMPIERE_ENDPOINT_COUNTRY = '/models/c_country';
    static final String IDEMPIERE_ENDPOINT_CITY = '/models/c_city';
    static final String IDEMPIERE_ENDPOINT_POS = '/models/c_pos';
    static final String IDEMPIERE_ENDPOINT_UOM = '/models/c_uom';
    static final String IDEMPIERE_ENDPOINT_REGION = '/models/c_region';
    static final String IDEMPIERE_ENDPOINT_CURRENCY = '/models/c_currency';
    static final String IDEMPIERE_ENDPOINT_SALES_REGION = '/models/c_salesregion';
    static final String IDEMPIERE_ENDPOINT_LOCATION = '/models/c_location';
    static final String IDEMPIERE_ENDPOINT_LOCATOR = '/models/m_locator';
    static final String IDEMPIERE_ENDPOINT_WAREHOUSE = '/models/m_warehouse';
    static final String IDEMPIERE_ENDPOINT_ORGANIZATION = '/models/ad_org';
    static final String IDEMPIERE_ENDPOINT_USER = '/models/ad_user';
    static final String IDEMPIERE_ENDPOINT_TENANT = '/models/ad_client';
    static final String IDEMPIERE_ENDPOINT_PRICE_LIST = '/models/m_pricelist';
    static final String IDEMPIERE_ENDPOINT_PRICE_LIST_VERSION = '/models/m_pricelist_version';




    // debe coincidir con archivo usersRoute.js , projecto node.js
    static String NODEJS_ROUTE_SOCKET_IO_BASE_DELIVERY ='/orders/delivery';
    static String NODEJS_ROUTE_SOCKET_IO_BASE_WAREHOUSE ='/orders/warehouse';
    static String NODEJS_ROUTE_SOCKET_DELIVERED ='delivered';
    static String NODEJS_ROUTE_SOCKET_NEW_ORDER ='new_order';
    static String NODEJS_ROUTE_SOCKET_RETURNED ='returned';
    static String NODEJS_ROUTE_SOCKET_POSITION ='position';






    static String NODEJS_ROUTE_USER_LOGIN ='/api/users/login'; // login_page
    static String NODEJS_ROUTE_USER_REGISTER ='/api/users/create';
    static String NODEJS_ROUTE_USER_UPDATE_WITHOUT_IMAGE ='/api/users/updateWithoutImage';
    static String NODEJS_ROUTE_USER_UPDATE_NOTIFICATION_TOKEN ='/api/users/updateNotificationToken';
    static String NODEJS_ROUTE_USER_UPDATE_WITH_IMAGE ='/api/users/updateWithImage';
    static String NODEJS_ROUTE_USER_UPDATE_PASSWORD='/api/users/updatePassword';
    static String NODEJS_ROUTE_USER_REGISTER_WITH_IMAGE ='/api/users/createWithImage';
    static String NODEJS_ROUTE_USER_GET_USERS_BY_ROL ='/api/users/getUsersByRol';

    static String NODEJS_ROUTE_CATEGORY_GET_ALL ='/api/categories/getAll';
    static String NODEJS_ROUTE_CATEGORY_GET_BY_ID ='/api/categories/getById';
    static String NODEJS_ROUTE_CATEGORY_GET_BY_CONDITION ='/api/categories/getByCondition';
    static String NODEJS_ROUTE_CATEGORY_GET_BY_NAME ='/api/categories/getByName';
    static String NODEJS_ROUTE_CATEGORY_CREATE ='/api/categories/create';
    static String NODEJS_ROUTE_CATEGORY_CREATE_WITH_IMAGE ='/api/categories/createWithImage';
    static String NODEJS_ROUTE_CATEGORY_UPDATE ='/api/categories/update';
    static String NODEJS_ROUTE_CATEGORY_UPDATE_WITH_IMAGE ='/api/categories/updateWithImage';
    static String NODEJS_ROUTE_CATEGORY_UPDATE_WITHOUT_IMAGE ='/api/categories/updateWithoutImage';
    static String NODEJS_ROUTE_CATEGORY_DELETE ='/api/categories/delete';

    static String NODEJS_ROUTE_PAYMENTS_CREATE ='/api/payments/create';
    static String NODEJS_ROUTE_PAYMENTS_UPDATE ='/api/payments/update';

    static String NODEJS_ROUTE_ORDERS_CREATE ='/api/orders/create';
    static String NODEJS_ROUTE_ORDERS_CREATE_CREDIT_ORDER ='/api/orders/createCreditOrder';
    static String NODEJS_ROUTE_ORDERS_UPDATE ='/api/orders/update';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_PREPARED ='/api/orders/updateToPrepared';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_SHIPPED='/api/orders/updateToShipped';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_SETTLEMENT='/api/orders/updateToSettlement';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_PAID_AND_DELIVERY_ID_NULL ='/api/orders/updateToPaidAndDeliveryIdNull';
    static String NODEJS_ROUTE_ORDERS_UPDATE_LAT_LNG ='/api/orders/updateLatLng';
    static String NODEJS_ROUTE_ORDERS_UPDATE_ORDER_STATUS_TO_DELIVERED_WITH_INVOICE ='/api/orders/updateOrderDeliveredWithInvoice';
    static String NODEJS_ROUTE_ORDERS_UPDATE_ORDER_STATUS = '/api/orders/updateOrderStatus';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_TOTAL_RETURNED_STATUS ='/api/orders/updateToTotalReturned';
    static String NODEJS_ROUTE_ORDERS_UPDATE_TO_PATRIALLY_RETURNED_STATUS ='/api/orders/updateToPartiallyReturned';
    static String NODEJS_ROUTE_ORDER_GET_CLIENT_ORDER_BY_ORDER_STATUS ='/api/orders/findClientOrderByStatus';
    static String NODEJS_ROUTE_ORDER_GET_SELLER_ORDER_BY_ORDER_STATUS ='/api/orders/findSellerOderByStatus';
    static String NODEJS_ROUTE_ORDER_GET_BY_DELIVERY_AND_STATUS ='/api/orders/findByDeliveryAndStatus';
    static String NODEJS_ROUTE_ORDER_GET_BY_SOCIETY_AND_STATUS ='/api/orders/findOrderBySocietyAndStatus';
    static String NODEJS_ROUTE_ORDER_GET_FOR_ACCOUNTING_BY_SOCIETY_AND_STATUS ='/api/orders/findOrderForAccountingBySocietyAndStatus';
    static String NODEJS_ROUTE_WAREHOUSE_GET_WAREHOUSE_BY_ID ='/api/warehouses/findByUser';

    static String NODEJS_ROUTE_VAT_GET_ALL_ACTIVE ='/api/vats/getAllActive';
    static String NODEJS_ROUTE_VAT_CREATE ='/api/vats/create';
    static String NODEJS_ROUTE_VAT_UPDATE ='/api/vats/update';

    static String NODEJS_ROUTE_ADDRESS_GET_BY_SOCIETY_USER_AND_ACTIVE ='/api/addresses/getBySocietyUserAndActive';
    static String NODEJS_ROUTE_ADDRESS_CREATE ='/api/addresses/create';
    static String NODEJS_ROUTE_ADDRESS_UPDATE ='/api/addresses/update';

    static String NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_CREATE ='/api/groups/products/priceCreate';
    static String NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_UPDATE ='/api/groups/products/priceUpdate';
    static String NODEJS_ROUTE_GROUP_PRODUCT_PRICE_BY_GROUP_GET_ALL ='/api/groups/products/priceGetAll';

    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_ACTIVE_BY_GROUP_ID ='/api/groups/products/getProductsWithPriceActiveByGroupId';
    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_BY_GROUP_ID ='/api/groups/products/getProductsWithPriceByGroupId';
    static String NODEJS_ROUTE_GROUP_CATEGORIES_GET_ACTIVE_BY_CONDITION ='/api/groups/categories/getActiveByCondition';
    static String NODEJS_ROUTE_GROUP_CATEGORIES_GET_BY_CONDITION ='/api/groups/categories/getByCondition';

    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_ACTIVE_BY_CONDITION
                                        ='/api/groups/products/getProductsWithPriceActiveByCondition';
    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_ACTIVE_BY_CATEGORY_AND_GROUP
                                        ='/api/groups/products/getProductsWithPriceActiveByCategoryAndGroup';
    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_BY_CATEGORY_AND_GROUP
                                        ='/api/products/getProductsWithPriceByCategoryAndGroup';
    static String NODEJS_ROUTE_GROUP_GET_PRODUCTS_WITH_PRICE_BY_CONDITION ='/api/products/getProductsWithPriceByCondition';

    static String NODEJS_ROUTE_GROUP_GET_ALL ='/api/groups/getAll';
    static String NODEJS_ROUTE_GROUP_GET_ALL_ACTIVE ='/api/groups/getAllActive';
    static String NODEJS_ROUTE_GROUP_GET_BY_CONDITION ='/api/groups/getByCondition';
    static String NODEJS_ROUTE_GROUP_CREATE ='/api/groups/create';
    static String NODEJS_ROUTE_GROUP_UPDATE ='/api/groups/update';

    static String NODEJS_ROUTE_PRODUCT_GET_ALL_BY_USER_ID ='/api/products/getAllByUserId';
    static String NODEJS_ROUTE_PRODUCT_GET_BY_ID ='/api/products/getById';
    static String NODEJS_ROUTE_PRODUCT_GET_BY_NAME ='/api/products/getByName';
    static String NODEJS_ROUTE_PRODUCT_GET_BY_CONDITION ='/api/products/getByCondition';
    static String NODEJS_ROUTE_PRODUCT_CREATE_WITH_1_IMAGE ='/api/products/createWith1Image';
    static String NODEJS_ROUTE_PRODUCT_CREATE_WITH_2_IMAGE ='/api/products/createWith2Image';
    static String NODEJS_ROUTE_PRODUCT_CREATE_WITH_3_IMAGE ='/api/products/createWith3Image';
    static String NODEJS_ROUTE_PRODUCT_UPDATE_WITH_OUT_IMAGE ='/api/products/updateWithoutImage';
    static String NODEJS_ROUTE_PRODUCT_UPDATE_WITH_1_IMAGE ='/api/products/updateWith1Image';
    static String NODEJS_ROUTE_PRODUCT_UPDATE_WITH_2_IMAGE ='/api/products/updateWith2Image';
    static String NODEJS_ROUTE_PRODUCT_UPDATE_WITH_3_IMAGE ='/api/products/updateWith3Image';
    static String NODEJS_ROUTE_PRODUCT_DELETE ='/api/products/delete';

    static String NODEJS_ROUTE_SOCIETY_GET_ALL ='/api/societies/getAll';








    //static String NODEJS_ROUTE_='/api/';
    static String IMAGE_LOGO ='assets/img/logo_name.jpg';
    static String IMAGE_WHATSAPP ='assets/img/whatsapp.png';
    static String IMAGE_SHEETS ='assets/img/sheets.png';
    static String IMAGE_ROL_ADMIN = 'assets/img/admin.png';
    static String IMAGE_ROL_SOCIETY = 'assets/img/seller.png';
    static String IMAGE_ROL_POS = 'assets/img/pos.png';
    static String IMAGE_STORE_DEFAULT = 'assets/img/store_default.png';
    static String IMAGE_ROL_DELIVERY_MAN ='assets/img/delivery_man.png' ;
    static String IMAGE_ROL_CLIENT = 'assets/img/user.png';
    static String IMAGE_ROL_ORDERSPICKER = 'assets/img/order_picker.png';
    static String IMAGE_ROL_WAREHOUSE= 'assets/img/warehouse.png';
    static String IMAGE_ROL_ACCOUNTING = 'assets/img/accounting.png';
    static String IMAGE_NO_IMAGE = 'assets/img/no-image.png';
    static String IMAGE_COVER_IMAGE = 'assets/img/cover_image.png';
    static String IMAGE_CATEGORIES = 'assets/img/list.png';
    static String IMAGE_GOOGLE ='images/icons8-google-48.png';
    static String IMAGE_FACEBOOK ='images/icons8-facebook-48.png';
    static String IMAGE_SAVE ='assets/img/save.64.png';
    static String IMAGE_MY_LOCATION ='assets/img/my_location_yellow.png';
    static String IMAGE_DELITE ='assets/img/X.64.png';
    static String IMAGE_UPDATE ='assets/img/edit.64.png';
    static String IMAGE_FIND ='assets/img/find.64.png';
    static String IMAGE_CREATE ='assets/img/plus.64.png';
    static String IMAGE_REFRESH ='assets/img/refresh.png';
    static String IMAGE_0_ITEMS ='assets/img/zero_items.png';
    static String IMAGE_0_ITEMS_2 ='assets/img/zero_items_2.png';
    static String IMAGE_DELIVERY_MAP ='assets/img/delivery_map.png';
    static String IMAGE_DELIVERY_MAP_SMALL ='assets/img/delivery_map_small_64.png';
    static String IMAGE_HOME_MAP ='assets/img/home_red.png';

    static String IMAGE_SPLASH_SCREEN = 'assets/img/splash_screen.jpg';
    static Rol ROL_ADMIN = Rol(id:1,name: ADMIN,route: ROUTE_ADMIN_HOME_PAGE, image: IMAGE_ROL_ADMIN,isActive: true );
    static Rol ROL_DELIVERY_MAN = Rol(id:2,name:DELIVERY_MAN,route: ROUTE_DELIVERY_MAN_HOME_PAGE, image:IMAGE_ROL_DELIVERY_MAN ,isActive: true);
    static Rol ROL_CLIENT = Rol(id:3,name:USUARIO,route: ROUTE_CLIENT_HOME_PAGE, image: IMAGE_ROL_CLIENT,isActive: true );
    static Rol ROL_ORDERSPICKER = Rol(id:4,name:ORDERS_PICKER,route: ROUTE_ORDERSPICKER_HOME_PAGE, image: IMAGE_ROL_ORDERSPICKER,isActive: true );
    static Rol ROL_SELLER = Rol(id:5,name:SELLER,route: ROUTE_SELLER_HOME_PAGE, image: IMAGE_ROL_SOCIETY,isActive: true );
    static Rol ROL_ACCOUNTING = Rol(id:6,name:ACCOUNTING,route: ROUTE_ACCOUNTING_HOME_PAGE, image: IMAGE_ROL_ACCOUNTING,isActive: true );
    static Rol ROL_WAREHOUSE = Rol(id:7,name:WAREHOUSE,route: ROUTE_WAREHOUSE_HOME_PAGE, image: IMAGE_ROL_WAREHOUSE,isActive: true );
    static Rol ROL_POS = Rol(id:8,name:POS,route: ROUTE_SELLER_HOME_PAGE, image: IMAGE_ROL_SOCIETY,isActive: true );

    static List<Rol> ROLES_LIST =<Rol> [ROL_ADMIN,ROL_DELIVERY_MAN,ROL_CLIENT,ROL_ORDERSPICKER,
        ROL_SELLER,ROL_ACCOUNTING,ROL_WAREHOUSE,ROL_POS];
    static List<String> ROLES_IMAGE_LIST = <String>[IMAGE_ROL_ADMIN,IMAGE_ROL_DELIVERY_MAN ,
        IMAGE_ROL_CLIENT,IMAGE_ROL_ORDERSPICKER,IMAGE_ROL_SOCIETY,IMAGE_ROL_ACCOUNTING,
        IMAGE_ROL_WAREHOUSE,IMAGE_ROL_POS];

    static String IMAGE_LOGIN_PAGE_ICON = 'assets/img/login_page_icon.png';

    static String NULL_FILE ='ARCHIVO NULO';

    static String IMAGE_USER_PROFILE ='assets/img/user_profile.png';

    static String USER_INFO ='INFORMACION DEL USUARIO';

  static String CHANGE_PASSWORD ='CAMBIAR PASSWORD';












    static Map<String,String> getHeaders(){
        String token ='';
        User userSession =  Memory.getSavedUser();
        if(userSession.sessionToken!=null){
            token =userSession.sessionToken!;
        }
        return {'Content-Type':'application/json','Authorization': token};

    }
    static Map<String,String> getHeadersWithoutToken(){

        return {'Content-Type':'application/json','Authorization': ''};
    }
    static Map<String,String> getHeadersWithoutTokenIdempiere(){

        return {'Content-Type':'application/json'};
    }

    static String getSessionToken() {
        User userSession = getSavedUser();
        String token ='';
        if(userSession.sessionToken!=null){
            token = userSession.sessionToken!;
        }
        return token;
    }
    static User getSavedUser(){
        var data = GetStorage().read(Memory.KEY_USER) ?? {};
        if(data is User){
            return data;
        } else if(data is Map<String,dynamic>){
            User user = User.fromJson(data);
            return user;
        } else {
            GetStorage().remove(Memory.KEY_USER);
            return User();
        }

    }
    static IdempiereUser getSavedIdempiereUser(){
        var data = GetStorage().read(Memory.KEY_IDEMPIERE_USER) ?? {};
        if(data is IdempiereUser){
            return data;
        } else if(data is Map<String,dynamic>){
            IdempiereUser user = IdempiereUser.fromJson(data);
            return user;
        } else {
            GetStorage().remove(Memory.KEY_USER);
            return IdempiereUser();
        }

    }

    static Future<bool> checkExternalMediaPermission() async {
        late PermissionStatus status;
        final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
        final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
        if (info.version.sdkInt >= 33) {
            // android 13+
            status = await Permission.manageExternalStorage.request();
            print('android 33+ storagey $status');
            status = await Permission.videos.request();
            print('android 33+ video $status');
        } else if (info.version.sdkInt >= 30) {
            // android 11+ `storage.request()` still work on 11
            //status = await Permission.storage.request();  // dialog

            status = await Permission.manageExternalStorage.request(); // full screen
            print('android 30+ video $status');
        } else {
            status = await Permission.storage.request();
        }
        print('status $status');
        if(status == PermissionStatus.permanentlyDenied){
            openAppSettings();
            return false;
        } else if(status == PermissionStatus.denied){
            return false;
        } else if(status == PermissionStatus.granted){
            return true;
        }
        return false;
    }

  static  DateTime getDateTimeNowLocal(){
        return DateTime.now().add(Duration(hours: TIMEZONE_OFFSET));
  }


//--------------------------------------
  static const String KEY_ID ='id';
  static const String dbName ='mylancd';
  static String dbUser ='mylancd';
  static int dbPort = 5432 ;

  static String KEY_ONLY_TV='KEY_ONLY_TY';
  static String KEY_GROUP_ID='KEY_GROUP_ID';

  static String KEY_FUNCTION='KEY_FUNCTION';

  static String ROUTE_PANEL_SC_CALLING_PAGE='/panel_sc/calling';

  static final String KEY_APP_FILE_HOST_WITH_HTTP ='app_file_host_with_http';
  static String APP_FILE_HOST_WITH_HTTP ='';

  static String KEY_COSTUM_URL='key_custom_url';

  static String ROUTE_PANEL_SC_VIDEO_DOWNLOAD_PAGE='/video/download';

  static String ROUTE_PANEL_SC_SHOW_ATTENDANCE_PAGE='/attendance/show';

  static String ROUTE_PANEL_SC_REGISTER_ATTENDANCE_PAGE='/attendance/register';

  static String KEY_TEST_MODE='key_test_mode';
  static String DB_NAME = 'solexpresspy.db';





















}
