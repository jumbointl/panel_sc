import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../../../data/memory.dart';
import '../../../../data/messages.dart';
import '../../../../models/active.dart';
import '../../../../models/address.dart';
import '../../../../models/default_selection.dart';
import '../../../../models/response_api.dart';
import '../../../../models/society.dart';
import '../../../../models/user.dart';
import '../../../../providers/addresses_provider.dart';
import '../../../common/active_dropdown.dart';
import '../../../common/default_selection_dropdown.dart';
import '../list/client_address_list_controller.dart';
import '../map/client_address_map_page.dart';

class ClientAddressCreateController extends ControllerModel {

  TextEditingController addressController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController refPointController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController latLngController = TextEditingController();
  List<Active> activeList = ActiveDropdown.activeList.obs;
  RxString isActive = '1'.obs;

  List<DefaultSelection> defaultSelectionList = DefaultSelectionDropdown.list.obs;
  RxString isDefaultSelection = '1'.obs;


  double latRefPoint = 0;
  double lngRefPoint = 0;

  User user =  Memory.getSavedUser();

  AddressesProvider addressProvider = AddressesProvider();

  ClientAddressListController clientAddressListController = Get.find();
  bool isNameEmpty = false;
  bool isCountryEmpty = true;
  bool isCityEmpty = true;
  bool isAddressEmpty = true;
  bool isNeighborhoodEmpty = true;
  RxBool isRefPointEmpty = true.obs;
  late Society clientSociety;
  ClientAddressCreateController(){
    clientSociety = getSavedClientSociety();
  }

  void openGoogleMaps(BuildContext context) async {
    Map<String, dynamic> refPointMap = await showMaterialModalBottomSheet(
        context: context,
        builder: (context) => ClientAddressMapPage(),
        isDismissible: false,
        enableDrag: false
    );

    print('${Messages.POINT_OF_REFERENCE} $refPointMap');
    cityController.text = refPointMap['city'];
    countryController.text = refPointMap['country'];
    addressController.text = refPointMap[Memory.KEY_ADDRESS];
    neighborhoodController.text = refPointMap['neighborhood'];
    refPointController.text = refPointMap[Memory.KEY_ADDRESS];
    latRefPoint = refPointMap['lat'];
    lngRefPoint = refPointMap['lng'];
    latLngController.text ='$latRefPoint,$lngRefPoint';
    if(nameController.text.isEmpty){
      isNameEmpty = true;
    } else {
      isNameEmpty = false;
    }

    if(cityController.text.isEmpty){
      isCityEmpty = true;
    } else {
      isCityEmpty = false;
    }
    if(countryController.text.isEmpty){
      isCountryEmpty = true;
    } else {
      isCountryEmpty = false;
    }
    if(addressController.text.isEmpty){
      isAddressEmpty = true;
    } else {
      isAddressEmpty = false;
    }
    if(neighborhoodController.text.isEmpty){
      isNeighborhoodEmpty = true;
    } else {
      isNeighborhoodEmpty = false;
    }
    if(refPointController.text.isEmpty){
      isRefPointEmpty.value= true;
    } else {
      isRefPointEmpty.value = false;
    }
    update();
  }

  void createAddress(BuildContext context) async {
    String addressName = addressController.text;
    String neighborhood = neighborhoodController.text;
    String name = nameController.text;
    String city = cityController.text;
    String country = countryController.text;
    int? d = int.tryParse(isDefaultSelection.toString());
    int? a = int.tryParse(isActive.toString());
    if(d==null){
      Get.snackbar(Messages.ERROR, Messages.DEFAULT_SELECTION);
      return;
    }
    if(a==null){
      Get.snackbar(Messages.ERROR, Messages.ACTIVE);
      return;
    }

    if (isValidForm(addressName, neighborhood,name,city,country)) {
      if(clientSociety.id==null){
        showErrorMessages(Messages.SOCIETY);
        return;
      }
      Address address = Address(
        address: addressName,
        neighborhood: neighborhood,
        name: name,
        city: city,
        country: country,
        lat: latRefPoint,
        lng: lngRefPoint,
        idUser: user.id,
        idSociety: clientSociety.id,
        defaultSelection: d,
        active:a,

      );
      isLoading.value = true;

      ResponseApi responseApi = await addressProvider.create(context, address);
      isLoading.value = false;

      if (responseApi.success == true) {
        Address a = Address.fromJson(responseApi.data);
        address.id = a.id;
        saveAddress(address);

        idController.text = address.id.toString();
        clientAddressListController.update();

        Get.back();
        //showSuccessMessages(responseApi.message ?? '');
      }

    }
  }

  bool isValidForm(String address, String neighborhood, String name, String city, String country) {
    if (address.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.ADDRESS);
      return false;
    }
    if (neighborhood.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.NEIGHBORHOOD);
      return false;
    }
    if (name.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.NAME);
      return false;
    }
    if (city.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.CITY);
      return false;
    }
    if (country.isEmpty){
      Get.snackbar(Messages.ERROR, Messages.COUNTRY);
      return false;
    }
    if (latRefPoint == 0){
      Get.snackbar(Messages.ERROR, Messages.POINT_OF_REFERENCE);
      return false;
    }
    if (lngRefPoint == 0){
      Get.snackbar(Messages.ERROR, Messages.POINT_OF_REFERENCE);
      return false;
    }

    return true;
  }

}