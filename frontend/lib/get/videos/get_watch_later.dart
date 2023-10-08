import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';

class WatchLaterController extends GetxController {
  /* start : fetching video  */
  RxList watchLater = [].obs;
  Future fetchWatchLater() async {
    watchLater.value = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE['_id'], "watchLater");
  }

  Future deleteWatchLater() async {
    // removing selected videos from watchLater and assigning remaining videos to watchLater
    watchLater.value = watchLater.where((item) {
      return (!selectedVideos.contains(item["videoInformation"]["_id"]));
    }).toList();

    await UserMethods().editUser(MYPROFILE['_id'], {"watchLater": watchLater});
  }

  /* end : fetching video  */

  /* start : working on select and select all features */

  RxString select = "Select".obs;
  RxBool isSelectClicked = false.obs;
  RxBool isSelectAllClicked = false.obs;
  RxString selectAll = "Select All".obs;
  IconData checkedIcon = FontAwesomeIcons.solidCircleCheck;
  IconData noCheckedIcon = Icons.circle_outlined;
  RxList selectedVideos = [].obs;

  void changeSelect() {
    isSelectClicked.value = !isSelectClicked.value;
    isSelectAllClicked.value = false;
    selectedVideos.value = [];
    if (isSelectClicked.value) {
      select.value = "Cancel";
    } else {
      select.value = "Select";
    }
    selectAll.value = "Select All";
  }

  void changeSelectAll() {
    isSelectAllClicked.value = !isSelectAllClicked.value;
    isSelectClicked.value = false;
    selectedVideos.value = [];
    if (isSelectAllClicked.value) {
      for (var i = 0; i < watchLater.length; i++) {
        selectedVideos.add(watchLater[i]['videoInformation']['_id']);
      }
      selectAll.value = "Deselect All";
    } else {
      selectAll.value = "Select All";
    }

    select.value = "Select";
  }

  void changeIcon(Map<String, dynamic> video) {
    if (isSelectAllClicked.value) {
      // if already selected remove it from selected videos
      if (selectedVideos.contains(video['videoInformation']['_id'])) {
        selectedVideos.remove(video['videoInformation']['_id']);
      } else {
        selectedVideos.add(video['videoInformation']['_id']);
      }
    } else if (isSelectClicked.value) {
      if (selectedVideos.contains(video['videoInformation']['_id'])) {
        selectedVideos.remove(video['videoInformation']['_id']);
      } else {
        selectedVideos.add(video['videoInformation']['_id']);
      }
    }
    print("selected videos : $selectedVideos");
  }

  /* end : working on select and select all features */

  void reset() {
    select.value = "Select";
    isSelectClicked.value = false;
    isSelectAllClicked.value = false;
    selectAll.value = "Select All";
    checkedIcon = FontAwesomeIcons.solidCircleCheck;
    noCheckedIcon = Icons.circle_outlined;
    selectedVideos.value = [];
    watchLater.value = [];
  }
}
