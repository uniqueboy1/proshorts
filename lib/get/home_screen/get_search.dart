import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  RxBool isTopVideos = true.obs;
  RxBool isInputChanged = false.obs;
  void topVideos() {
    if (!isTopVideos.value) {
      isTopVideos.value = true;
    }
  }

  void topUsers() {
    if (isTopVideos.value) {
      isTopVideos.value = false;
    }
  }

  void showCancelIcon(String input) {
    if (input.isNotEmpty) {
      isInputChanged.value = true;
    } else {
      isInputChanged.value = false;
    }
  }

}
