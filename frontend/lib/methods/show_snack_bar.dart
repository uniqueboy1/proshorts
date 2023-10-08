import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackBar(String title, String message,
    {Color backgroundColor = Colors.red}) {
  Get.snackbar(title, message,
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      titleText: Text(title, style: const TextStyle(color: Colors.white)),
      messageText: Text(message,
          style: const TextStyle(
              fontStyle: FontStyle.italic, color: Colors.white)));
}
