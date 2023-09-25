import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/views/home_screen/make_notes.dart';
import 'package:pro_shorts/views/home_screen/comment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/video.dart';

class VideoScreen extends StatefulWidget {
  Map<String, dynamic> video;
  VideoScreen({Key? key, required this.video}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoScreenController videoScreenController;
  @override
  void initState() {
    videoScreenController = Get.put(VideoScreenController());
    // videoScreenController.initializeVideoDetails(widget.video);
    super.initState();
  }

  //  @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   videoScreenController.initializeVideoDetails(widget.video);
  // }

  @override
  void dispose() {
    super.dispose();
    // videoScreenController.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // videoScreenController.playVideo();

    Size size = MediaQuery.of(context).size;
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight = AppBar().preferredSize.height;
    return GestureDetector(
      onLongPress: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return ReportWatchLater(
                video: widget.video,
              );
            });
      },
      child: Container(
        color: Colors.black,
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Center(
            child: AspectRatio(
              aspectRatio: videoScreenController.controller.value.aspectRatio,
              // aspectRatio: 9 / 16,
              child: GestureDetector(
                  onTap: () {
                    videoScreenController.showPlayPauseIcon();
                  },
                  child: VideoPlayer(videoScreenController.controller)),
            ),
          ),
          Obx(
            () => !videoScreenController.isVideoPlaying.value
                ? const Center(
                    child: Icon(
                    Icons.play_arrow,
                    color: white,
                    size: 50,
                  ))
                : const SizedBox(),
          ),
          UserAndVideoDetails(
            video: widget.video,
            size: size,
          ),
          InteractOptions(
            video: widget.video,
            size: size,
          ),
        ]),
      ),
    );
  }
}

class ReportWatchLater extends StatelessWidget {
  Map<String, dynamic> video;
  ReportWatchLater({Key? key, required this.video}) : super(key: key);
  final ReportReason? selectedReportReason = ReportReason.notProgramming;
  bool isWatchLaterIDExists = false;

  Future fetchWatchLater() async {
    await fetchReportMessage();
    String id = video['_id'];
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    List watchLater = await UserMethods()
        .fetchSpecificUserField("email", email, "watchLater");
    print("watch later : $watchLater");
    isWatchLaterIDExists =
        watchLater.any((video) => video['videoInformation'] == id);
  }

  void addToWatchLater() async {
    // user can only add same video to watch later once
    String id = video['_id'];
    Map<String, dynamic> videoInformation = {"videoInformation": id};
    if (!isWatchLaterIDExists) {
      await UserMethods()
          .editUserArrayField(MYPROFILE['_id'], videoInformation, "watchLater");
      Get.snackbar("Watch Later", "Video added to watch later");
    } else {
      await UserMethods().deleteUserArrayField(
          MYPROFILE['_id'], videoInformation, "watchLater");
      Get.snackbar("Watch Later", "Video removed from watch later");
    }
  }

  bool isReportMessageIDExists = false;
  Future fetchReportMessage() async {
    String id = video['_id'];
    List reportMessage = await VideoMethods()
        .fetchSpecificVideosField("_id", id, "reportMessage");
    isReportMessageIDExists = reportMessage
        .any((user) => user['userInformation'] == MYPROFILE['_id']);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchWatchLater(), // The Future<T> that you want to monitor
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return Text('Error: ${snapshot.error}');
          } else {
            return SimpleDialog(
              title: const Text("Select Options"),
              children: [
                SimpleDialogOption(
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        addToWatchLater();
                        Get.back();
                      },
                      title: const Text("Watch Later"),
                      leading: const Icon(Icons.watch_later),
                      trailing: isWatchLaterIDExists
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        if (!isReportMessageIDExists) {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return ReportVideo(
                                  video: video,
                                );
                              });
                        }
                      },
                      title: const Text("Report"),
                      leading: const Icon(Icons.report),
                      trailing: isReportMessageIDExists
                          ? const Icon(
                              Icons.check,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                  ),
                ),
                SimpleDialogOption(
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Get.to(MakeNotes());
                      },
                      title: const Text("Make Notes"),
                      leading: const Icon(Icons.notes),
                    ),
                  ),
                ),
                SimpleDialogOption(
                  child: Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      title: const Text("Cancel"),
                      leading: const Icon(Icons.cancel),
                    ),
                  ),
                )
              ],
            );
          }
        });
  }
}

class ReportVideo extends StatefulWidget {
  Map<String, dynamic> video;
  ReportVideo({Key? key, required this.video}) : super(key: key);

  @override
  State<ReportVideo> createState() => _ReportVideoState();
}

class _ReportVideoState extends State<ReportVideo> {
  VideoScreenController videoScreenController =
      Get.put(VideoScreenController());

