import 'package:flutter/material.dart';

void snackBar(String message, BuildContext context) {
  final snackBar = SnackBar(
    backgroundColor: Colors.green,
    elevation: 72,
    padding: EdgeInsets.all(10),
    content: const Text('Message has been sent'),
    action: SnackBarAction(
      label: 'Undo',
      textColor: Colors.white,
      onPressed: () {
        print("Your message has't been sent");
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
