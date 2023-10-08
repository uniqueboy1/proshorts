import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:export_video_frame/export_video_frame.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/profile/get_own_profile.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/widgets/home_screen/video_details_input.dart';
import 'package:uuid/uuid.dart';

List videoCategory = [
  "Select Category",
  "Web Development",
  "App Development",
  "Machine Learning",
  "Artificial Intelligence",
  "Programming News",
  "Other"
];

List videoMode = ["Select Video Mode", "Public", "Private"];

class EditVideoDetails extends StatefulWidget {
  Map<String, dynamic> video;
  EditVideoDetails({required this.video, Key? key}) : super(key: key);

  @override
  State<EditVideoDetails> createState() => _EditVideoDetailsState();
}

class _EditVideoDetailsState extends State<EditVideoDetails> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  TextEditingController keywordsController = TextEditingController();
  Map<String, dynamic> currentVideo = {};
  late String selectedCategory;
  late String selectedMode;
  late String tempSelectedMode;
  late List keywords;

  String capitalizeEachWord(String input) {
    // Split the input string into words
    List<String> words = input.split(' ');

    // Capitalize the first letter of each word and join them back together
    String result = words.map((word) {
      if (word.isNotEmpty) {
        // Capitalize the first letter of the word and make the rest lowercase
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return ''; // Handle empty words
      }
    }).join(' ');

    return result;
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.video['title']);
    descriptionController =
        TextEditingController(text: widget.video['description']);
    keywords = widget.video['keywords'];
    selectedCategory = capitalizeEachWord(widget.video['category']);
    selectedMode = capitalizeEachWord(widget.video['videoMode']);
    tempSelectedMode = selectedMode;
    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future editVideo() async {
    Map<String, dynamic> video = {
      "title": titleController.text.trim().toLowerCase(),
      "description": descriptionController.text.trim().toLowerCase(),
      "keywords": keywords,
      "category": selectedCategory.toLowerCase(),
      "videoMode": selectedMode.toLowerCase(),
    };
    await VideoMethods().editVideo(widget.video['_id'], video);

    // updating video information to public_videos and private_videos
    Map<String, dynamic> videoInformation = {
      "videoInformation": widget.video['_id']
    };
    if (tempSelectedMode != selectedMode) {
      if (selectedMode.toLowerCase() == "public") {
        await UserMethods().editUserArrayField(
            MYPROFILE['_id'], videoInformation, "public_videos");
        await UserMethods().deleteUserArrayField(
            MYPROFILE['_id'], videoInformation, "private_videos");
      } else if (selectedMode.toLowerCase() == "private") {
        await UserMethods().editUserArrayField(
            MYPROFILE['_id'], videoInformation, "private_videos");
        await UserMethods().deleteUserArrayField(
            MYPROFILE['_id'], videoInformation, "public_videos");
      }
    }
    showSnackBar("Video", "Video Edited Successfully");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Video details"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    VideoDetailsInput(
                      maxLength: 50,
                      controller: titleController,
                      labelText: "Enter title of the video",
                      prefixIcon: Icons.title,
                      emptyMessage: "Please enter title",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    VideoDetailsInput(
                      controller: descriptionController,
                      maxLength: 100,
                      labelText: "Enter description of the video",
                      prefixIcon: Icons.description,
                      emptyMessage: "Please enter description",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLength: 300,
                      controller: keywordsController,
                      onChanged: (value) {
                        if (value.contains(".")) {
                          keywordsController.clear();
                          keywords
                              .add(value.replaceFirst(".", "").toLowerCase());
                          setState(() {});
                          print("keywords: $keywords");
                        }
                        // print("keywords : $keywords");
                      },
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        labelText: "Enter some keywords",
                        prefixIcon: Icon(Icons.description),
                      ),
                      validator: (value) {
                        int totalCharacters = 0;
                        print("keywords from validator: $keywords");
                        for (String keyword in keywords) {
                          totalCharacters = totalCharacters + keyword.length;
                        }
                        print("total keyword characters: $totalCharacters");
                        if (keywords.isEmpty) {
                          return "Please enter keywords";
                        }
                        if (totalCharacters > 300) {
                          return "You can only add 300 characters";
                        }

                        return null;
                      },
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(
                            minHeight: 0, minWidth: size.width * 0.5),
                        child: Container(
                            child: Column(
                          children: keywords.map((keyword) {
                            return Chip(
                              onDeleted: () {
                                keywords.remove(keyword);
                                setState(() {});
                              },
                              deleteIcon: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                              label: Text(keyword),
                            );
                          }).toList(),
                        ))),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButton(
                        isExpanded: true,
                        value: selectedCategory,
                        items: videoCategory.map((category) {
                          return DropdownMenuItem<String>(
                              enabled:
                                  category == "Select Category" ? false : true,
                              value: category,
                              child: Text(category));
                        }).toList(),
                        onChanged: (String? value) {
                          selectedCategory = value!;
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButton(
                        isExpanded: true,
                        value: selectedMode,
                        items: videoMode.map((mode) {
                          return DropdownMenuItem<String>(
                              enabled:
                                  mode == "Select Video Mode" ? false : true,
                              value: mode,
                              child: Text(mode));
                        }).toList(),
                        onChanged: (String? value) {
                          selectedMode = value!;
                          setState(() {});
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await editVideo();
                            // to show updated video list

                            Get.put(OwnProfileController()).changeVideoScreen(
                                Get.put(OwnProfileController())
                                    .visibilityIndex
                                    .value);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Update Video"))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
