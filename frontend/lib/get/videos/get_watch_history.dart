import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/video.dart';

class WatchHistoryController extends GetxController {
  RxInt noOfWatchHistory = 0.obs;

  void deleteWatchHistory(int watchHistory){
    noOfWatchHistory.value  = watchHistory;
  }
}
