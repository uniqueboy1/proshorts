import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/admin/admin_screen.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/profile/get_profile_fetch.dart';
import 'package:pro_shorts/views/home_screen/home_screen.dart';
import 'package:pro_shorts/views/signup/signup_screen.dart';
import 'package:pro_shorts/views/widgets/snackbar.dart';
import 'package:pro_shorts/views/widgets/text_form_field.dart';
import '../../constants.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (userCredential.user != null &&
            userCredential.user!.email == "admin@gmail.com") {
          await Get.put(FetchProfileController()).fetchMyProfile();
          Get.offAll(() => const AdminScreen());
        } else {
          await Get.put(FetchProfileController()).fetchMyProfile();
          Get.offAll(() => const HomeScreen());
        }
      } on FirebaseAuthException catch (error) {
        showError(error.code, context);
      }
    }

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
                      "Login Screen",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
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
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await login();
                          }
                        },
                        child: const Text("Login"))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account ? "),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ));
                        },
                        child: const Text("SignUp"))
                  ],
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text("Forgot password ?"),
                )
              ],
            ),
          )),
    ));
  }
}
