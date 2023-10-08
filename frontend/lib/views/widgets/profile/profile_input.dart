import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';
import "package:http/http.dart" as http;

class ProfileInput extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData? prefixIcon;
  final bool isObscure;
  final String? emptyMessage;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  const ProfileInput({
    Key? key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.emptyMessage,
    this.suffixIcon,
    this.suffixIconColor,
    this.isObscure = false,
  }) : super(key: key);

  @override
  State<ProfileInput> createState() => _ProfileInputState();
}

class _ProfileInputState extends State<ProfileInput> {
  Future<bool> checkUsernameExistance() async {
    final URL = Uri.parse(
        "${checkFieldExistance}/username/${widget.controller.text.trim()}");
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    return actualResponse['response'].isNotEmpty;
  }

  // @override
  // void initState() {
  //   print("init state called");
  //   // TODO: implement initState
  //   super.initState();
  //   // Perform the username existence check when the widget is initialized
  //   if (widget.labelText == "Enter username" && widget.controller.text != "") {
  //     checkUsernameExistance().then((value) {
  //       print("value : $value");
  //       setState(() {
  //         isUsernameExist = value;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          labelText: widget.labelText,
          prefixIcon: Icon(widget.prefixIcon),
          prefixIconColor: red,
          suffixIcon: Icon(widget.suffixIcon),
          suffixIconColor: widget.suffixIconColor),
      validator: (value) {
        if (value!.isEmpty && widget.prefixIcon == Icons.star) {
          return widget.emptyMessage;
        }

        return null;
      },
    );
  }
}
