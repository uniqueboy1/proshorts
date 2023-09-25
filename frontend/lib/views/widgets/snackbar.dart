import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showError(String message, BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10)
    ),
    elevation: 72,
    padding: const EdgeInsets.all(10),
    content: Text(message),
    showCloseIcon: true,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showToastError(String message){
Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.green,
  textColor: Colors.white,
);

}
