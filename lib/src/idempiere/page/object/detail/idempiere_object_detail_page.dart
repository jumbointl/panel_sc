
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_object_detail_page_model.dart';

import 'idempiere_object_detail_controllerl.dart';


class IdempiereObjectDetailPage extends IdempiereObjectDetailPageModel{
  IdempiereObjectDetailController controller = Get.put(IdempiereObjectDetailController());
  IdempiereObjectDetailPage({super.key,super.idempiereObject});

}