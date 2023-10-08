import 'package:flutter/material.dart';

import '../../constants.dart';

class AccountInformation extends StatelessWidget {
  AccountInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String email = MYPROFILE['email'];
    print("my profile : $MYPROFILE");
    String? username = null;
    if (MYPROFILE.containsKey("profileInformation")) {
      username = MYPROFILE['profileInformation']['username'];
    }
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
          username != null ? Card(
              child: ListTile(
            title: Text("Username : $username"),
          )) : SizedBox()
        ],
      ),
    );
  }
}
