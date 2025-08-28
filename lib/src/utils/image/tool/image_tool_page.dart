import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../data/memory.dart';
import '../../../data/messages.dart';
import 'image_tool_controller.dart';


class ImageToolPage extends StatefulWidget {
  final String title;
  bool toCropImage = true;
  ImageToolController controller = Get.put(ImageToolController());
  ImageToolPage({
    super.key,
    required this.title,
  });

  @override
  _ImageToolPageState createState() => _ImageToolPageState();

}

class _ImageToolPageState extends State<ImageToolPage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile ;
  RxString finalImage = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
          automaticallyImplyLeading: true,
      ) ,

      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                  child: Text(
                    widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Theme.of(context).highlightColor),
                  ),
                ),
              Expanded(child: _body()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            _clear();
          },
          tooltip: Messages.DELETE,
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,),

        if (_pickedFile != null)
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: IconButton(
            onPressed: () {
              _saveImage();
            },
            tooltip: Messages.SAVE,
            icon: const Icon(Icons.save),
          ),
        ),

        if (_croppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: IconButton(
              onPressed: () {
                _cropImage();
              },
              tooltip: Messages.CROP,
              icon: const Icon(Icons.crop),
              color: Colors.greenAccent,
            ),
          ),

      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 400.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withValues(alpha:0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            Messages.UPLOAD_AN_IMAGE_TO_START,
                            style: kIsWeb
                                ? Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                color:
                                Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadImage();
                  },
                  style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.white),
                  child: Text(Messages.GALERIA),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 40),
                child: ElevatedButton(
                  onPressed: () {
                    _uploadFromCamera();
                  },
                  style:
                  ElevatedButton.styleFrom(foregroundColor: Colors.white),
                  child: Text(Messages.CAMARA),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    var format = ImageCompressFormat.jpg;
    var compressFormat = CompressFormat.jpeg;

    if(_pickedFile==null){
      Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_NO_IMAGE_SELECTED);
      return;
    }
    String extension = path.extension(_pickedFile!.path);
    if(extension =='.png'){
      format = ImageCompressFormat.png;
      compressFormat = CompressFormat.png;

    } else if(extension =='.jpg' || extension =='.jpeg'){
      format = ImageCompressFormat.jpg;
      compressFormat = CompressFormat.jpeg;

    } else  {
      Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_IMAGE_ONLY_JPG_OR_PNG);
      return;
    }


    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: format,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: Messages.CROPPER,
            toolbarColor: Colors.lightGreen,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPresetCustom(),
            ],
          ),
          IOSUiSettings(
            title: Messages.CROPPER,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
              //CropAspectRatioPresetCustom(),
            ],
          ),
          WebUiSettings(
            context: context,
            presentStyle: WebPresentStyle.dialog,
            size: const CropperSize(
              width: 520,
              height: 520,
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
          Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_PROCESSING_IMAGE);
          Get.back(result:null);
        }

        setState(() {
          _croppedFile = croppedFile;

          Get.back(result:File(result!.path));

        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }
  Future<void> _uploadFromCamera() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
    Get.back(result:null);
  }
  Future<void> _saveImage() async {

    if(_croppedFile==null && _pickedFile==null){
      Get.snackbar(Messages.ERROR, Messages.ERROR_IMAGE);
      return;
    }
    if(_pickedFile!=null){
      var compressFormat = CompressFormat.jpeg;

      if(_pickedFile==null){
        Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_NO_IMAGE_SELECTED);
        return;
      }

      String extension = path.extension(_pickedFile!.path);
      if(extension =='.png'){
        compressFormat = CompressFormat.png;

      } else if(extension =='.jpg' || extension =='.jpeg'){
        compressFormat = CompressFormat.jpeg;
      } else  {
        Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_IMAGE_ONLY_JPG_OR_PNG);
        return;
      }
      File? image = File(_pickedFile!.path);

      final filePath = image.absolute.path;
      String basename = path.basename(filePath);
      String base = path.dirname(filePath);
      final outPath = "$base/out_$basename";
      // print(outPath);
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
        Get.snackbar(Messages.ERROR_IMAGE, Messages.ERROR_PROCESSING_IMAGE);
        Get.back(result:null);
      }
      setState(() {
        _croppedFile = null;
        Get.back(result:File(result!.path));
      });


    }





  }

}



class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}