import 'package:flutter/material.dart';

import '../widgets/settings/change_password_input.dart';

class ChangePassword extends StatelessWidget {
   ChangePassword({Key? key}) : super(key: key);

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
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
                ChangePasswordInput(
                  labelText: "Old Password",
                  emptyMessage: "Please enter old password",
                  controller: oldPasswordController,
                ),
                SizedBox(
                  height: 20,
                ),
                ChangePasswordInput(
                  labelText: "New Password",
                  emptyMessage: "Please enter new password",
                  controller: newPasswordController,
                ),
                SizedBox(
                  height: 20,
                ),
                ChangePasswordInput(
                  labelText: "Confirm Password",
                  emptyMessage: "Please enter confirm password",
                  controller: confirmPasswordController,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _formKey.currentState!.validate();
                  },
                  child: Text("Submit"),
                )
              ],
            ),
          )),
        ));
  }
}
