import '../../data/messages.dart';

class IdempiereRestCommand {

  static String userDefine =Messages.USER_DEFINE;
  static const List<String> operators =['eq' ,'neq' ,'in','gt','ge','lt','le','and',
    'or','not','contains','startswith','endswith','tolower','toupper',];
  static const List<String>  conjunctions =['AND','OR',];
  static List<String>  values =['true','false','null',userDefine];
  // for later change with assets/images/ icons
  static const List<String>  images =['eq' ,'neq' ,'in','gt','ge','lt','le','and',
    'or','not','contains','startswith','endswith','tolower','toupper',];


  static const List<String>  fieldsOfProducts =['UPC','SKU','Value','Name',];
  static const List<String>  fieldsOfProductsCategories =['Value','Name',];
  static const List<String>  fieldsOfProductsBrands =['Value','Name',];
  static const List<String>  fieldsOfBusinessPartner =['isCustomer','isActive',' C_BPartner_ID','Name',];
  static const List<String> fieldsOfCountries =['Value','Name',];
  static const List<String> fieldsOfCities =['Value','Name',];
  static const List<String> fieldsOfCurrencies=['Value','Name',];
  static const List<String> fieldsOfRegions=['Value','Name',];
  static const List<String> fieldsOfSalesRegions=['Value','Name',];
  static const List<String> fieldsOfLocations=['Value','Name',];
  static const List<String> fieldsOfLocators=['Value','Name',];
  static const List<String> fieldsOfWarehouses=['Value','Name',];
  static const List<String> fieldsOfOrganizations=['Value','Name',];
  static const List<String> fieldsOfUserWithDetails=['Value','Name',];
  static const List<String> fieldsOfProductsLines=['Value','Name',];
  static const List<String> fieldsOfTaxesCategories=['Value','Name',];
  static const List<String> fieldsOfTaxes=['Rate','Name',];
  static const List<String> fieldsOfTenantWithDetails=['Description','Name',];
  static const List<String> fieldsOfBusinessPartnerLocation=['Name',];
  static const List<String> fieldsOfPriceLists=['Name',];
  static const List<String> fieldsOfPriceListVersion=['Name',];
  static const List<String> fieldsOfTransactions=['MovementDate','M_Product_ID.identifier'];
  static const List<String> fieldsOfPOS=['Name',];
  static const List<String> fieldsOfUOM=['Name',];


  static bool getIsUserDefineValue(String value) {
    if(value ==userDefine){
      return true;
    }
    return false;
  }


}