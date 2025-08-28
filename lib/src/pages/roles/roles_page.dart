import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/memory.dart';
import '../../models/host.dart';
import 'roles_controller.dart';
import '../../data/messages.dart';
import '../../models/rol.dart';

class RolesPage extends StatelessWidget {

  RolesController con = Get.put(RolesController());

  RolesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
          con.buttonExcel(),
          con.buttonWeb(),
          con.buttonUser(),
          con.buttonSignOut()
          ],

        title: Text(
            Messages.ROL,
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
      body: Container(
        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.05),
        child: ListView(
          children: con.user.roles != null ? con.user.roles!.map((Rol rol) {return _cardRol(rol);}).toList() : [],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    //int rolId = rol.id! ;
    //rol = Memory.ROLES_LIST[rolId-1];

    return GestureDetector(
      onTap: () => con.goToPageRol(rol),
      child: Column(
        children: [
          Container( // IMAGEN
            margin: EdgeInsets.only(bottom: 10, top: 10),
            height: 100,
            child: FadeInImage(
              //image: NetworkImage(rol.image!),
              image:AssetImage(rol.image!),
              fit: BoxFit.contain,
              fadeInDuration: Duration(milliseconds: 50),
              placeholder: AssetImage(Memory.IMAGE_NO_IMAGE),
            ),
          ),
          Text(
            rol.name ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
