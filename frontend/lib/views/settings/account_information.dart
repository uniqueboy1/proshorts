import 'package:flutter/material.dart';

import '../../constants.dart';

class AccountInformation extends StatelessWidget {
  AccountInformation({Key? key}) : super(key: key);
  Map<String, dynamic> myProfile = MYPROFILE;

  @override
  Widget build(BuildContext context) {
    String email = myProfile['email'];
    String username = myProfile['profileInformation']['username'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account Information"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Card(
              child: ListTile(
            title: Text("E-mail : $email"),
          )),
          const SizedBox(
            height: 20,
          ),
          Card(
              child: ListTile(
            title: Text("Username : $username"),
          )),
        ],
      ),
    );
  }
}
