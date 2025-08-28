
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../utils/image/tool/image_tool_page.dart';
import './register_controller.dart';

import '../../data/memory.dart';
import '../../data/messages.dart';

class RegisterPage extends StatelessWidget {
  RegisterController controller = Get.put(RegisterController());
  Container? cEmail ;

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: _title(),
        ),
        body: SafeArea(
          child: context.isPortrait ? _boxForm(context) : _boxFormLandscape(context),
        ));
  }
  Widget _boxFormLandscape(BuildContext context){
    double marginsHorizontal = (context.width-controller.getMaximumInputFieldWidth(context)-200)/2-10;
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      height: context.isPortrait ? context.height*0.6 : context.height*0.8,
      width: controller.getMaximumInputFieldWidth(context)+200,
      margin: EdgeInsets.only(top: 20,
          left: marginsHorizontal, right: marginsHorizontal),

      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 10,
          children: [

            SizedBox(
              width: controller.getMaximumInputFieldWidth(context)-150,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _textFieldEmail(),
                  _textFieldName(),
                  _textFieldLastName(),
                  _textFieldPhone(),
                  _textFieldPassword(),
                  _textFieldRetypePassword(),

                ],
              ),

            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              spacing: 155,
              children: [
                _imageUser(context),
                _bottomRegister(context),
              ],
            ),

          ],
        ),
      ),
    );

  }
  Widget _boxForm(BuildContext context){
    return Container(
      alignment: Alignment.center,
      height: 500,
      width: controller.getMaximumInputFieldWidth(context),
      margin: EdgeInsets.only(top: 20,
          left: 20,right: 20),

      child: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            _imageUser(context),
            SizedBox(height: 10,),
            _textFieldEmail(),
            _textFieldName(),
            _textFieldLastName(),
            _textFieldPhone(),
            _textFieldPassword(),
            _textFieldRetypePassword(),
            SizedBox(height: 10,),
            _bottomRegister(context),
          ],
        ),
      ),
    );

  }
  Widget _bottomRegister(BuildContext context){
    return IconButton(
        icon: controller.isLoading.value
            ? CircularProgressIndicator(color: Colors.redAccent)
            : Text(Messages.REGISTER),
        onPressed: () => controller.isLoading.value ? null : controller.register(context),
        tooltip: controller.isLoading.value ? Messages.LOADING
            : Messages.REGISTER,
        style: IconButton.styleFrom(
          backgroundColor: controller.isLoading.value
              ? Memory.PRIMARY_COLOR
              : Memory.BAR_BACKGROUND_COLOR,
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
        ),
    );

  }
  Widget _textFieldEmail(){

    return TextField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: Messages.EMAIL,
          prefixIcon: Icon(Icons.email),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _textFieldName(){
    return  TextField(
        controller: controller.nameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.NAME,
          prefixIcon: Icon(Icons.person),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _textFieldLastName(){
    return TextField(
        controller: controller.lastNameController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.LAST_NAME,
          prefixIcon: Icon(Icons.person_outlined),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _textFieldPhone(){
    return TextField(
        controller: controller.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: Messages.PHONE,
          prefixIcon: Icon(Icons.phone),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _textFieldPassword(){
    return TextField(
        controller: controller.passwordController,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.PASSWORD,
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _textFieldRetypePassword(){
    return TextField(
        controller: controller.confirmPasswordController,
        obscureText: true,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: Messages.RETYPE_PASSWORD,
          prefixIcon: Icon(Icons.lock),
          border: OutlineInputBorder(),
        ),
    );
  }
  Widget _title(){
    return  Text(Messages.TEXT_YOUR_INFO,
          style: TextStyle(color: Colors.black),);
  }
  Widget _imageUser(BuildContext context){
    return Container(
        margin: EdgeInsets.only(top: 30),
        alignment: Alignment.topCenter,

        child: GestureDetector(
            onTap: () async {
              // controller.goToImageToolPage();
              //onTap: ()=> showAlertDialog(context),
              controller.imageFile = await Get.to(ImageToolPage(title: Messages.IMAGE_TOOL,));
              if(controller.imageFile!=null){
                controller.update();
              }
            },
          child: GetBuilder<RegisterController>(
              builder: (value)=>CircleAvatar(
                backgroundImage: controller.imageFile!=null ? FileImage(controller.imageFile!):  AssetImage(Memory.IMAGE_USER_PROFILE) ,
                radius: 70,
                backgroundColor: Colors.amber[200],
              ),)
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
      controller.imageFile = File(pickedFile.path);
      controller.update();
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
      print('Compress $compressFormat');

      final outPath = "$base/out_$basename";
      print(outPath);
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

      controller.imageFile = File(result.path);
      controller.update();
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
}
