import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SetupProfileController extends GetxController {
  RxString image = "".obs;

  void displayImage(String path){
    image.value = path;
  }


}