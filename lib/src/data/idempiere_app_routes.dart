import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart'; // Keep necessary imports
import 'package:solexpress_panel_sc/src/data/memory.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/business_partner/home/idempiere_business_partners_home_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/business_partner/location/list/idempiere_business_partner_location_list_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/country/list/idempiere_countries_list_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/home/idempiere_home_page1.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/home/idempiere_home_page2.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/object/detail/idempiere_object_detail_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/price_list/version/home/idempiere_price_list_versions_home_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/price_list/version/list/idempiere_price_list_versions_list_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/products/brand/list/idempiere_products_brands_list_page.dart';
import 'package:solexpress_panel_sc/src/idempiere/page/products/category/list/idempiere_products_categories_list_page.dart';

import '../idempiere/page/business_partner/list/idempiere_business_partners_list_page.dart';
import '../idempiere/page/business_partner/location/home/idempiere_business_partner_locations_home_page.dart';
import '../idempiere/page/city/home/idempiere_cities_home_page.dart';
import '../idempiere/page/city/list/idempiere_cities_list_page.dart';
import '../idempiere/page/configuration/idempiere_configuration_page.dart';
import '../idempiere/page/country/home/idempiere_countries_home_page.dart';
import '../idempiere/page/currency/home/idempiere_currencies_home_page.dart';
import '../idempiere/page/currency/list/idempiere_currencies_list_page.dart';
import '../idempiere/page/home/idempiere_home_page.dart';
import '../idempiere/page/location/home/idempiere_locations_home_page.dart';
import '../idempiere/page/location/list/idempiere_locations_list_page.dart';
import '../idempiere/page/locator/home/idempiere_locators_home_page.dart';
import '../idempiere/page/locator/list/idempiere_locators_list_page.dart';
import '../idempiere/page/login/idempiere_login_page.dart';
import '../idempiere/page/organization/home/idempiere_organizations_home_page.dart';
import '../idempiere/page/organization/list/idempiere_organizations_list_page.dart';
import '../idempiere/page/pos/home/idempiere_pos_home_page.dart';
import '../idempiere/page/pos/list/idempiere_pos_list_page.dart';
import '../idempiere/page/price_list/home/idempiere_price_lists_home_page.dart';
import '../idempiere/page/price_list/list/idempiere_price_lists_list_page.dart';
import '../idempiere/page/products/brand/home/idempiere_products_brands_home_page.dart';
import '../idempiere/page/products/category/home/idempiere_products_categories_home_page.dart';
import '../idempiere/page/products/home/idempiere_products_home_page.dart';
import '../idempiere/page/products/line/home/idempiere_products_lines_home_page.dart';
import '../idempiere/page/products/line/list/idempiere_products_lines_list_page.dart';
import '../idempiere/page/products/list/idempiere_products_list_page.dart';
import '../idempiere/page/products/price/home/idempiere_products_prices_home_page.dart';
import '../idempiere/page/products/price/list/idempiere_products_prices_list_page.dart';
import '../idempiere/page/region/home/idempiere_regions_home_page.dart';
import '../idempiere/page/region/list/idempiere_regions_list_page.dart';
import '../idempiere/page/roles/idempiere_roles_page.dart';
import '../idempiere/page/sales_region/home/idempiere_sales_regions_home_page.dart';
import '../idempiere/page/sales_region/list/idempiere_sales_regions_list_page.dart';
import '../idempiere/page/tax/category/home/idempiere_taxes_categories_home_page.dart';
import '../idempiere/page/tax/category/list/idempiere_taxes_categories_list_page.dart';
import '../idempiere/page/tax/idempiere_taxes_home_page.dart';
import '../idempiere/page/tax/idempiere_taxes_list_page.dart';
import '../idempiere/page/tenant_with_detail/home/idempiere_tenant_with_details_home_page.dart';
import '../idempiere/page/tenant_with_detail/list/idempiere_tenant_with_details_list_page.dart';
import '../idempiere/page/transaction/home/idempiere_transactions_home_page.dart';
import '../idempiere/page/transaction/list/idempiere_transactions_list_page.dart';
import '../idempiere/page/uom/home/idempiere_uom_home_page.dart';
import '../idempiere/page/uom/list/idempiere_uom_list_page.dart';
import '../idempiere/page/user_with_detail/home/idempiere_user_with_details_home_page.dart';
import '../idempiere/page/user_with_detail/list/idempiere_user_with_details_list_page.dart';
import '../idempiere/page/warehouse/home/idempiere_warehouses_home_page.dart';
import '../idempiere/page/warehouse/list/idempiere_warehouses_list_page.dart';
import '../utils/image/tool/image_tool_page.dart';
// ... import all your page files

