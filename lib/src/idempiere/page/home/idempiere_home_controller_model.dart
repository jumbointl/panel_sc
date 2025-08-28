import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_controller_model.dart';

import '../../../data/memory.dart';
import '../../../models/idempiere/idempiere_user.dart';
import '../../provider/idempiere_users_provider.dart';
class IdempiereHomeControllerModel extends IdempiereControllerModel {


  void refreshToken() async {
    IdempiereUser user = getSavedIdempiereUser();
    IdempiereUsersProvider usersProvider = IdempiereUsersProvider();
    await usersProvider.doRefreshWhenNeed(user);
    //Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_LOGIN_PAGE, (route) => false); // ELIMINAR EL HISTORIAL DE PANTALLAS
  }

  void goToBusinessPartnerHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNERS_HOME_PAGE);
  }

  void goToProductsCategoriesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_CATEGORIES_HOME_PAGE);

  }

  void goToProductsBrandsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_BRANDS_HOME_PAGE);
  }

  void goToCountriesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_COUNTRIES_HOME_PAGE);
  }

  void goToCitiesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_CITIES_HOME_PAGE);

  }

  void goToCurrenciesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_CURRENCIES_HOME_PAGE);
  }

  void goToProductsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_HOME_PAGE);
  }

  void goToProductsLinesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_LINES_HOME_PAGE);

  }

  void goToTaxesCategoriesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_TAXES_CATEGORIES_HOME_PAGE);
  }
  void goToTaxesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_TAXES_HOME_PAGE);
  }
  void goToRegionsHomePage() async {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_REGIONS_HOME_PAGE);
  }

  void goToLocationsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_LOCATIONS_HOME_PAGE);
  }

  void goToLocatorHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_LOCATORS_HOME_PAGE);
  }


  void goToSalesRegionHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_SALES_REGIONS_HOME_PAGE);
  }

  void goToUserWithDetailsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_USER_WITH_DETAILS_HOME_PAGE);

  }

  void goToOrganizationsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_ORGANIZATIONS_HOME_PAGE);
  }
  void goToWarehouseHomePage(){
    Get.toNamed(Memory.ROUTE_IDEMPIERE_WAREHOUSES_HOME_PAGE);
  }
  void goToTenantWithDetailsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_TENANT_WITH_DETAILS_HOME_PAGE);
  }
  void goToBusinessPartnerLocationsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_BUSINESS_PARTNER_LOCATIONS_HOME_PAGE);
  }
  void goToPriceListsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRICE_LISTS_HOME_PAGE);
  }
  void goToProductsPricesHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRODUCTS_PRICES_HOME_PAGE);

  }
  void goToPriceListVersionsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_PRICE_LIST_VERSIONS_HOME_PAGE);
  }
  void goToTransactionsHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_TRANSACTIONS_HOME_PAGE);
  }
  void goToUOMHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_UOM_HOME_PAGE);
  }

  void goToPOSHomePage() {
    Get.toNamed(Memory.ROUTE_IDEMPIERE_POS_HOME_PAGE);

  }
}