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
        if(value!.isEmpty){
          return emptyMessage;
        }
        return null;
      },
    );
  }
}
