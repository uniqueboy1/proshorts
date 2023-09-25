import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';

import '../../constants.dart';

class FollowersFollowingController extends GetxController {
  RxBool isFollowersClicked = true.obs;
  RxList following = [].obs;

  Future fetchFollowing() async {
    following.value = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE["_id"], "following");
  }

  void toogleFollowersFollowing(bool value) {
    isFollowersClicked.value = value;
  }

}
