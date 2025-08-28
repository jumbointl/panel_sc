import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_filter_create_page_model.dart';

import '../../../../../data/messages.dart';
import 'idempiere_business_partners_locations_home_controller.dart';

class IdempiereBusinessPartnerLocationsHomePage extends IdempiereFilterCreatePageModel{
  final IdempiereBusinessPartnerLocationsHomeController controller = Get.put(IdempiereBusinessPartnerLocationsHomeController());
  Color hoverColor = Colors.amber[200]!;
  IdempiereBusinessPartnerLocationsHomePage({super.key}){
    idempiereFilters = controller.idempiereFilters;
    valueControllers = controller.valueControllers;
    operators = controller.operators;
    fields = controller.fields;
    values = controller.values;
    images = controller.images;
    conjunctions = controller.conjunctions;
    bottomNavigationBarColor = controller.bottomNavigationBarColor;
    isLoading = controller.isLoading;
    showInputText = controller.showInputText;
    field = controller.field;
    operator = controller.operator;
    value = controller.value;
    conjunction = controller.conjunction;
    title = controller.title ?? Messages.EMPTY;

  }
  @override
  void findByCondition(BuildContext context) {
    // TODO: implement findByCondition
    controller.findByCondition(context);
  }


}

