import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pro_shorts/views/signup/otp.dart';
import '../widgets/text_form_field.dart';
import "package:pro_shorts/views/signup/login_screen.dart";

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String otpPassword = '';

  void sendEmail() async {
    String username = 'information11993@gmail.com';
    String password = 'rrnyuwyftyigzttb';
    String recipient = emailController.text.trim();
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'ProShorts')
      ..recipients.add(recipient)
      ..subject = 'OTP Verfication'
      ..text = 'Please enter this otp to verify : ${otp()}';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport}');
    } catch (e) {
      print('Email sending failed: $e');
    }
  }

  String otp() {
    otpPassword = "";
    for (int i = 0; i < 6; i++) {
      otpPassword += Random().nextInt(10).toString();
    }
    print(otpPassword);
    return otpPassword;
  }

  void createAccount() {
    sendEmail();
    Get.to(OTPPage(
        email: emailController.text,
        otp: otpPassword,
        password: passwordController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    // void toastError(message) {
    //   Fluttertoast.showToast(
    //     msg: message,
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.TOP,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0,
    //   );
    // }

    return Scaffold(
        body: Center(
      child: Form(
          key: _formKey,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      "Create a new Account",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                InputTextFormField(
                  controller: emailController,
                  labelText: "E-mail",
                  icon: Icons.email,
                  emptyMessage: "Please enter e-mail",
                ),
                const SizedBox(
                  height: 20,
                ),
                InputTextFormField(
                  controller: passwordController,
                  labelText: "Password",
                  icon: Icons.lock,
                  isObscure: true,
                  emptyMessage: "Please enter passoword",
                  suffixIcon: Icons.visibility_off,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            createAccount();
                          }
                        },
                        child: Text("SignUp"))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account ? "),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                        child: Text("Login"))
                  ],
                )
              ],
            ),
          )),
    ));
  }
}
