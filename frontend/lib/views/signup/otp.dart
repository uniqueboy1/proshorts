import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/login/get_otp.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import 'package:pro_shorts/views/widgets/otp_mail.dart';

class OTPPage extends StatefulWidget {
  final String email;
  final String password;
  const OTPPage({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final TextEditingController otpController = TextEditingController();
  late Timer timer;

  final _formKey = GlobalKey<FormState>();

  OTPController getOtpController = Get.put(OTPController());

  void createAccount() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);
      if (userCredential.user != null) {
        Map<String, dynamic> user = {"email": widget.email};
        await UserMethods().addUser(user);
        Get.to(LoginScreen());
      }
    } on FirebaseAuthException catch (error) {
      print(error);
    }
  }

  void startTimer() {
    if (getOtpController.timer.value == 0) {
      otpPassword = "";
      isMailSend = false;
      getOtpController.timer.value = 60;
      stopTimer();
    } else {
      getOtpController.changeTimer();
    }
  }

  void stopTimer() {
    timer.cancel();
  }

  void showAlertDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: const Text('Are you Sure ?'), actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await sendEmail(widget.email);
                timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                  startTimer();
                });
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ]);
        });
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      startTimer();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("OTP Page"),
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
                    Text("OTP has been sent to ${widget.email}"),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: otpController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.output),
                        labelText: "Enter OTP",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter OTP";
                        }
                        if (value != otpPassword) {
                          return "Enter correct OTP";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Obx(() => TextButton(
                              onPressed: isMailSend
                                  ? null
                                  : () {
                                      showAlertDialog();
                                    },
                              child: isMailSend
                                  ? Text(
                                      "Resend in : ${getOtpController.timer.value} Seconds")
                                  : const Text("Resend"),
                            ))),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          createAccount();
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
