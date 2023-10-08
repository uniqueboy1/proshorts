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
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/widgets/home_screen/video_details_input.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';

List videoCategory = [
  "Web Development",
  "App Development",
  "Machine Learning",
  "Artificial Intelligence",
  "Programming News",
  "Other"
];

List videoMode = ["Public", "Private"];

class UploadVideo extends StatefulWidget {
  final File videoPath;
  final double videoLength;
  const UploadVideo(
      {required this.videoPath, required this.videoLength, Key? key})
      : super(key: key);

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();

  String? selectedCategory;
  String? selectedMode;
  List keywords = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

// generaring thumbnail
  List frames = [];
  Future exportFrames() async {
    frames = await ExportVideoFrame.exportImage(widget.videoPath.path, 1, 1);
    print("frames : ${basename(frames[0].path)}");
  }

  late String compressedVideoPath;
  late double compressedVideoSize;

  Future<void> compressVideo(String inputPath) async {
    try {
      final MediaInfo? info = await VideoCompress.compressVideo(inputPath,
          quality: VideoQuality.LowQuality,
          // Set to true if you want to delete the original video
          deleteOrigin: false);

      if (info != null && info.filesize! > 0) {
        compressedVideoPath = info.path!;
        // info.filesize gives size in bytes
        compressedVideoSize = info.filesize! / (1024 * 1024);
      } else {
        print('Video compression failed');
      }
    } catch (error) {
      print("error while compressing : $error");
    }
  }

  Future addVideo(BuildContext context) async {
    // to show circular bar
    isVideoUploading = true;
    setState(() {});
    // generating thumbnail
    await exportFrames();
    // compressing video
    await compressVideo(widget.videoPath.path);
    // creating unique video name
    String videoPath = "${const Uuid().v1()}${basename(widget.videoPath.path)}";
    String thumbnailName = "${const Uuid().v1()}.jpg";
    print("video path: $videoPath");
    Map<String, dynamic> video = {
      "title": titleController.text.trim().toLowerCase(),
      "description": descriptionController.text.trim().toLowerCase(),
      "keywords": keywords,
      "category": selectedCategory!.toLowerCase(),
      "videoMode": selectedMode!.toLowerCase(),
      "userInformation": MYPROFILE['_id'],
      "lengthOfVideo": widget.videoLength,
      "videoSize": compressedVideoSize.toStringAsFixed(2),
      "email": FirebaseAuth.instance.currentUser!.email,
      "videoPath": videoPath,
      "thumbnailName": thumbnailName
    };
    Map<String, dynamic> response = await VideoMethods().addVideo(video,
        File(compressedVideoPath), videoPath, frames[0].path, thumbnailName);
    print("upload video response: $response");

    // uploading video information to public_videos and private_videos
    Map<String, dynamic> videoInformation = {
      "videoInformation": response['_id']
    };
    if (selectedMode!.toLowerCase() == "public") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "public_videos");
    } else if (selectedMode!.toLowerCase() == "private") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "private_videos");
    }
    showSnackBar("Video", "Video Uploaded Successfully",
        backgroundColor: Colors.green);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Get.to(() => const OwnProfileScreen());
  }

  bool isVideoUploading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Video details"),
      ),
      body: isVideoUploading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Uploading ..."),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            )
          : SingleChildScrollView(
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
                          maxLength: 100,
                          controller: descriptionController,
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
                              keywords.add(
                                  value.replaceFirst(".", "").toLowerCase());
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
                              totalCharacters =
                                  totalCharacters + keyword.length;
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
                            )),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Please select a category";
                              }
                              return null;
                            },
                            hint: const Text("Select Category"),
                            isExpanded: true,
                            value: selectedCategory,
                            items: videoCategory.map((category) {
                              return DropdownMenuItem<String>(
                                  value: category, child: Text(category));
                            }).toList(),
                            onChanged: (String? value) {
                              selectedCategory = value!;
                              setState(() {});
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                        DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return "Please select a video mode";
                              }
                              return null;
                            },
                            isExpanded: true,
                            hint: const Text("Select Video Mode"),
                            value: selectedMode,
                            items: videoMode.map((mode) {
                              return DropdownMenuItem<String>(
                                  value: mode, child: Text(mode));
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
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await addVideo(context);
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
