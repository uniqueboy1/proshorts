

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';

class WatchHistoryController extends GetxController {
  RxList watchHistory = [].obs;
  List allWatchHistory = [];
  Future fetchWatchHistory() async {
    watchHistory.value = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE['_id'], "watchHistory");
    allWatchHistory = List.of(watchHistory);
    watchHistory.value = watchHistory
        .where((video) => video['isWatchHistoryDeleted'] == false)
        .toList();

  }

  Future deleteWatchHistory() async {
    // Filter out items based on the condition
    allWatchHistory = allWatchHistory.map((item) {
      if (selectedVideos.contains(item["videoInformation"]["_id"])) {
        item['isWatchHistoryDeleted'] = true;
      }
      return item;
    }).toList();

    await UserMethods()
        .editUser(MYPROFILE['_id'], {"watchHistory": allWatchHistory});
  }

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
      for (var i = 0; i < watchHistory.length; i++) {
        selectedVideos.add(watchHistory[i]['videoInformation']['_id']);
      }
      selectAll.value = "Deselect All";
    } else {
      selectAll.value = "Select All";
    }

    select.value = "Select";
  }

  void changeIcon(Map<String, dynamic> video) {
    if (isSelectAllClicked.value) {
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

  void reset() {
    select.value = "Select";
    isSelectClicked.value = false;
    isSelectAllClicked.value = false;
    selectAll.value = "Select All";
    checkedIcon = FontAwesomeIcons.solidCircleCheck;
    noCheckedIcon = Icons.circle_outlined;
    selectedVideos.value = [];
    watchHistory.value = [];
  }
}
