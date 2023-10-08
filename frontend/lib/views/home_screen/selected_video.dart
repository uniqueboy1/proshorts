import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_select_video.dart';
import 'package:pro_shorts/views/home_screen/upload_video.dart';
import 'package:video_player/video_player.dart';

class SelectedVideo extends StatefulWidget {
  File videoPath;
  double videoLength;
  SelectedVideo(
      {super.key, required this.videoPath, required this.videoLength});

  @override
  State<SelectedVideo> createState() => _SelectedVideoState();
}

class _SelectedVideoState extends State<SelectedVideo> {
  late SelectVideoController selectVideoController;
  @override
  void initState() {
    super.initState();
    selectVideoController = Get.put(SelectVideoController());
    selectVideoController.initializeVideo(widget.videoPath);
  }

  @override
  void dispose() {
    super.dispose();
    selectVideoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    selectVideoController.playVideo();
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                // pausing current video
                selectVideoController.controller!.pause();
                Get.to(() => UploadVideo(
                      videoPath: widget.videoPath,
                      videoLength: widget.videoLength,
                    ));
              },
              child: const Text(
                "Next",
                style: TextStyle(color: white),
              ))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                selectVideoController.showPlayPauseIcon();
                // print("aspect ratio");
                // print(selectVideoController.controller!.value.aspectRatio);
              },
              child: Center(
                  child: AspectRatio(
                      aspectRatio:
                          selectVideoController.controller!.value.aspectRatio,
                      child: VideoPlayer(selectVideoController.controller!))),
            ),
            Obx(
              () => !selectVideoController.isVideoPlaying.value
                  ? const Center(
                      child: Icon(
                      Icons.play_arrow,
                      color: white,
                      size: 50,
                    ))
                  : const SizedBox(),
            ),
            const Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Icon(
                          Icons.edit,
                          color: white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Edit",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Aa",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Text",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          FontAwesomeIcons.noteSticky,
                          color: white,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Stickers",
                          style: TextStyle(
                              color: white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
