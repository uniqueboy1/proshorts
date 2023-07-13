import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? video;
  bool isPlaying = false;
  Icon icon = Icon(Icons.pause);
  VideoPlayerController? controller;

  void pickVideo() async{
    ImagePicker videoPicker = ImagePicker();
    XFile? selectedVideo = await videoPicker.pickVideo(source: ImageSource.camera, maxDuration: Duration(minutes: 1));
    if(selectedVideo != null){
      video = File(selectedVideo.path);
      controller = VideoPlayerController.file(video!);
      await controller!.initialize();
      await controller!.play();
      setState(() {
        isPlaying = true;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            (video != null) ? AspectRatio(
              aspectRatio: controller!.value.aspectRatio,
              child: VideoPlayer(controller!),
              ) : Container(),
            ElevatedButton(onPressed: () {
              pickVideo();
            }, child: Text("Select Video From Camera")),
            (video != null) ? IconButton(onPressed: () async{
              if(isPlaying){
                isPlaying = false;
                await controller!.pause();
                icon = Icon(Icons.play_arrow);
              }
              else{
                isPlaying = true;
                await controller!.play();
                icon = Icon(Icons.pause);
      
              }
              setState(() {
                
              });
            }, icon: icon) : Text("")
          ],
        ),
      )
    );
  }
}