// users can upload video of max size 5MB and duration 1 minute

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/home_screen/selected_video.dart';
import 'package:video_player/video_player.dart';

class AddVideo extends StatefulWidget {
  AddVideo({Key? key}) : super(key: key);

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  void pickVideo() async {
    ImagePicker videoPicker = ImagePicker();
    XFile? selectedVideo =
        await videoPicker.pickVideo(source: ImageSource.gallery);
    if (selectedVideo != null) {
      File videoPath = File(selectedVideo.path);
      // it gives size of video in bytes
      dynamic videoSize = await videoPath.length();
      videoSize = videoSize / (1024 * 1024);
      print("before video size : $videoSize");
      VideoPlayerController controller = VideoPlayerController.file(videoPath);
      await controller.initialize();

      // gives duration of video in seconds
      Duration videoLength = controller.value.duration;
      double videoDurationInSeconds = videoLength.inMilliseconds / 1000;
      print("video duration: $videoDurationInSeconds");
      if (videoSize <= 5 && videoDurationInSeconds <= 60) {
        Get.to(() => SelectedVideo(
              videoPath: videoPath,
              videoLength: videoDurationInSeconds,
            ));
      } else if (videoSize > 5) {
        showSnackBar(
            "Size of video exceed", "You can upload video of max size 5 MB");
      } else if (videoDurationInSeconds > 60) {
        showSnackBar("Duration of video exceed",
            "You can upload video of max duration 60 seconds");
      } else {
        showSnackBar("Duration and Size of video exceed",
            "You can upload video of max duration 60 seconds and size of 5 MB");
      }
    } else {
      showSnackBar("Video is not selected", "Please select a video");
    }
  }

  void recordVideo() async {
    ImagePicker videoPicker = ImagePicker();
    XFile? selectedVideo = await videoPicker.pickVideo(
        source: ImageSource.camera, maxDuration: const Duration(minutes: 1));
    if (selectedVideo != null) {
      File videoPath = File(selectedVideo.path);
      VideoPlayerController controller = VideoPlayerController.file(videoPath);
      await controller.initialize();
      // gives duration of video in seconds
      Duration videoLength = controller.value.duration;
      double videoDurationInSeconds = videoLength.inMilliseconds / 1000;
      print("video duration: $videoDurationInSeconds");
      Get.to(() => SelectedVideo(
            videoPath: videoPath,
            videoLength: videoDurationInSeconds,
          ));
    } else {
      showSnackBar("Video is not recored", "Please record a video");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Add Video")),
        body: SimpleDialog(
          title: const Text("Select Options"),
          children: [
            SimpleDialogOption(
              child: ListTile(
                onTap: () {
                  pickVideo();
                },
                title: const Text("Gallery"),
                leading: const Icon(Icons.file_upload_sharp),
              ),
            ),
            SimpleDialogOption(
              child: ListTile(
                onTap: () {
                  recordVideo();
                },
                title: const Text("Camera"),
                leading: const Icon(Icons.camera_alt),
              ),
            ),
            SimpleDialogOption(
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                },
                title: const Text("Cancel"),
                leading: const Icon(Icons.cancel),
              ),
            )
          ],
        ));
  }
}
