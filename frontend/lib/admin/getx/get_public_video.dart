import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  RxString forYou = "foryou".obs;

  void changeForYou(String text){
    forYou.value = text;
  }
}
