import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';

class VideoDetailsInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final String? emptyMessage;
  final int? maxLength;
  VideoDetailsInput(
      {Key? key,
      required this.controller,
      required this.labelText,
      required this.prefixIcon,
      this.emptyMessage,
      this.maxLength})
      : super(key: key);

  bool isPasswordStrong() {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      controller: controller,
      onChanged: (value) {},
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return emptyMessage;
        }
        return null;
      },
    );
  }
}
