import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';

import '../../controllers/profile.dart';
import '../../controllers/users.dart';

class FetchProfileController extends GetxController {
  RxMap myProfile = {}.obs;
  RxBool isProfileSetup = false.obs;
  Future fetchMyProfile() async {
    List users = await UserMethods().fetchUsersByField(
        "email", FirebaseAuth.instance.currentUser!.email.toString());
    myProfile.value = users[0];
    isProfileSetup.value = myProfile.containsKey("profileInformation");
    print("profile created : ${isProfileSetup.value}");
    MYPROFILE = myProfile;
  }

  void setupProfile() {
    isProfileSetup.value = true;
  }
}
