import 'package:flutter/material.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/profile/setup_profile_options.dart';

class SetupProfile extends StatelessWidget {
  SetupProfile({Key? key}) : super(key: key);
  bool isProfileSetup = false;

  @override
  Widget build(BuildContext context) {
    return isProfileSetup
        ? OwnProfileScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(color: Colors.black),
              elevation: 0,
            ),
            body: Center(
              child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SetupProfileOptions()));
                  },
                  child: Text("Setup your profile")),
            ),
          );
  }
}
