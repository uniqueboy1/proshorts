import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupProfileController extends GetxController {
  RxString image = "".obs;
  RxBool isUsernameValid = false.obs;

  void displayImage(String path) {
    image.value = path;
  }

  void displayError(bool isValid) {
    isUsernameValid.value = isValid;
  }

  void reset() {
    image.value = "";
    isUsernameValid.value = false;
  }
}
