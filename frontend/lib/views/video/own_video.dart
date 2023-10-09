import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/profile/get_own_profile.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/home_screen/comment.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/video/edit_video_details.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class OwnVideo extends StatefulWidget {
  final String videoId;
  const OwnVideo({Key? key, required this.videoId}) : super(key: key);

  @override
  State<OwnVideo> createState() => _OwnVideoState();
}

class _OwnVideoState extends State<OwnVideo> {
  OwnVideoController ownVideoController = Get.put(OwnVideoController());

  late VideoPlayerController videoPlayerController;
  Map<String, dynamic> currentVideo = {};
  Future fetchCurrentVideo() async {
    List video = await VideoMethods().fetchVideosByField("_id", widget.videoId);
    print("video from own video : $video");
    print("id of video own video : ${widget.videoId}");
    currentVideo = video[0];
    videoPlayerController =
        VideoPlayerController.network("$getVideo/${currentVideo['videoPath']}")
          ..initialize();
    ownVideoController.commentsCount.value = currentVideo['comments'].length;
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("My Video")),
        body: FutureBuilder(
            future:
                fetchCurrentVideo(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return OwnVideoScreen(
                    video: currentVideo,
                    videoPlayerController: videoPlayerController);
              }
            }));
  }
}

class OwnVideoScreen extends StatefulWidget {
  Map<String, dynamic> video;
  VideoPlayerController videoPlayerController;
  OwnVideoScreen(
      {Key? key, required this.video, required this.videoPlayerController})
      : super(key: key);

  @override
  State<OwnVideoScreen> createState() => _OwnVideoScreenState();
}

class _OwnVideoScreenState extends State<OwnVideoScreen> {
  OwnVideoController ownVideoController = Get.put(OwnVideoController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            context: context,
            builder: (context) {
              return SizedBox(
                  height: 100,
                  child: EditingOptions(
                    videoId: widget.video['_id'],
                    videoMode: widget.video['videoMode'],
                  ));
            });
      },
      child: Container(
        color: Colors.black,
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Center(
            child: AspectRatio(
              aspectRatio: widget.videoPlayerController.value.aspectRatio,
              child: GestureDetector(
                  onTap: () {
                    ownVideoController
                        .showPlayPauseIcon(widget.videoPlayerController);
                  },
                  child: VideoPlayer(widget.videoPlayerController)),
            ),
          ),
          Obx(
            () => !ownVideoController.isVideoPlaying.value
                ? const Center(
                    child: Icon(
                    Icons.play_arrow,
                    color: white,
                    size: 50,
                  ))
                : const SizedBox(),
          ),
          UserAndVideoDetails(video: widget.video, size: size),
          InteractOptions(video: widget.video, size: size),
        ]),
      ),
    );
  }
}

class EditingOptions extends StatefulWidget {
  final String videoId;
  final String videoMode;
  const EditingOptions(
      {Key? key, required this.videoId, required this.videoMode})
      : super(key: key);

  @override
  State<EditingOptions> createState() => _EditingOptionsState();
}

class _EditingOptionsState extends State<EditingOptions> {
  OwnVideoController ownVideoController = Get.put(OwnVideoController());

  Future fetchCurrentVideo() async {
    List videos =
        await VideoMethods().fetchVideosByField("_id", widget.videoId);
    return videos[0];
  }

  Future deleteVideo() async {
    Map<String, dynamic> video = await fetchCurrentVideo();
    await VideoMethods().deleteVideoById(
        widget.videoId, video['thumbnailName'], video['videoPath']);
    showSnackBar("Video", "Video deleted successfully");
    Navigator.popUntil(context, (route) => route.isFirst);
    Get.to(() => const OwnProfileScreen());
  }

