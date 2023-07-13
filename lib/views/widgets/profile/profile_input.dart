import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';

class ProfileInput extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)),
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          prefixIconColor: red,
          suffixIcon: Icon(suffixIcon),
          suffixIconColor: suffixIconColor
          ),
          
      validator: (value) {
        if (value!.isEmpty) {
          return emptyMessage;
        }
      },
    );
  }
}
