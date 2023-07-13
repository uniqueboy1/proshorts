import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import '../widgets/settings/change_password_input.dart';
import "package:bcrypt/bcrypt.dart";

class OTPPage extends StatelessWidget {
  final String email;
  final String otp;
  final String password;
  OTPPage(
      {Key? key,
      required this.email,
      required this.otp,
      required this.password})
      : super(key: key);

  final TextEditingController otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String hasPassword() {
    String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
    return hashedPassword;
  }

  void createAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: hasPassword());
      if (userCredential.user != null) {
        Get.to(LoginScreen());
      }
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("OTP Page"),
          centerTitle: true,
        ),
        body: Center(
          child: Form(
              key: _formKey,
              child: SizedBox(
                width: size.width * 0.9,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text("OTP has been sent to $email"),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.output),
                        labelText: "Enter OTP",
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter OTP";
                        }
                        if(value != otp){
                          return "Enter correct OTP";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createAccount();
                        }
                      },
                      child: Text("Submit"),
                    )
                  ],
                ),
              )),
        ));
  }
}