  Future fetchVideoMode() async {
    ownVideoController.selectedVideoMode.value = await VideoMethods()
        .fetchSpecificVideosField("_id", widget.videoId, "videoMode");
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            Map<String, dynamic> video = await fetchCurrentVideo();
            Get.to(() => EditVideoDetails(
                  video: video,
                ));
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit),
              SizedBox(
                height: 10,
              ),
              Text("Edit Video")
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                context: context,
                builder: ((context) {
                  return FutureBuilder(
                      future:
                          fetchVideoMode(), // The Future<T> that you want to monitor
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Display a loading indicator while waiting for the Future to complete
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Display an error message if the Future throws an error
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return SizedBox(
                            height: 200,
                            child: Column(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Select Video Mode",
                                    style: TextStyle(fontSize: 19),
                                  ),
                                ),
                                Card(
                                    child: Obx(
                                  () => RadioListTile(
                                      title: const Text("Public"),
                                      value: "public",
                                      groupValue: ownVideoController
                                          .selectedVideoMode.value,
                                      onChanged: ((value) async {
                                        await ownVideoController
                                            .changeVideoMode(
                                                value!, widget.videoId);
                                        // to show updated video list
                                        Get.put(OwnProfileController())
                                            .changeVideoScreen(
                                                Get.put(OwnProfileController())
                                                    .visibilityIndex
                                                    .value);
                                        Get.back();
                                        Get.back();
                                      })),
                                )),
                                Card(
                                    child: Obx(
                                  () => RadioListTile(
                                      title: const Text("Private"),
                                      value: "private",
                                      groupValue: ownVideoController
                                          .selectedVideoMode.value,
                                      onChanged: ((value) async {
                                        await ownVideoController
                                            .changeVideoMode(
                                                value!, widget.videoId);
                                        // to show updated video list

                                        Get.put(OwnProfileController())
                                            .changeVideoScreen(
                                                Get.put(OwnProfileController())
                                                    .visibilityIndex
                                                    .value);
                                        Get.back();
                                        Get.back();
                                      })),
                                ))
                              ],
                            ),
                          );
                        }
                      });
                }));
          },
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock),
              SizedBox(
                height: 10,
              ),
              Text("Privacy Setting")
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Are you sure want to delete your video ?"),
                  content: const Text("Your video will be permanently deleted"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        child: const Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          await deleteVideo();
                        },
                        child: const Text("OK")),
                  ],
                );
              },
            );
          },
          child: GestureDetector(
            onTap: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                          "Are you sure want to delete your video ?"),
                      content:
                          const Text("Your video will be permanently deleted"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                              Get.back();
                            },
                            child: const Text("Cancel")),
                        TextButton(
                            onPressed: () async {
                              await deleteVideo();
                            },
                            child: const Text("Delete")),
                      ],
                    );
                  });
            },
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever),
                SizedBox(
                  height: 10,
                ),
                Text("Delete Video")
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class UserAndVideoDetails extends StatefulWidget {
  Size size;
  Map<String, dynamic> video;
  UserAndVideoDetails({Key? key, required this.size, required this.video})
      : super(key: key);

  @override
  State<UserAndVideoDetails> createState() => _UserAndVideoDetailsState();
}

class _UserAndVideoDetailsState extends State<UserAndVideoDetails> {
  OwnVideoController ownVideoController = Get.put(OwnVideoController());

  @override
  Widget build(BuildContext context) {
    String profilePhoto =
        "$getProfilePhoto/${widget.video['userInformation']['profileInformation']['profilePhoto']}";
    String username =
        widget.video['userInformation']['profileInformation']['username'];
    String title = widget.video['title'];
    return Positioned(
      bottom: 10,
      left: 10,
      child: SizedBox(
        width: widget.size.width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(profilePhoto),
                    backgroundColor: green,
                  ),
                  Positioned(
                      left: 75,
                      top: 5,
                      child: Text(
                        username,
                        style: const TextStyle(
                            color: white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                  color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: Obx(
                  () => Text(
                    ownVideoController.videoDescription.value,
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Obx(() => ownVideoController.videoDescription.value.length >= 25
                    ? TextButton(
                        onPressed: () {
                          ownVideoController
                              .toogleSeeMore(widget.video['description']);
                        },
                        child: Text(
                          ownVideoController.seeMore.value,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    : const SizedBox())
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InteractOptions extends StatefulWidget {
  Size size;
  Map<String, dynamic> video;

  InteractOptions({Key? key, required this.size, required this.video})
      : super(key: key);

  @override
  State<InteractOptions> createState() => _InteractOptionsState();
}

class _InteractOptionsState extends State<InteractOptions> {
  OwnVideoController ownVideoController = Get.put(OwnVideoController());

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: widget.size.height / 3,
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.visibility,
                    color: white,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    "${widget.video['viewsCount']}",
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.thumb_up,
                      color: white,
                      size: 35,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.video['likeCount'].toString(),
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.thumb_down,
                      color: white,
                      size: 35,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.video['dislikeCount'].toString(),
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Comment(videoId: widget.video['_id']);
                        });
                  },
                  icon: const Icon(
                    Icons.comment,
                    color: white,
                    size: 35,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Obx(
                      () => Text(
                        "${ownVideoController.commentsCount.value}",
                        style: const TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ))
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: white,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    widget.video['shareCount'].toString(),
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
