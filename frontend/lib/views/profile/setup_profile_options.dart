import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/widgets/profile/profile_input.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/profile.dart';
import '../../get/profile/get_setup_profile.dart';

class SetupProfileOptions extends StatelessWidget {
  SetupProfileOptions({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController youtubeURLController = TextEditingController();
  final TextEditingController instagramURLController = TextEditingController();
  final TextEditingController twitterURLController = TextEditingController();
  final TextEditingController portfolioURLController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SetupProfile setupProfile = SetupProfile();
  SetupProfileController setupProfileController =
      Get.put(SetupProfileController());

  void addProfile() async {
    String profilePhoto = basename(setupProfileController.image.value);
    profilePhoto = "${const Uuid().v1()}$profilePhoto";
    Map<String, dynamic> profile = {
      "profilePhoto": profilePhoto,
      "name": nameController.text.trim().toLowerCase(),
      "username": userNameController.text.trim(),
      "bio": bioController.text.trim().toLowerCase(),
      "youtubeURL": youtubeURLController.text.trim(),
      "instagramURL": instagramURLController.text.trim(),
      "twitterURL": twitterURLController.text.trim(),
      "portfolioURL": portfolioURLController.text.trim(),
      "email": FirebaseAuth.instance.currentUser!.email
    };
    await setupProfile.addProfile(
        profile, setupProfileController.image.value, profilePhoto);
    Get.snackbar("Profile", "Profile Created Successfully");
    Get.to(() => OwnProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup your profile"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: SizedBox(
              width: 350,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () async {
                        // image_picker for picking image from mobile devices
                        XFile? selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (selectedImage != null) {
                          setupProfileController
                              .displayImage(selectedImage.path);
                        } else {
                          Get.snackbar(
                              "Profile Photo", "Please select a profile photo");
                        }
                      },
                      child: Obx(
                        () => CircleAvatar(
                          // showing image using FileImage
                          backgroundImage:
                              setupProfileController.image.value != ""
                                  ? FileImage(
                                      File(setupProfileController.image.value))
                                  : null,
                          radius: 50,
                          child: Text(
                            setupProfileController.image.value == ""
                                ? "Choose a photo"
                                : "",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: nameController,
                    labelText: "Enter your name",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please enter your name",
                    suffixIcon: Icons.person_2_rounded,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: userNameController,
                    labelText: "Enter username",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please enter the username",
                    suffixIcon: Icons.person_2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: bioController,
                    labelText: "Describe about your channel",
                    prefixIcon: Icons.star,
                    emptyMessage: "Please add a bio",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(children: const [
                    Text(
                      "Add social media link",
                    )
                  ]),
                  const SizedBox(
                    height: 15,
                  ),
                  ProfileInput(
                    controller: youtubeURLController,
                    labelText: "Enter youtube URL",
                    emptyMessage: "Please enter youtube URL",
                    suffixIcon: FontAwesomeIcons.youtube,
                    suffixIconColor: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: instagramURLController,
                    labelText: "Enter instagram URL",
                    emptyMessage: "Please enter instagram URL",
                    suffixIcon: FontAwesomeIcons.instagram,
                    suffixIconColor: Colors.red,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: twitterURLController,
                    labelText: "Enter twitter URL",
                    emptyMessage: "Please enter twitter URL",
                    suffixIcon: FontAwesomeIcons.twitter,
                    suffixIconColor: Colors.blue,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileInput(
                    controller: portfolioURLController,
                    labelText: "Enter your portfolio URL",
                    emptyMessage: "Please enter your portfolio URL",
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          addProfile();
                        }
                      },
                      child: const Text("Setup Profile"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
