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
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/widgets/profile/profile_input.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/profile.dart';
import '../../get/profile/get_setup_profile.dart';

class EditProfileOptions extends StatefulWidget {
  const EditProfileOptions({Key? key}) : super(key: key);

  @override
  State<EditProfileOptions> createState() => _EditProfileOptionsState();
}

class _EditProfileOptionsState extends State<EditProfileOptions> {
  Map<String, dynamic> myProfile = MYPROFILE;
  late TextEditingController nameController;
  late TextEditingController userNameController;
  late TextEditingController bioController;
  late TextEditingController youtubeURLController;
  late TextEditingController instagramURLController;
  late TextEditingController twitterURLController;
  late TextEditingController portfolioURLController;
  final _formKey = GlobalKey<FormState>();
  String profilePhoto = "";
  @override
  void initState() {
    nameController =
        TextEditingController(text: myProfile['profileInformation']['name']);
    userNameController = TextEditingController(
        text: myProfile['profileInformation']['username']);
    bioController =
        TextEditingController(text: myProfile['profileInformation']['bio']);
    youtubeURLController = TextEditingController(
        text: myProfile['profileInformation']['youtubeURL']);
    instagramURLController = TextEditingController(
        text: myProfile['profileInformation']['instagramURL']);
    twitterURLController = TextEditingController(
        text: myProfile['profileInformation']['twitterURL']);
    portfolioURLController = TextEditingController(
        text: myProfile['profileInformation']['portfolioURL']);
    profilePhoto =
        "$getProfilePhoto/${myProfile['profileInformation']['profilePhoto']}";
    setupProfileController.displayImage(profilePhoto);
    // TODO: implement initState
    super.initState();
  }

  SetupProfile setupProfile = SetupProfile();

  SetupProfileController setupProfileController =
      Get.put(SetupProfileController());

  void editProfile() async {
    if (selectedImage != null) {
      profilePhoto = basename(setupProfileController.image.value);
      profilePhoto = "${const Uuid().v1()}$profilePhoto";
      setupProfile
          .deleteProfilePhoto(myProfile['profileInformation']['profilePhoto']);
      setupProfile.uploadProfilePhoto(
          setupProfileController.image.value, profilePhoto);
    } else {
      profilePhoto = myProfile['profileInformation']['profilePhoto'];
    }
    Map<String, dynamic> profile = {
      "profilePhoto": profilePhoto,
      "name": nameController.text.trim().toLowerCase(),
      "username": userNameController.text.trim().toLowerCase(),
      "bio": bioController.text.trim().toLowerCase(),
      "youtubeURL": youtubeURLController.text.trim(),
      "instagramURL": instagramURLController.text.trim(),
      "twitterURL": twitterURLController.text.trim(),
      "portfolioURL": portfolioURLController.text.trim(),
      "email": FirebaseAuth.instance.currentUser!.email
    };
    setupProfile.editProfile(myProfile['profileInformation']['_id'], profile);
  }

  XFile? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit your profile"),
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
                        selectedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (selectedImage != null) {
                          setupProfileController
                              .displayImage(selectedImage!.path);
                        } else {
                          Get.snackbar(
                              "Profile Photo", "Please select a profile photo");
                        }
                      },
                      child: Obx(
                        () => CircleAvatar(
                          // showing image using FileImage
                          backgroundImage: selectedImage == null
                              ? NetworkImage(profilePhoto)
                              : FileImage(
                                      File(setupProfileController.image.value))
                                  as ImageProvider<Object>,
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
                          editProfile();
                        }
                      },
                      child: const Text("Update Profile"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
