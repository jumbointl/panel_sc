import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solexpress_panel_sc/src/data/memory.dart';

import '../data/messages.dart';

toBytes(String path, int targetWidth, {required isLocal}) async {

  Uint8List bytes;
  if (isLocal) {
    final ByteData data = await rootBundle.load(path);
    bytes = data.buffer.asUint8List();
  } else {
    final file = await DefaultCacheManager().getSingleFile(path);
    bytes = await file.readAsBytes();
  }
  final codec = await instantiateImageCodec(bytes, targetWidth: targetWidth);
  final frameInfo = await codec.getNextFrame();
  final image = await frameInfo.image.toByteData(format: ImageByteFormat.png);

  final bitmap = BitmapDescriptor.fromBytes(image!.buffer.asUint8List());
  final icon = Completer<BitmapDescriptor>();
  icon.complete(bitmap);

  return await icon.future;
}

Future<io.File?> cropImageAndResize(File pickedFile, BuildContext context, int targetWidth, int targetHeight) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
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
            width: targetWidth,
            height: targetHeight,
          ),
        ),
      ],
    );
    if (croppedFile != null) {
      pickedFile = File(croppedFile.path);

      io.File? resizedFile = await resizeImageDefault(pickedFile);

      return resizedFile ;

    } else {
      return null;
    }

}

Future<String> uploadFile(
    io.File file, String folder, String name, int targetWidth, BuildContext context) async {
  firebase_storage.Reference storageReference =
      firebase_storage.FirebaseStorage.instance.ref(folder).child(name);

  try {
    // It is image
    if (file.path.endsWith('png') || file.path.endsWith('jpg')) {

      int croppedWidth =targetWidth;
      int croppedHeight =targetWidth;


      File? croppedFile =
          await cropImageAndResize(file,context,croppedWidth, croppedHeight);

      if(croppedFile==null) {
        return '';
      }

      io.File? compressedFile = await compressFile(croppedFile);
      if(compressedFile==null) {
        return '';
      }

      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(compressedFile);
      await uploadTask.whenComplete(() => null);
    }
    // other file type
    else {
      final firebase_storage.UploadTask uploadTask =
          storageReference.putFile(file);
      await uploadTask.whenComplete(() => null);
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
    return '';
  }

  final String url = await storageReference.getDownloadURL();
  return '${url.split('?alt=media&token=')[0]}?alt=media';
}


Future<File?> goToCropImage(io.File file, BuildContext context) async {

    // It is image
    if (file.path.endsWith('png') || file.path.endsWith('jpg')) {
      return null;}
    try {
      int croppedWidth =Memory.CROPPED_IMAGE_WINDOWS_WIDTH;
      int croppedHeight =Memory.COMPRESSED_ICON_IMAGE_HEIGT;
      File? croppedFile =
      await cropImageAndResize(file,context,croppedWidth, croppedHeight);
      if(croppedFile==null) {
        return null;
      }
      io.File? compressedFile = await resizeImageDefault(croppedFile);
      return compressedFile ;


  } catch (e) {
    if (kDebugMode) {
      print(e);
      return null;
    }
    return null;
  }

}


Future<File?> compressFile(File file) async {
  final filePath = file.absolute.path;
  int len = await file.length();
  int quality = 100;

  if(len>2500000){
    quality = 5;
  } else if(len>1250000){
    quality = 10;
  } else if(len>600000){
    quality = 30;
  } else if(len>200000){
    quality = 60;
  }  else {
    return file;
  }

  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, outPath,
    quality: quality ,
  );

  print(file.lengthSync());

  if(result==null) {
    return null;
  }

  return File(result.path);
}
Future<File?> resizeImageDefault(File file) async {
  final filePath = file.absolute.path;

  // Create output file path
  // eg:- "Volume/VM/abcd_out.jpeg"
  final lastIndex = filePath.lastIndexOf(RegExp(r'.jp'));
  final splitted = filePath.substring(0, (lastIndex));
  final outPath = "${splitted}_out${filePath.substring(lastIndex)}";
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    outPath,
    minWidth: Memory.COMPRESSED_ICON_IMAGE_WIDTH,
    minHeight: Memory.COMPRESSED_ICON_IMAGE_HEIGT,
    quality: 100,
    rotate: 0,

  );

  print(file.lengthSync());

  if(result==null) {
    return null;
  }

  return File(result.path);
}
Future<File?> resizeImage(File file, String targetPath, int targetWidth, int targetHeight) async {
  XFile? result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    minWidth: targetWidth,
    minHeight: targetHeight,
    quality: 100,
    rotate: 0,
  );
  print(file.lengthSync());
  if(result!=null){
    File f = File(result.path);
    print(f.lengthSync());
    return f;

  } else {
    print(Memory.NULL_FILE);
    return null;
  }


}