  void reportVideo() async {
    String id = widget.video['_id'];
    Map<String, dynamic> reportMessage = {
      "userInformation": MYPROFILE['_id'],
      "message": "${videoScreenController.selectedReportReason.value}"
    };
    await VideoMethods()
        .editVideoArrayField(id, reportMessage, "reportMessage");
    Get.snackbar("Report Video", "Video reported successfully");
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Select a Reason"),
      children: [
        SimpleDialogOption(
            child: Obx(() => RadioListTile(
                title: const Text("Videos not related to programming"),
                value: ReportReason.notProgramming,
                groupValue: videoScreenController.selectedReportReason.value,
                onChanged: (ReportReason? value) {
                  videoScreenController.updateReportReason(value!);
                }))),
        SimpleDialogOption(
            child: Obx(() => RadioListTile(
                title: const Text("Hate and Harrasement"),
                value: ReportReason.hateHarrasement,
                groupValue: videoScreenController.selectedReportReason.value,
                onChanged: (ReportReason? value) {
                  videoScreenController.updateReportReason(value!);
                }))),
        SimpleDialogOption(
            child: Obx(() => RadioListTile(
                title: const Text("Nudity and sexual content"),
                value: ReportReason.nuditySexual,
                groupValue: videoScreenController.selectedReportReason.value,
                onChanged: (ReportReason? value) {
                  videoScreenController.updateReportReason(value!);
                }))),
        SimpleDialogOption(
            child: Obx(() => RadioListTile(
                title: const Text("Misinformation"),
                value: ReportReason.misinformation,
                groupValue: videoScreenController.selectedReportReason.value,
                onChanged: (ReportReason? value) {
                  videoScreenController.updateReportReason(value!);
                }))),
        SimpleDialogOption(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  reportVideo();
                  Navigator.popUntil(context, (route) => route.isFirst);

                  // final snackBar = SnackBar(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10.0),
                  //   ),
                  //   backgroundColor: Colors.green,
                  //   elevation: 72,
                  //   content: const Center(
                  //     child: Text('Video Reported Successfully'),
                  //   ),
                  // );
                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: const Text("Submit")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"))
          ],
        )),
      ],
    );
  }
}

class UserAndVideoDetails extends StatefulWidget {
  final Size size;
  Map<String, dynamic> video;
  UserAndVideoDetails({Key? key, required this.size, required this.video})
      : super(key: key);

  @override
  State<UserAndVideoDetails> createState() => _UserAndVideoDetailsState();
}

class _UserAndVideoDetailsState extends State<UserAndVideoDetails> {
  VideoScreenController videoScreenController =
      Get.put(VideoScreenController());

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
                  GestureDetector(
                    onTap: () {
                      // Get.to(() => ViewOtherProfile(userInformation: userInformation));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(profilePhoto),
                      backgroundColor: green,
                    ),
                  ),
                  Positioned(
                      left: 35,
                      top: 6.5,
                      child: GestureDetector(
                        onTap: () {
                          videoScreenController.updateFollowIcon(
                              widget.video['userInformation']['_id']);
                        },
                        child: CircleAvatar(
                            radius: 13,
                            backgroundColor: red,
                            child: Obx(() => Icon(
                                  videoScreenController.followIcon.value,
                                  size: 26,
                                  color: white,
                                ))),
                      )),
                  Positioned(
                      left: 75,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          // Get.to(() => ViewOtherProfile(userInformation: userInformation));
                        },
                        child: Text(
                          username,
                          style: const TextStyle(
                              color: white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold),
                        ),
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
                    videoScreenController.videoDescription.value,
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )),
                Obx(() =>
                    videoScreenController.videoDescription.value.length >= 25
                        ? TextButton(
                            onPressed: () {
                              videoScreenController.toogleSeeMore(widget.video);
                            },
                            child: Text(
                              videoScreenController.seeMore.value,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
  final Size size;
  Map<String, dynamic> video;
  InteractOptions({Key? key, required this.size, required this.video})
      : super(key: key);

  @override
  State<InteractOptions> createState() => _InteractOptionsState();
}

class _InteractOptionsState extends State<InteractOptions> {
  VideoScreenController videoScreenController =
      Get.put(VideoScreenController());

  void openGmail() async {
    try {
      String? encodeQueryParameters(Map<String, String> params) {
        return params.entries
            .map((MapEntry<String, String> e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&');
      }

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'smith@example.com',
        query: encodeQueryParameters(<String, String>{
          'subject': 'Video from ProShorts',
          "body": "Watch this video and share with your friends"
        }),
      );
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        Get.snackbar("Gmail", "Unable to open Gmail");
      }
    } catch (error) {
      print("Error occurred while opening Gmail : $error");
    }
  }

  void openMessenger() {}

  void openWhatsApp() {}

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: widget.size.height / 3,
      child: SizedBox(
        height: 370,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () => Column(
                children: [
                  IconButton(
                      onPressed: () {
                        print("like clicked");
                        videoScreenController.changeLike(widget.video['_id']);
                      },
                      icon: Icon(
                        Icons.thumb_up,
                        color: videoScreenController.likeButtonColor,
                        size: 35,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoScreenController.likeCount.value.toString(),
                      style: const TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Column(
                children: [
                  IconButton(
                      onPressed: () {
                        print("dislike clicked");
                        videoScreenController
                            .changeDislike(widget.video['_id']);
                      },
                      icon: Icon(
                        Icons.thumb_down,
                        color: videoScreenController.dislikeButtonColor,
                        size: 35,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      videoScreenController.dislikeCount.value.toString(),
                      style: const TextStyle(
                          color: white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Comment(videoId: widget.video["_id"]);
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
                        "${videoScreenController.commentsCount.value}",
                        style: const TextStyle(
                            color: white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16.0)),
                        ),
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          print("open gmail");
                                          openGmail();
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.envelope)),
                                    const Text("Gmail")
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          openMessenger();
                                        },
                                        icon: const Icon(FontAwesomeIcons
                                            .facebookMessenger)),
                                    const Text("Messenger")
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          openWhatsApp();
                                        },
                                        icon: const Icon(
                                            FontAwesomeIcons.whatsapp)),
                                    const Text("WhatsApp")
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.share,
                    color: white,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    videoScreenController.shareCount.value.toString(),
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
