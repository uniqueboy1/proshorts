import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class SelectVideoController extends GetxController {
// final File videoPath;
//   SelectVideoController({
//     required this.videoPath
//   });
  // final controller = VideoPlayerController.asset("assets/videos/video.mp4")
  // ..initialize();

  RxBool isVideoPlaying = true.obs;
  VideoPlayerController? controller;

  void showPlayPauseIcon() {
    if (isVideoPlaying.value) {
      controller!.pause();
    } else {
      controller!.play();
      controller!.setLooping(true);
    }
    isVideoPlaying.value = controller!.value.isPlaying;
  }

  initializeVideo(File videoPath){
    controller = VideoPlayerController.file(videoPath);
    controller!.initialize();
  }

  playVideo() {
    controller!.play();
    controller!.setLooping(true);
  }
}
