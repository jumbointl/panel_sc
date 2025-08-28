import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_controller_model.dart';

import '../../data/memory.dart';
import '../../data/memory_panel_sc.dart';
import '../../data/messages.dart';

class VideoDownloadController extends IdempiereControllerModel {
  RxBool hasValidVideo = false.obs;

  final RxList<String> playlist = <String>[].obs;
  RxInt currentVideoIndex = 0.obs;
  RxBool isPlaying = false.obs;



  VideoDownloadController(){
    getPlayList();
  }

  Future<List<String>> readNetworkFileLinesAndDownload(String url) async {

    List<String> lines = [];
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        hasValidVideo.value = true;
        // File content received successfully
        final String fileContent = response.body;
        // Split the content into results
        final Iterable<String> results = LineSplitter.split(fileContent);
        for (final String line in results) {
          if(line.isNotEmpty) lines.add(line);
        }
        totalFilesToDownload.value = lines.length;
        for (int i = 0; i < lines.length; i++) {
          currentDownloadFileIndex.value = i;
          String url = lines[i];
          String aux = getFileNameFromUrl(url);
          String path = MemoryPanelSc.FILE_DOWNLOAD_PATH;
          File file = File('$path/$aux');
          print('----------------------------File: ${file.path}');
          bool exists = await file.exists();
          print('----------------------------File exists: $exists');
          if (exists) {
            lines[i] = file.path;
          } else {
            String fileName = await downloadVideo(url);
            if (fileName != '') {
              lines[i] = fileName;
            }
          }
        }
        // Delete local files not in the playlist
        await _deleteOrphanedFiles(lines);

        return lines;
      } else {
        // Handle HTTP errors (e.g., 404 Not Found)
        //throw Exception('Failed to load file from network: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Handle network or other errors
      //throw Exception('Error reading network file: $e');
      return [];
    }
  }

  Future<void> _deleteOrphanedFiles(List<String> validFilePaths) async {
    final Directory directory = Directory(MemoryPanelSc.FILE_DOWNLOAD_PATH); // Assuming videos are in the app's root directory or a specific known path
    final localFiles = directory.listSync().whereType<File>().toList();

    for (final localFile in localFiles) {
      print('File: ${localFile.path}');
      String fileName = getFileNameFromUrl(localFile.path);
      if (!validFilePaths.contains(localFile.path)) {
        print('Deleting orphaned file: ${localFile.path}');
        await localFile.delete();
      }
    }
  }


  Future<void> getPlayList()async{
    List<String> lines = await readNetworkFileLinesAndDownload(MemoryPanelSc.videoPlaylistFileUrl);
    allFilesDownloaded.value = true;
    playlist.clear();
    if (lines.isNotEmpty) {
      playlist.clear();
      playlist.addAll(lines);
      update();
    } else { // Fallback to local files if network playlist is empty or fails
      Directory directory = Directory(MemoryPanelSc.FILE_DOWNLOAD_PATH);
      if(await directory.exists()){
        List<FileSystemEntity> files = await directory.list().toList();
        if(files.isNotEmpty){
          lines.addAll(files.map((file) => file.path).toList());
          playlist.clear();
          playlist.addAll(lines);
        } else {
          String demoVideo = await downloadVideo(MemoryPanelSc.demoVideoUrl);
          if(demoVideo.isNotEmpty){
            playlist.add(demoVideo);
          } else {
            playlist.add(MemoryPanelSc.demoVideoUrl);
          }
        }

        update();

      } else {
        String demoVideo = await downloadVideo(MemoryPanelSc.demoVideoUrl);
        if(demoVideo.isNotEmpty){
          playlist.add(demoVideo);
        } else {
          playlist.add(MemoryPanelSc.demoVideoUrl);
        }


        update();
      }

    }
    playlist.sort();

    for(int i=0; i<playlist.length;i++){
      print('Video URL: ${playlist[i]}');
    }
    MemoryPanelSc.playlist = playlist;

    await Future.delayed(Duration(seconds: 1)); // Wait for 1 second
    //Get.offNamedUntil(Memory.ROUTE_IDEMPIERE_HOME_PAGE, (route) => false);
    Get.toNamed(Memory.ROUTE_IDEMPIERE_HOME_PAGE);
  }

}

class VideoDownloadScreen extends StatelessWidget {
  const VideoDownloadScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoDownloadController>(
      init: VideoDownloadController(),
      builder: (controller) => Scaffold(
      //appBar: AppBar(title: Text('Video Playlist')),
      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(left: 20, top: 20,bottom: 20,right: 10),
        child: Obx(() {

          if (controller.downloadingFile.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${Messages.DOWNLOADING}:(${controller.currentDownloadFileIndex.value+1}/${controller.totalFilesToDownload.value})'
                      ' ${controller.downloadUrl.value}',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                LinearProgressIndicator(minHeight: 40,color: Colors.yellow,),
              ],
            );
          }
          String text ='';
          if (!controller.hasValidVideo.value) {
            text =Messages.NO_VALID_VIDEO ;
            if(controller.playlist.isNotEmpty){
              text = '${Messages.VIDEOS_TO_PAY} ${controller.playlist.length}';
            }

          } else {
            text =Messages.VIDEO_PLAYLIST_LOADED;
            if(controller.playlist.isNotEmpty){
              text = '${Messages.VIDEOS_TO_PAY} ${controller.playlist.length}';
            }
          }
          return Text(
            text,
            style: TextStyle(fontSize: 40, color: Colors.white),
          );
        }),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.videoPlayerController.value.isPlaying
              ? controller.videoPlayerController.pause()
              : controller.videoPlayerController.play();
          controller._playNextVideo();
        },
        child: Obx(() => Icon(
          controller.isPlaying.value ? Icons.queue_play_next : Icons.play_arrow,
        ),
        ),
      ),*/
    ));
  }
}