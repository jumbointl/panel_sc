import 'package:flutter/material.dart';
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

class ExcelViewController extends ControllerModel {
  @override
  BuildContext? context;

  Future? init(BuildContext context) {
    this.context = context;
    return null;
  }
}