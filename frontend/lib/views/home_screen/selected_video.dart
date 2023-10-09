import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:tapioca/tapioca.dart';
import 'package:flutter/services.dart';

import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_select_video.dart';
import 'package:pro_shorts/views/editor/editor_screen.dart';
import 'package:pro_shorts/views/home_screen/upload_video.dart';

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
  final TextEditingController _textEditingController = TextEditingController();
  bool isTextFieldVisible = false;
  int processPercentage = 0;

  String textOverVideo = '';
  static const EventChannel _channel =
      const EventChannel('video_editor_progress');
  late StreamSubscription _streamSubscription;
  @override
  void initState() {
    super.initState();
    selectVideoController = Get.put(SelectVideoController());
    selectVideoController.initializeVideo(widget.videoPath);
  }

  void _enableEventReceiver() {
    _streamSubscription =
        _channel.receiveBroadcastStream().listen((dynamic event) {
      setState(() {
        processPercentage = (event.toDouble() * 100).round();
      });
    }, onError: (dynamic error) {
      print('Received error: ${error.message}');
    }, cancelOnError: true);
  }

  void _disableEventReceiver() {
    _streamSubscription.cancel();
  }

  void _toggleTextField(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                textOverVideo =
                                    _textEditingController.text.trim();
                                final tapiocaBalls = [
                                  TapiocaBall.textOverlay(textOverVideo, 100,
                                      10, 100, Colors.amber),
                                ];
                                final cup = Cup(
                                    Content(widget.videoPath.toString()),
                                    tapiocaBalls);
                                cup.suckUp('/storage/emulated/0').then(
                                  (_) async {
                                    print("finished");
                                    setState(
                                      () {
                                        processPercentage = 0;
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.send))),
                      autofocus: true,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        // context: context,
        // builder: (BuildContext context) {
        //   return Column(
        //     mainAxisSize: MainAxisSize.min,
        //     children: <Widget>[
        //       Padding(
        //         padding: EdgeInsets.all(16.0),
        //         child: Expanded(
        //           child: TextField(
        //             controller: _textEditingController,
        //             onChanged: (text) {
        //               setState(() {
        //                 textOverVideo = _textEditingController.text
        //                     .trim(); // Store the input text
        //               });
        //             },
        //             decoration: InputDecoration(
        //               hintText: 'Enter text...',
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   );
        // },
        );
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
            Positioned(
              top: 10,
              right: 10,
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => EditorScreen(file: widget.videoPath),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: white,
                          ),
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
                        ElevatedButton(
                          onPressed: () {
                            _toggleTextField(context);
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  StadiumBorder())),
                          child: Icon(
                            Icons.text_fields,
                            color: Colors.red,
                          ),
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
                      children: const [
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
