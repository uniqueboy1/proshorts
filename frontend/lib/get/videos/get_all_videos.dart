import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/video.dart';

class AllVideosController extends GetxController {
  RxList allVideos = [].obs;
  VideoMethods videoMethods = VideoMethods();

  Future<void> fetchAllVideos() async {
    allVideos.value = await videoMethods.fetchAllVideos();
  }
}
