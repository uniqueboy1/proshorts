import 'package:flutter/material.dart';

class ChangePasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String emptyMessage;

  const ChangePasswordInput({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.emptyMessage,
  }) : super(key: key);

  // criteria for strong password
  // 1. at least 10 characters
  // 2. at least 3 capital letters
  // 3. at least 3 special symbols
  // 4. at least 2 small letters
  // 5. at least 2 number

  bool isPasswordStrong() {
    String password = controller.text.trim();

    if (password.length > 10) {
      RegExp number = RegExp(r'[0-9]');
      int countNumber = number.allMatches(password).length;

      print("countNumber : $countNumber");

      RegExp lowercase = RegExp(r'[a-z]');
      int countLowercase = lowercase.allMatches(password).length;
      print("countLowercase : $countLowercase");

      RegExp uppercase = RegExp(r'[A-Z]');
      int countUppercase = uppercase.allMatches(password).length;
      print("countUppercase : $countUppercase");

      RegExp specialSymbols = RegExp(r'[^0-9a-zA-Z]');
      int countSpecialSymbols = specialSymbols.allMatches(password).length;
      print("countSpecialSymbols : $countSpecialSymbols");

      if (countNumber >= 2 &&
          countLowercase >= 2 &&
          countUppercase >= 3 &&
          countSpecialSymbols >= 3) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: labelText,
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return emptyMessage;
        }
        if (!isPasswordStrong()) {
          return "Weak Password !";
        }
        return null;
      },
    );
  }
}
