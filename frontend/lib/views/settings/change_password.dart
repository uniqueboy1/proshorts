import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_shorts/views/widgets/snackbar.dart';

import '../widgets/settings/change_password_input.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  List<bool> showHidePassword = [true, true, true];

  // criteria for strong password
  bool isPasswordStrong(String userPassword) {
    String password = userPassword;

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
    void changePassword(
        String email, String oldPassword, String newPassword) async {
      FirebaseAuth auth = FirebaseAuth.instance;

      try {
        // first logging using old password
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email,
          password: oldPassword,
        );

        // Proceed to change the password
        User user = userCredential.user!;
        await user.updatePassword(newPassword);
        showError('Password changed successfully.', context);
      } on FirebaseAuthException catch (error) {
        if (error.code == "wrong-password") {
          showError("Old Password is incorrect", context);
        }
        print("failed to change password : ${error.code}");
      }
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Change Password"),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: size.width * 0.9,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: oldPasswordController,
                      obscureText: showHidePassword[0],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              showHidePassword[0] = !showHidePassword[0];
                              setState(() {});
                            },
                            icon: showHidePassword[0]
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        labelText: "Old Password",
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter old password";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: newPasswordController,
                      obscureText: showHidePassword[1],
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              showHidePassword[1] = !showHidePassword[1];
                              setState(() {});
                            },
                            icon: showHidePassword[1]
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off)),
                        labelText: "New Password",
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter new password";
                        }
                        String oldPassword = oldPasswordController.text.trim();
                        String newPassword = newPasswordController.text.trim();
                        if (oldPassword == newPassword) {
                          return "Old and New Password are same";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: confirmPasswordController,
                        obscureText: showHidePassword[2],
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                showHidePassword[2] = !showHidePassword[2];
                                setState(() {});
                              },
                              icon: showHidePassword[2]
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off)),
                          labelText: "Confirm Password",
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter confirm password";
                          }
                          String oldPassword =
                              oldPasswordController.text.trim();
                          String newPassword =
                              newPasswordController.text.trim();
                          String confiremPassword =
                              confirmPasswordController.text.trim();
                          if (!isPasswordStrong(newPassword)) {
                            return "Weak Password !";
                          }
                          if (newPassword != confiremPassword) {
                            return "New and confirm password doesn't match";
                          }

                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // showError("message", context);
                        if (_formKey.currentState!.validate()) {
                          String? email =
                              FirebaseAuth.instance.currentUser!.email;
                          changePassword(
                              email!,
                              oldPasswordController.text.trim(),
                              newPasswordController.text.trim());
                        }
                      },
                      child: const Text("Submit"),
                    )
                  ],
                ),
              )),
        ));
  }
}
