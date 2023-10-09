import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pro_shorts/views/signup/otp.dart';
import '../widgets/otp_mail.dart';
import '../widgets/text_form_field.dart';
import "package:pro_shorts/views/signup/login_screen.dart";

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void createAccount() async {
    isSigningProcess = true;
    setState(() {});
    await sendEmail(emailController.text.trim());
    Get.to(OTPPage(
        email: emailController.text.trim(),
        password: passwordController.text.trim()));
  }

  bool isSigningProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isSigningProcess
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Creating ..."),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : Center(
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
                          const SizedBox(
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
                                  child: const Text("SignUp"))),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account ? "),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ));
                                  },
                                  child: const Text("Login"))
                            ],
                          )
                        ],
                      ),
                    )),
              ));
  }
}
