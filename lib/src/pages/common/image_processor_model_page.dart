

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:solexpress_panel_sc/src/pages/common/controller_model.dart';

import '../../data/memory.dart';
import '../../data/messages.dart';
import '../../models/user.dart';

class ImageProcessorModelPage extends StatelessWidget {
  GetxController? con ;
  File? imageFile;

  ImageProcessorModelPage({super.key});

  User userSession =  Memory.getSavedUser();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //alignment: Alignment.topCenter,
        children: [
          _backgroundCover(context),
          _boxForm(context),
          _imageUser(context),
          _buttomBack(),

        ],
      ),
    );
  }
  Widget _backgroundCover(BuildContext context){

    return SafeArea(
      child: Container(
        //alignment: Alignment.topCenter,
        width: double.infinity,
        height: MediaQuery.of(context).size.height*0.35,
        color: Memory.PRIMARY_COLOR,

      ),
    );
  }
  Widget _boxForm(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height*0.55,
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25,
          left: 20,right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black54,
              blurRadius: 15,
              offset: Offset(0, 0.75),
            )
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _textYourInfo(),
            _buttomsingOut(context),
          ],
        ),
      ),
    );

  }
  Widget _buttomsingOut(BuildContext context){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
      child: ElevatedButton(onPressed: ()=> signOut(),
          style: ElevatedButton.styleFrom(
            backgroundColor:Memory.PRIMARY_COLOR,
            padding: EdgeInsets.symmetric(vertical: 15),
          ),
          child: Text(Messages.LOGOUT,
            style: TextStyle(color: Colors.black),
          )),
    );

  }

  Widget _textYourInfo(){
    return Container(
        margin: EdgeInsets.only(top: 40,bottom: 30),
        //child: Text('${controller.userSession.name ?? Datas.NULL_FILE} ${controller.userSession.lastname ?? Datas.NULL_FILE}',
        child: Text(Memory.USER_INFO,
          style: TextStyle(color: Colors.black),));
  }



  Widget _buttomBack(){
    return SafeArea(child: Container(
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 10, right: 20),

      child: IconButton(onPressed: ()=> signOut(),
        icon: Icon(Icons.logout,
          color: Colors.white,
          size: 30,),

      ),
    ));
  }

  Widget _imageUser(BuildContext context){

    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,
        child: GestureDetector(
          //onTap: ()=> controller.showAlertDialog(context),
            onTap: ()=> {
              showAlertDialog(context)
            },
            child: GetBuilder<ControllerModel>(
              builder: (value)=>CircleAvatar(
                backgroundImage: imageFile!=null
                    ? FileImage(imageFile!)
                    : userSession.image!=null
                    ? NetworkImage(userSession.image!)
                    : AssetImage(Memory.IMAGE_USER_PROFILE) ,
                radius: 60,
                backgroundColor: Colors.white,
              ),)
        ),

      ),
    );
  }


  selectImage(ImageSource imageSource,BuildContext context) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: imageSource);
    var format = ImageCompressFormat.jpg;
    var compressFormat = CompressFormat.jpeg;

    if(pickedFile==null){
      return;
    }
    String extension = path.extension(pickedFile.path);
    if(extension =='.png'){
      format = ImageCompressFormat.png;
      compressFormat = CompressFormat.png;

    } else if(extension =='.jpg' || extension =='.jpeg'){
      format = ImageCompressFormat.jpg;
      compressFormat = CompressFormat.jpeg;

    } else  {
      imageFile = File(pickedFile.path);
      callControllerUpdate();
      pickedFile = null;
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
      compressFormat: format,
      sourcePath: pickedFile.path,
      compressQuality: 100,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: Messages.CROPPER,
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,

          ],
        ),
        IOSUiSettings(
          title: Messages.CROPPER,
          aspectRatioPresets: [
            //CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            //CropAspectRatioPreset.ratio4x3,

          ],
        ),

        WebUiSettings(
          context: context,
          presentStyle: WebPresentStyle.dialog,
          size: CropperSize(
            width: Memory.CROPPED_IMAGE_WINDOWS_WIDTH,
            height: Memory.CROPPED_IMAGE_WINDOWS_HEIGT,
          ),
        ),


      ],
    );
    if (croppedFile != null) {
      File? image = File(croppedFile.path);

      final filePath = image.absolute.path;
      String basename = path.basename(filePath);
      String base = path.dirname(filePath);

      final outPath = "$base/out_$basename";
      XFile? result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        outPath,
        minWidth: Memory.COMPRESSED_ICON_IMAGE_WIDTH,
        minHeight: Memory.COMPRESSED_ICON_IMAGE_HEIGT,
        quality: 100,
        rotate: 0,
        format: compressFormat,
      );

      if(result==null) {
        return;
      }

      imageFile = File(result.path);
      callControllerUpdate();
    }

  }

  showAlertDialog(BuildContext context) async{
    Widget galleryButton = ElevatedButton(
        onPressed: () async {
          Get.back();
          selectImage(ImageSource.gallery,context);

        },
        child: Text(
          Messages.GALERIA,
          style: TextStyle(
              color: Colors.black
          ),
        )
    );
    Widget cameraButton = ElevatedButton(
        onPressed: () async {
          Get.back();
          selectImage(ImageSource.camera,context);
        },
        child: Text(
          Messages.CAMARA,
          style: TextStyle(
              color: Colors.black
          ),
        )
    );

    AlertDialog alertDialog = AlertDialog(
      title: Text(Messages.SELECT_AN_OPTION,
        style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold
        ) ,),
      actions: [
        galleryButton,
        cameraButton
      ],

    );

    showDialog(context: context, builder: (BuildContext context) {
      return alertDialog;
    });
  }
  void signOut() {


    Get.offNamedUntil(Memory.ROUTE_LOGIN_PAGE, (route) => false);
    // ELIMINAR EL HISTORIAL DE PANTALLAS
  }
  setGetxController(GetxController controller){
    con = controller;
  }
  void setImgageFile(File file){
    imageFile = file;
  }
  void callControllerUpdate(){
    if(con ==null){
      Get.snackbar(Messages.ERROR, Messages.PLEASE_SET_CONTROLLER_CALL_SETCONTROLLER_FUNTION);
    } else {
      con!.update();
    }
  }
}
