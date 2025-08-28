import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_organization.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_rol.dart';
import 'package:solexpress_panel_sc/src/models/idempiere/idempiere_warehouse.dart';
import '../../../data/memory.dart';
import '../../../models/host.dart';
import '../../../models/idempiere/idempiere_tenant.dart';
import 'idempiere_roles_controller.dart';
import '../../../data/messages.dart';

class IdempiereRolesPage extends StatelessWidget {

  IdempiereRolesController con = Get.put(IdempiereRolesController());
  Color selectedColor = Colors.amber[200]!;

  IdempiereRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    double fileHeight = MediaQuery.of(context).size.height/8;
    Host host = GetStorage().read(Memory.KEY_HOST) ?? Host();
    Color color = Colors.white;
    if(host.id!=null){
      switch(host.id){
        case(1):
            color = Colors.amber[200]!;
            break;
          case(2):
            color = Colors.purple[200]!;
            break;
          case(3):
            color = Colors.pink[200]!;
            break;
          default:
            color = Colors.white;
            break;


      }

    }


    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [

          con.buttonUser(),
          con.buttonSignOut()
          ],

        title: Text(
            Messages.LOGIN,
            style: TextStyle(
                color: Colors.black

            ),
          ),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 14),

          child: Container(
             alignment:  Alignment.center,
              width: double.infinity,
              color: color,
              child: Text(host.name ?? '')),
        ),

      ),
      body: Obx(()=>Column(
        spacing: 7,
        children: [
          SizedBox(height: 7,),
          Text(Messages.CLIENT),
          _dropDownIdempiereTenants(),
          Text(Messages.ROL),
          if(con.roles.isNotEmpty) _dropDownIdempiereRoles(context),
          if(con.showMoreData.value) Text(Messages.ORGANIZATION),
          if(con.showMoreData.value) _dropDownIdempiereOrganizations(),
          if(con.showMoreData.value && con.warehouses.isNotEmpty) Text(Messages.WAREHOUSE),
          if(con.showMoreData.value && con.warehouses.isNotEmpty) _dropDownIdempiereWarehouses(),
          SizedBox(height: 10,),
          if(con.isLoading.value) CircularProgressIndicator()

        ],
      ),)
      // put separator here
    );
  }
  Widget _dropDownIdempiereTenants() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_CLIENT,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsIdempiereTenants(con.clients),
        value: con.idClient.value == '' ? null : con.idClient.value,
        onChanged: (option) {
          if(option==null || option==''){
            return;
          }
          con.showMoreData.value = false;
          con.idClient.value = option.toString();
          con.getRoles(int.parse(option.toString()));
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItemsIdempiereTenants(List<IdempiereTenant> idempiereTenants) {
    List<DropdownMenuItem<String>> list = [];
    for (var idempiereTenant in idempiereTenants) {
      list.add(DropdownMenuItem(
        value: idempiereTenant.id.toString(),
        child: Text('ID: ${idempiereTenant.id ?? ''} - ${idempiereTenant.name ?? ''}'),
      ));
    }

    return list;
  }
  Widget _dropDownIdempiereRoles(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_ROL,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsIdempiereRoles(con.roles),
        value: con.idRole.value == '' ? null : con.idRole.value,
        onChanged: (option) {
          if(option==null || option==''){
            return;
          }
          con.idRole.value = option.toString();

          AwesomeDialog(
            context: context,
            animType: AnimType.scale,
            dialogType: DialogType.question,
            body: Center(child: Text(
              '${Messages.LOGIN_OR_CONTINUE_TO_FILL_DATA}? ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),),
            title: '${Messages.LOGIN}?',
            desc:   'This is also Ignored',
            btnOkOnPress: () {
              con.showMoreData.value = false ;
              con.oneStepLogin(int.parse(option.toString()));
            },
            btnCancelOnPress: () {
              con.showMoreData.value = true ;
              con.getOrganizations(int.parse(option.toString()));
            }
          ).show();





        },
      ),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItemsIdempiereRoles(List<IdempiereRol> idempiereRoles) {
    List<DropdownMenuItem<String>> list = [];
    for (var idempiereRol in idempiereRoles) {
      list.add(DropdownMenuItem(
        value: idempiereRol.id.toString(),
        child: Text('ID: ${idempiereRol.id ?? ''} - ${idempiereRol.name ?? ''}'),
      ));
    }

    return list;
  }



  Widget _dropDownIdempiereOrganizations() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_ORGANIZATION,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsIdempiereOrganizations(con.organizations),
        value: con.idOrganization.value == '' ? null : con.idOrganization.value,
        onChanged: (option) {
          if(option==null || option==''){
            return;
          }

          con.idOrganization.value = option.toString();
          con.getWarehouses(int.parse(option.toString()));
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItemsIdempiereOrganizations(List<IdempiereOrganization> idempiereOrganizations) {
    List<DropdownMenuItem<String>> list = [];
    for (var idempiereOrganization in idempiereOrganizations) {
      list.add(DropdownMenuItem(
        value: idempiereOrganization.id.toString(),
        child: Text(
            'ID: ${idempiereOrganization.id ?? ''} - ${idempiereOrganization
                .name ?? ''}'),
      ));
    }
    return list;
  }
  Widget _dropDownIdempiereWarehouses() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: DropdownButton(
        underline: Container(
          alignment: Alignment.centerRight,
        ),
        elevation: 3,
        isExpanded: true,
        hint: Text(
          Messages.SELECT_A_WAREHOUSE,

          style: TextStyle(

              fontSize: 15
          ),
        ),
        items: _dropDownItemsIdempiereWarehouses(con.warehouses),
        value: con.idWarehouse.value == '' ? null : con.idWarehouse.value,
        onChanged: (option) {
          if(option==null || option==''){
            return;
          }

          con.idWarehouse.value = option.toString();
          con.initSession(int.parse(option.toString()));
        },
      ),
    );
  }
  List<DropdownMenuItem<String>> _dropDownItemsIdempiereWarehouses(List<IdempiereWarehouse> idempiereWarehouses) {
    List<DropdownMenuItem<String>> list = [];
    for (var idempiereWarehouse in idempiereWarehouses) {
      list.add(DropdownMenuItem(
        value: idempiereWarehouse.id.toString(),
        child: Text(
            'ID: ${idempiereWarehouse.id ?? ''} - ${idempiereWarehouse
                .name ?? ''}'),
      ));
    }
    return list;
  }



}
