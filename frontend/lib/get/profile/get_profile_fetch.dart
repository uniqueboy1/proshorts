import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';

import '../../controllers/profile.dart';
import '../../controllers/users.dart';

class FetchProfileController extends GetxController {
  RxList myOwnProfileDetails = [].obs;
  RxBool isProfileSetup = false.obs;

  void fetchOwnProfile() async {
    myOwnProfileDetails.value = await UserMethods().fetchUsersByField("email", FirebaseAuth.instance.currentUser!.email.toString());
    print("my own profile details : ${myOwnProfileDetails}");
  }
  void profileSetup(){
    isProfileSetup.value = true;
  }
}