class IdempiereAppRoutes {
  static final int seconds = Memory.DURATION_TRANSITION_SECUNDS ;
  static final int milliSeconds = Memory.DURATION_TRANSITION_MILLI_SECUNDS ;
  static final int shortSeconds = Memory.DURATION_TRANSITION_SHORT_SECUNDS ;
  static final List<GetPage> pages = [
    GetPage(name: Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, page: ()=>IdempiereLoginPage(),
    transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_IDEMPIERE_CONFIGURATION_PAGE, page: ()=>IdempiereConfigurationPage()
    ,transition: Transition.zoom ,
    transitionDuration: Duration(milliseconds: milliSeconds),),
    GetPage(name: Memory.ROUTE_IDEMPIERE_HOME_PAGE, page: ()=>IdempiereHomePage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_IDEMPIERE_HOME_PAGE_1, page: ()=>IdempiereHomePage1(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: shortSeconds),),
    GetPage(name: Memory.ROUTE_IDEMPIERE_HOME_PAGE_2, page: ()=>IdempiereHomePage2(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: shortSeconds),),


    GetPage(name: Memory.ROUTE_IDEMPIERE_ROLES_PAGE, page: () => IdempiereRolesPage(),
    transition: Transition.circularReveal ,
    transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_IMAGE_TOOL_PAGE, page: () => ImageToolPage(title: Messages.IMAGE_TOOL,)),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_HOME_PAGE, page: () => IdempiereProductsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_LIST_PAGE, page: () => IdempiereProductsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_CATEGORIES_HOME_PAGE, page: () => IdempiereProductsCategoriesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_CATEGORIES_LIST_PAGE, page: () => IdempiereProductsCategoriesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_BRANDS_HOME_PAGE, page: () => IdempiereProductsBrandsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_BRANDS_LIST_PAGE, page: () => IdempiereProductsBrandsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_PRICES_HOME_PAGE, page: () => IdempiereProductsPricesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_PRICES_LIST_PAGE, page: () => IdempiereProductsPricesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),


    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_LINES_HOME_PAGE, page: () => IdempiereProductsLinesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRODUCTS_LINES_LIST_PAGE, page: () => IdempiereProductsLinesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),


    GetPage(name: Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNERS_HOME_PAGE, page: () => IdempiereBusinessPartnersHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNERS_LIST_PAGE, page: () => IdempiereBusinessPartnersListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_HOME_PAGE, page: () => IdempiereBusinessPartnerLocationsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_LIST_PAGE, page: () => IdempiereBusinessPartnerLocationsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_OBJECT_DETAIL_PAGE, page: () => IdempiereObjectDetailPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(milliseconds: shortSeconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_COUNTRIES_HOME_PAGE, page: () => IdempiereCountriesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_COUNTRIES_LIST_PAGE, page: () => IdempiereCountriesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_REGIONS_HOME_PAGE, page: () => IdempiereRegionsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_REGIONS_LIST_PAGE, page: () => IdempiereRegionsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_SALES_REGIONS_HOME_PAGE, page: () => IdempiereSalesRegionsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_SALES_REGIONS_LIST_PAGE, page: () => IdempiereSalesRegionsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_CITIES_HOME_PAGE, page: () => IdempiereCitiesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_CITIES_LIST_PAGE, page: () => IdempiereCitiesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_CURRENCIES_HOME_PAGE, page: () => IdempiereCurrenciesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_CURRENCIES_LIST_PAGE, page: () => IdempiereCurrenciesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_LOCATIONS_HOME_PAGE, page: () => IdempiereLocationsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_LOCATIONS_LIST_PAGE, page: () => IdempiereLocationsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_LOCATORS_HOME_PAGE, page: () => IdempiereLocatorsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_LOCATORS_LIST_PAGE, page: () => IdempiereLocatorsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_WAREHOUSES_HOME_PAGE, page: () => IdempiereWarehousesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_WAREHOUSES_LIST_PAGE, page: () => IdempiereWarehousesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_ORGANIZATIONS_HOME_PAGE, page: () => IdempiereOrganizationsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_ORGANIZATIONS_LIST_PAGE, page: () => IdempiereOrganizationsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_USER_WITH_DETAILS_HOME_PAGE, page: () => IdempiereUserWithDetailsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_USER_WITH_DETAILS_LIST_PAGE, page: () => IdempiereUserWithDetailsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TENANT_WITH_DETAILS_HOME_PAGE, page: () => IdempiereTenantWithDetailsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TENANT_WITH_DETAILS_LIST_PAGE, page: () => IdempiereTenantWithDetailsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TAXES_CATEGORIES_HOME_PAGE, page: () => IdempiereTaxesCategoriesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TAXES_CATEGORIES_LIST_PAGE, page: () => IdempiereTaxesCategoriesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),
    GetPage(name: Memory.ROUTE_IDEMPIERE_TAXES_HOME_PAGE, page: () => IdempiereTaxesHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TAXES_LIST_PAGE, page: () => IdempiereTaxesListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRICE_LISTS_HOME_PAGE, page: () => IdempierePriceListsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRICE_LISTS_LIST_PAGE, page: () => IdempierePriceListsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRICE_LIST_VERSIONS_HOME_PAGE, page: () => IdempierePriceListVersionsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_PRICE_LIST_VERSIONS_LIST_PAGE, page: () => IdempierePriceListVersionsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TRANSACTIONS_HOME_PAGE, page: () => IdempiereTransactionsHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_TRANSACTIONS_LIST_PAGE, page: () => IdempiereTransactionsListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_POS_HOME_PAGE, page: () => IdempierePOSHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_POS_LIST_PAGE, page: () => IdempierePOSListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_UOM_HOME_PAGE, page: () => IdempiereUOMHomePage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),

    GetPage(name: Memory.ROUTE_IDEMPIERE_UOM_LIST_PAGE, page: () => IdempiereUOMListPage(),
      transition: Transition.circularReveal ,
      transitionDuration: Duration(seconds: seconds),),


  ];
}