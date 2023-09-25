import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import 'package:pro_shorts/views/widgets/snackbar.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showError('Password reset email sent.', context);
       Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) => LoginScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == "user-not-found") {
        showError('Enter registered E-mail', context);
      }
      else if (error.code == "invalid-email") {
        showError('Enter valid E-mail', context);
      }
      print('Failed to send password reset email: ${error.code})');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Reset Password"),
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
                      controller: emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: "Enter email",
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter your email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          resetPassword(emailController.text.trim());
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
