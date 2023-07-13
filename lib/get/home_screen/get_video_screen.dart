import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoScreenController extends GetxController {
final controller = VideoPlayerController.asset("assets/videos/video.mp4")
    ..initialize();
  RxBool isVideoPlaying = true.obs;

  void showPlayPauseIcon() {
    if (isVideoPlaying.value) {
      controller.pause();
    } else {
      controller.play();
      controller.setLooping(true);
    }
    isVideoPlaying.value = controller.value.isPlaying;
  }


  playVideo() {
    controller.play();
    controller.setLooping(true);
  }
}
