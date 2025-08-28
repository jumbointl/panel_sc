import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/data/messages.dart';

import '../../../../data/memory.dart';
import '../../../../models/active.dart';
import '../../../../models/default_selection.dart';
import 'client_address_create_controller.dart';

class ClientAddressCreatePage extends StatelessWidget {

  ClientAddressCreateController controller = Get.put(ClientAddressCreateController());
  Color barColor = Memory.BAR_BACKGROUND_COLOR;
  Color? needToFillColor = Colors.lightGreen[200];
  Color? filledColor = Colors.white;
  ClientAddressCreatePage({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
          centerTitle: true,
          title: Text(
            controller.clientSociety.name ?? Messages.EMPTY,
            style: TextStyle(
                color: Colors.black
            ),
          ),
        ),
      body: Obx(()=>Stack( // POSICIONAR ELEMENTOS UNO ENCIMA DEL OTRO
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _textNewAddress(context),
          //_iconBack()
        ],
      ),
    ));
  }


  Widget _backgroundCover(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      color: Memory.PRIMARY_COLOR,
    );
  }

  Widget _boxForm(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, left: 20, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black54,
                blurRadius: 15,
                offset: Offset(0, 0.75)
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _textFieldId(),
            _textFieldName(),
            _textFieldAddress(),
            _textFieldNeighborhood(),
            _textFieldCity(),
            _textFieldCountry(),
            _textFieldLatLng(),
            _textFieldRefPoint(context),
            _dropDownDefaultSelection(controller.defaultSelectionList),
            _dropDownActive(controller.activeList),
            SizedBox(height: 20),
            _buttonCreate(context)
          ],
        ),
      ),
    );
  }
  Widget _textFieldId() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        readOnly: true,
        controller: controller.idController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: Messages.ID,
            prefixIcon: Icon(Icons.computer)
        ),
      ),
    );
  }
  Widget _textFieldName() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: Messages.NAME,
            prefixIcon: Icon(Icons.card_membership),
            filled: true,
            fillColor: controller.isNameEmpty ? needToFillColor: filledColor,
        ),
      ),
    );
  }


  Widget _textFieldAddress() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.addressController,
        keyboardType: TextInputType.text,
        maxLines: 3,
        decoration: InputDecoration(
            hintText: Messages.ADDRESS,
            prefixIcon: Icon(Icons.location_on),
            filled: true,
            fillColor: controller.isAddressEmpty ? needToFillColor: filledColor,
        ),
      ),
    );
  }

  Widget _textFieldNeighborhood() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.neighborhoodController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.NEIGHBORHOOD,
          prefixIcon: Icon(Icons.location_city),
          filled: true,
          fillColor: controller.isNeighborhoodEmpty ? needToFillColor: filledColor,
        ),
      ),
    );
  }
  Widget _textFieldCity() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.cityController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.CITY,
          prefixIcon: Icon(Icons.location_city),
          filled: true,
          fillColor: controller.isCityEmpty ? needToFillColor: filledColor,
        ),
      ),
    );
  }
  Widget _textFieldCountry() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.countryController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.COUNTRY,
          prefixIcon: Icon(Icons.location_city_outlined),
          filled: true,
          fillColor:controller.isCountryEmpty ? needToFillColor: filledColor,
        ),
      ),
    );
  }
  Widget _textFieldLatLng() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        controller: controller.latLngController,
        //keyboardType: TextInputType.text,
        readOnly: true,
        decoration: InputDecoration(
            hintText: Messages.COORDINATE_LATUTE_LONGITUDE,
            prefixIcon: Icon(Icons.location_city_outlined)
        ),
      ),
    );
  }
  Widget _textFieldRefPoint(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(

        onTap: () => controller.openGoogleMaps(context),
        maxLines: 3,
        maxLength: 255,
        controller: controller.refPointController,
        autofocus: false,
        focusNode: AlwaysDisabledFocusNode(),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            hintText: Messages.TAP_HERE_TO_SELECT_LOCATION_ON_THE_MAP,
            prefixIcon: Icon(Icons.map),
            fillColor:controller.isRefPointEmpty.value ? Memory.COLOR_BUTTOM_BAR: filledColor,
            filled: true,

        ),
      ),
    );
  }



  Widget _buttonCreate(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10, ),
      child: IconButton(
        icon: controller.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.CREATE_ADDRESS),
        onPressed: () => controller.isLoading.value ? null : controller.createAddress(context),
        tooltip: controller.isLoading.value ? Messages.LOADING
            : Messages.CREATE_ADDRESS,
        style: IconButton.styleFrom(
          backgroundColor: controller.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        ),
      ),
    );
  }

  Widget _textNewAddress(BuildContext context) {

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 15),
        alignment: Alignment.topCenter,
        child: Column(
          children: [


            Icon(Icons.location_on, size: 40),


            Text(
              Messages.NEW_ADDRESS,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }

  Widget _textYourInfo() {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        Messages.COMPLETE_THIS_FORM,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
  Widget _dropDownActive(List<Active>  list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: barColor,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_AN_OPTION,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownActiveItems(list),
        value: controller.isActive.value == '' ? null : controller.isActive.value ,

        onChanged: (option) {
          //print('Opcion seleccionada ${option}');
          controller.isActive.value = option.toString() ;
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownActiveItems(List<Active> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(

        value: data.active.toString(),

        child: Text(data.name ?? ''),

      ));
    }

    return list;
  }
  Widget _dropDownDefaultSelection(List<DefaultSelection>  list) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      margin: EdgeInsets.only(top: 15),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_drop_down_circle,
            color: barColor,
          ),
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_AN_OPTION,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownDefaultSelectionItems(list),
        value: controller.isDefaultSelection.value == '' ? null : controller.isDefaultSelection.value ,

        onChanged: (option) {
          //print('Opcion seleccionada ${option}');
          controller.isDefaultSelection.value = option.toString() ;
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownDefaultSelectionItems(List<DefaultSelection> data) {
    List<DropdownMenuItem<String>> list = [];
    for (var data in data) {
      list.add(DropdownMenuItem(

        value: data.defaultSelection.toString(),

        child: Text(data.name ?? ''),

      ));
    }

    return list;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
