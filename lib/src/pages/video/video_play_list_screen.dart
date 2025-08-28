import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:solexpress_panel_sc/src/idempiere/common/idempiere_controller_model.dart';
import 'package:solexpress_panel_sc/src/pages/panel_sc_home/panel_sc_home_controller.dart';
import 'package:video_player/video_player.dart';

import '../../data/memory_panel_sc.dart';
import '../../data/messages.dart';

class VideoPlaylistController extends IdempiereControllerModel {
  late VideoPlayerController videoPlayerController;
  PanelScHomeController panelScHomeController = Get.find<PanelScHomeController>();
  RxBool hasValidVideo = false.obs;

  //final RxList<String> playlist = <String>[].obs;
  final RxList<String> playlist = MemoryPanelSc.playlist;
  RxInt currentVideoIndex = 0.obs;
  RxBool isPlaying = false.obs;



  VideoPlaylistController(){
    //getPlayList();
    _initializeVideoPlayer(playlist[currentVideoIndex.value]);
  }

  @override
  void dispose() {
    stopVideoPlayer();
    super.dispose();
  }

  Future<void> stopVideoPlayer() async {
    if (videoPlayerController.value.isInitialized) {
      await videoPlayerController.dispose();
    }
  }
  /*Future<List<String>> readNetworkFileLinesAndDownload(String url) async {

    List<String> lines = [];
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // File content received successfully
        hasValidVideo.value = true;
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
        allFilesDownloaded.value = true;
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
*/

  /*Future<void> getPlayList()async{
    List<String> lines = await readNetworkFileLinesAndDownload(MemoryPanelSc.videoPlaylistFileUrl);
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
    _initializeVideoPlayer(playlist[currentVideoIndex.value]);

  }*/

  void _initializeVideoPlayer(String videoUrl) {

    try {
      print('Video URL: $videoUrl');
      if (videoUrl.startsWith('http')) {
        videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(videoUrl),
        );
      } else {
        videoPlayerController = VideoPlayerController.file(
          File(videoUrl),
        );
      }
      videoPlayerController.initialize().then((_) {
          update(); // Ensure the player is rebuilt after initialization
          videoPlayerController.play();
          isPlaying.value = true;
          hasValidVideo.value = true;
        }).catchError((error) {
          print("Error initializing video player: $error");
          _playNextVideo(); // Try to play the next video if current one fails
        });

      videoPlayerController.addListener(() {
        if (videoPlayerController.value.hasError) {
          print("Error during video playback: ${videoPlayerController.value.errorDescription}");

          _playNextVideo(); // Try to play the next video if current one has an error
        }
      if (videoPlayerController.value.position == videoPlayerController.value.duration &&
          !videoPlayerController.value.isBuffering &&
          videoPlayerController.value.isInitialized) {
        _playNextVideo();
      }
      isPlaying.value = videoPlayerController.value.isPlaying;
    });

    } catch (e) {
      print("Error setting up video player: $e");
      _playNextVideo(); // Try to play the next video if setup fails

    }
  }

  void _playNextVideo() {
    currentVideoIndex.value++;
    if (currentVideoIndex.value >= playlist.length) {
      if(hasValidVideo.value){
        currentVideoIndex.value = 0; // Loop back to the beginning
      } else {
        // hasValidVideo.value = false; // Ensure this is explicitly set
        videoPlayerController.pause(); // Stop playing if no valid video
        update(); // Update UI to reflect no valid video
        return;
      }

    }
    videoPlayerController.dispose(); // Dispose the old controller
    _initializeVideoPlayer(playlist[currentVideoIndex.value]); // Initialize new controller
    update();
  }


  @override
  void onClose() {
    stopVideoPlayer();
    super.onClose();
  }
}

class VideoPlaylistScreen extends StatelessWidget {
  const VideoPlaylistScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<VideoPlaylistController>(
      init: VideoPlaylistController(),
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
          if (!controller.hasValidVideo.value) {
            String text =Messages.NO_VALID_VIDEO ;
            if(controller.playlist.isNotEmpty){
              text = '${Messages.VIDEOS_TO_PAY} ${controller.playlist.length}';
            }
            return Text(
              text,
              style: TextStyle(fontSize: 40, color: Colors.white),
            );
          }

          return controller.videoPlayerController.value.isInitialized
              ? AspectRatio(
            aspectRatio: controller.videoPlayerController.value.aspectRatio,
            child: VideoPlayer(controller.videoPlayerController),
          )
              : CircularProgressIndicator();
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