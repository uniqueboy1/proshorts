import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';

class InputTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData icon;
  bool isObscure;
  final String? emptyMessage;
  IconData? suffixIcon;
  InputTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.icon,
    this.emptyMessage,
    this.suffixIcon,
    this.isObscure = false,
  }) : super(key: key);

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  // criteria for strong password
  // 1. at least 10 characters
  // 2. at least 3 capital letters
  // 3. at least 3 special symbols
  // 4. at least 2 small letters
  // 5. at least 2 number

  bool isPasswordStrong() {
    String password = widget.controller.text;

    if (password.length >= 10) {
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

  String emailExistMessage = "";
  // checking email already exists or not
  Future<String> isEmailExist(String email) async {
    emailExistMessage = "";
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      List<String> methods = await auth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        return "E-mail already exists";
      }
    } catch (e) {
      print(e);
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isObscure,
      controller: widget.controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue)),
        labelText: widget.labelText,
        prefixIcon: Icon(widget.icon),
        helperText: widget.labelText == "Password"
            ? "Length >= 10, Capital >= 3, Special Symbol >= 3, Small Letter >= 2 and Numbers >= 2"
            : "",
        prefixIconColor: red,
        suffixIcon: IconButton(
            onPressed: () {
              widget.suffixIcon =
                  widget.isObscure ? Icons.visibility_off : Icons.visibility;
              widget.isObscure = !widget.isObscure;
              setState(() {});
            },
            icon: Icon(widget.suffixIcon)),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return widget.emptyMessage;
        }
        if (!isPasswordStrong() && widget.labelText == "Password") {
          return "Weak Password !";
        }
        if (widget.labelText == "E-mail") {
          RegExp validEmail = RegExp(
            r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
          );
          if (!validEmail.hasMatch(value)) {
            return "Invallid E-mail";
          }
        }

        return null;
      },
    );
  }
}












// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pro_shorts/constants.dart';

// class InputTextFormField extends StatefulWidget {
//   final TextEditingController controller;
//   final String labelText;
//   final IconData icon;
//   bool isObscure;
//   final String? emptyMessage;
//   IconData? suffixIcon;
//   InputTextFormField({
//     Key? key,
//     required this.controller,
//     required this.labelText,
//     required this.icon,
//     this.emptyMessage,
//     this.suffixIcon,
//     this.isObscure = false,
//   }) : super(key: key);

//   @override
//   State<InputTextFormField> createState() => _InputTextFormFieldState();
// }

// class _InputTextFormFieldState extends State<InputTextFormField> {
//   // criteria for strong password
//   // 1. at least 10 characters
//   // 2. at least 3 capital letters
//   // 3. at least 3 special symbols
//   // 4. at least 2 small letters
//   // 5. at least 2 number

//   bool isPasswordStrong() {
//     String password = widget.controller.text;

//     if (password.length > 10) {
//       RegExp number = RegExp(r'[0-9]');
//       int countNumber = number.allMatches(password).length;

//       print("countNumber : $countNumber");

//       RegExp lowercase = RegExp(r'[a-z]');
//       int countLowercase = lowercase.allMatches(password).length;
//       print("countLowercase : $countLowercase");

//       RegExp uppercase = RegExp(r'[A-Z]');
//       int countUppercase = uppercase.allMatches(password).length;
//       print("countUppercase : $countUppercase");

//       RegExp specialSymbols = RegExp(r'[^0-9a-zA-Z]');
//       int countSpecialSymbols = specialSymbols.allMatches(password).length;
//       print("countSpecialSymbols : $countSpecialSymbols");

//       if (countNumber >= 2 &&
//           countLowercase >= 2 &&
//           countUppercase >= 3 &&
//           countSpecialSymbols >= 3) {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       return false;
//     }
//   }

//   // checking email already exists or not
//   Future<String> isEmailExist(String email) async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     try {
//       List<String> methods = await auth.fetchSignInMethodsForEmail(email);
//       if (methods.isNotEmpty) {
//         return "E-mail already exists";
//       }
//     } catch (e) {
//       print(e);
//     }
//     return "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       obscureText: widget.isObscure,
//       controller: widget.controller,
//       decoration: InputDecoration(
//         focusedBorder: const OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue)),
//         labelText: widget.labelText,
//         prefixIcon: Icon(widget.icon),
//         prefixIconColor: red,
//         suffixIcon: IconButton(
//             onPressed: () {
//               widget.suffixIcon =
//                   widget.isObscure ? Icons.visibility_off : Icons.visibility;
//               widget.isObscure = !widget.isObscure;
//               setState(() {});
//             },
//             icon: Icon(widget.suffixIcon)),
//       ),
//       validator: (value) {
//         String emailExistMessage = "";
//         if (value!.isEmpty) {
//           return widget.emptyMessage;
//         }
//         if (!isPasswordStrong() && widget.labelText == "Password") {
//           return "Weak Password !";
//         }
//         if (widget.labelText == "E-mail") {
//           RegExp validEmail = RegExp(
//             r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
//           );
//           if (!validEmail.hasMatch(value)) {
//             return "Invallid E-mail";
//           } else {
//             isEmailExist(value).then((message) {
//               print("message : $message");
//               emailExistMessage = message;
//               print("emailExistMessage : $emailExistMessage");
//             });
//           }
//         }
//         print("emailExistMessage : $emailExistMessage");

//         if (emailExistMessage.isNotEmpty) {
//           print("emailExistMessage : $emailExistMessage");
//           return emailExistMessage;
//         }
//         print("emailExistMessage : $emailExistMessage");

//         return null;
//       },
//     );
//   }
// }
