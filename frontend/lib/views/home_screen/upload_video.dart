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

class UploadVideo extends StatefulWidget {
  File videoPath;
  dynamic videoSize;
  double videoLength;
  UploadVideo(
      {required this.videoPath,
      required this.videoSize,
      required this.videoLength,
      Key? key})
      : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();

  String selectedCategory = videoCategory.first;
  String selectedMode = videoMode.first;
  List keywords = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  var frames;
  Future exportFrames() async {
    frames = await ExportVideoFrame.exportImage(widget.videoPath.path, 1, 1);
    print("frames : ${basename(frames[0].path)}");
  }

  @override
  void initState() {
    exportFrames();
    // TODO: implement initState
    super.initState();
  }

  void addVideo() async {
    String profileName = MYPROFILE['profileInformation']['name'];
    String username = MYPROFILE['profileInformation']['username'];
    String profilePhoto = MYPROFILE['profileInformation']['profilePhoto'];
    // creating unique video name
    String videoPath = "${const Uuid().v1()}${basename(widget.videoPath.path)}";
    String thumbnailName = "${const Uuid().v1()}.jpg";
    print("video path: $videoPath");
    Map<String, dynamic> video = {
      "title": titleController.text.trim().toLowerCase(),
      "description": descriptionController.text.trim().toLowerCase(),
      "keywords": keywords,
      "category": selectedCategory.toLowerCase(),
      "videoMode": selectedMode.toLowerCase(),
      "userInformation": MYPROFILE['_id'],
      "lengthOfVideo": widget.videoLength,
      "videoSize": widget.videoSize,
      "email": FirebaseAuth.instance.currentUser!.email,
      "videoPath": videoPath,
      "thumbnailName": thumbnailName
    };
    Map<String, dynamic> response = await VideoMethods().addVideo(
        video, widget.videoPath, videoPath, frames[0].path, thumbnailName);
    print("upload video response: $response");

    // uploading video information to public_videos and private_videos
    Map<String, dynamic> videoInformation = {
      "videoInformation": response['_id']
    };
    if (selectedMode.toLowerCase() == "public") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "public_videos");
    } else if (selectedMode.toLowerCase() == "private") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "private_videos");
    }
    Get.snackbar("Video", "Video Uploaded Successfully");
    Get.off(() => OwnProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    exportFrames();
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
                    labelText: "Enter description of the video",
                    prefixIcon: Icons.description,
                    emptyMessage: "Please enter description",
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: keywordsController,
                    onChanged: (value) {
                      if (value.contains(".")) {
                        keywordsController.clear();
                        keywords.add(value.replaceFirst(".", "").toLowerCase());
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
                      if (keywords.isEmpty) {
                        return "Please enter keywords";
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
                                category == videoCategory[0] ? false : true,
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
                            enabled: mode == videoMode[0] ? false : true,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Save as Draft")),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addVideo();
                            }
                          },
                          child: const Text("Upload"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
