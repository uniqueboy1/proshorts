import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

    

    void login() async {
      String email = emailController.text.trim();
      String password = passwordController.text.trim();
      FirebaseAuth auth = FirebaseAuth.instance;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (userCredential.user != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ));
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text("Login"))),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          FaIcon(FontAwesomeIcons.google),
                          Text("Continue With Google"),
                        ],
                      )),
                ),
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
