import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/home_screen/selected_video.dart';
import 'package:pro_shorts/views/home_screen/upload_video.dart';
import 'package:pro_shorts/views/widgets/snackbar.dart';
import 'package:video_player/video_player.dart';

class AddVideo extends StatelessWidget {
  AddVideo({Key? key}) : super(key: key);


  void pickVideo() async {
    ImagePicker videoPicker = ImagePicker();
    XFile? selectedVideo =
        await videoPicker.pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      File videoPath = File(selectedVideo.path);
      Get.to(SelectedVideo(videoPath: videoPath));
    } else {
      Get.snackbar("Video is not selected", "Please select a video");
    }
  }

  void recordVideo() async {
    ImagePicker videoPicker = ImagePicker();
    XFile? selectedVideo = await videoPicker.pickVideo(
        source: ImageSource.camera, maxDuration: Duration(minutes: 1));
    if (selectedVideo != null) {
      File videoPath = File(selectedVideo.path);

      Get.to(SelectedVideo(videoPath: videoPath));
    } else {
      Get.snackbar("Video is not recored", "Please record a video");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Video")),
        body: SimpleDialog(
          title: Text("Select Options"),
          children: [
            SimpleDialogOption(
              child: ListTile(
                onTap: () {
                  pickVideo();
                },
                title: const Text("Gallery"),
                leading: Icon(Icons.file_upload_sharp),
              ),
            ),
            SimpleDialogOption(
              child: ListTile(
                onTap: () {
                  recordVideo();
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera_alt),
              ),
            ),
            SimpleDialogOption(
              child: ListTile(
                title: Text("Cancel"),
                leading: Icon(Icons.cancel),
              ),
            )
          ],
        ));
  }
}
