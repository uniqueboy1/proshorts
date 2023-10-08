import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/profile/setup_profile_options.dart';
import 'package:pro_shorts/views/settings/settings.dart';

class SetupProfile extends StatefulWidget {
  SetupProfile({Key? key}) : super(key: key);

  @override
  State<SetupProfile> createState() => _SetupProfileState();
}

class _SetupProfileState extends State<SetupProfile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackBar("Video", "Please setup profile to upload video");
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          width: size.width * 0.9,
          child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SetupProfileOptions()));
              },
              child: const Text("Setup your profile")),
        ),
      ),
    );
  }
}
