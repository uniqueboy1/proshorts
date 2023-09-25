import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OwnProfileController extends GetxController {
  RxInt visibilityIndex = 0.obs;

  void changeVideoScreen(int index){
    visibilityIndex.value = index;
  }


}