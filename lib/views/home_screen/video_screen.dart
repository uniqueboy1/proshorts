import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/views/home_screen/make_notes.dart';
import 'package:pro_shorts/views/home_screen/search.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';
import 'package:pro_shorts/views/home_screen/comment.dart';
import 'package:video_player/video_player.dart';

import '../../get/home_screen/get_select_video.dart';

enum ReportReason {
  notProgramming,
  hateHarrasement,
  nuditySexual,
  misinformation
}

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoScreenController videoScreenController;
  @override
  void initState() {
    super.initState();
    videoScreenController = Get.put(VideoScreenController());
  }

  @override
  void dispose() {
    super.dispose();
    // videoScreenController.controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // videoScreenController.playVideo();
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return ReportWatchLater();
            });
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Stack(children: [
          Center(
            child: AspectRatio(
              // aspectRatio: videoScreenController.controller.value.aspectRatio,
              aspectRatio: 9/16,
              child: GestureDetector(
                onTap: (){
                  videoScreenController.showPlayPauseIcon();
                },
                child: VideoPlayer(videoScreenController.controller)),
            ),
          ),
          Obx(
            () => !videoScreenController.isVideoPlaying.value
                ? Center(
                    child: Icon(
                    Icons.play_arrow,
                    color: white,
                    size: 50,
                  ))
                : SizedBox(),
          ),
          UserAndVideoDetails(
            size: size,
          ),
          InteractOptions(
            size: size,
          )
        ]),
      ),
    );
  }
}

class ReportWatchLater extends StatelessWidget {
  ReportWatchLater({Key? key}) : super(key: key);
  final ReportReason? selectedReportReason = ReportReason.notProgramming;
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Select Options"),
      children: [
        const SimpleDialogOption(
          child: Card(
            child: ListTile(
              title: Text("Watch Later"),
              leading: Icon(Icons.watch_later),
            ),
          ),
        ),
        SimpleDialogOption(
          child: Card(
            child: ListTile(
              onTap: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return ReportVideo();
                    });
              },
              title: const Text("Report"),
              leading: const Icon(Icons.report),
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
}

class ReportVideo extends StatefulWidget {
  ReportVideo({Key? key}) : super(key: key);

  @override
  State<ReportVideo> createState() => _ReportVideoState();
}

class _ReportVideoState extends State<ReportVideo> {
  ReportReason? selectedReportReason = ReportReason.notProgramming;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Select a Reason"),
      children: [
        SimpleDialogOption(
            child: RadioListTile(
                title: const Text("Videos not related to programming"),
                value: ReportReason.notProgramming,
                groupValue: selectedReportReason,
                onChanged: (ReportReason? value) {
                  setState(() {
                    selectedReportReason = value;
                  });
                })),
        SimpleDialogOption(
            child: RadioListTile(
                title: const Text("Hate and Harrasement"),
                value: ReportReason.hateHarrasement,
                groupValue: selectedReportReason,
                onChanged: (ReportReason? value) {
                  setState(() {
                    selectedReportReason = value;
                  });
                })),
        SimpleDialogOption(
            child: RadioListTile(
                title: const Text("Nudity and sexual content"),
                value: ReportReason.nuditySexual,
                groupValue: selectedReportReason,
                onChanged: (ReportReason? value) {
                  setState(() {
                    selectedReportReason = value;
                  });
                })),
        SimpleDialogOption(
            child: RadioListTile(
                title: const Text("Misinformation"),
                value: ReportReason.misinformation,
                groupValue: selectedReportReason,
                onChanged: (ReportReason? value) {
                  setState(() {
                    selectedReportReason = value;
                  });
                })),
        SimpleDialogOption(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  final snackBar = SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: Colors.green,
                    elevation: 72,
                    content: const Center(
                      child: Text('Video Reported Successfully'),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
  UserAndVideoDetails({Key? key, required this.size}) : super(key: key);

  @override
  State<UserAndVideoDetails> createState() => _UserAndVideoDetailsState();
}

class _UserAndVideoDetailsState extends State<UserAndVideoDetails> {
  IconData followIcon = Icons.add;
  String videoDescription = "this is the little description";
  bool isSeeMoreClicked = false;
  String seeMore = "SEE MORE";
  @override
  Widget build(BuildContext context) {
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewOtherProfile()));
                    },
                    child: const CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(logo),
                      backgroundColor: green,
                    ),
                  ),
                  Positioned(
                      left: 35,
                      top: 6.5,
                      child: GestureDetector(
                        onTap: () {
                          if (followIcon == Icons.add) {
                            followIcon = Icons.check;
                          } else {
                            followIcon = Icons.add;
                          }
                          setState(() {});
                        },
                        child: CircleAvatar(
                            radius: 13,
                            backgroundColor: red,
                            child: Icon(
                              followIcon,
                              size: 26,
                              color: white,
                            )),
                      )),
                  Positioned(
                      left: 75,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewOtherProfile()));
                        },
                        child: const Text(
                          "username",
                          style: TextStyle(
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
            const Text(
              "this is the title of the video",
              style: TextStyle(
                  color: white, fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    videoDescription,
                    style: const TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    isSeeMoreClicked = !isSeeMoreClicked;
                    if (isSeeMoreClicked) {
                      seeMore = "SEE LESS";
                      videoDescription =
                          "this is the very long long long long video description this is the little descriptionthis is the little descriptionthis is the little descriptionthis is the little description";
                    } else {
                      seeMore = "SEE MORE";
                      videoDescription = "this is the little description";
                    }
                    setState(() {});
                  },
                  child: Text(
                    seeMore,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InteractOptions extends StatelessWidget {
  final Size size;
  InteractOptions({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 10,
      top: size.height / 3,
      child: SizedBox(
        height: 370,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: const [
                Icon(
                  Icons.thumb_up,
                  color: white,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "200K",
                    style: TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                Icon(
                  Icons.thumb_down,
                  color: white,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "200K",
                    style: TextStyle(
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
                          return Comment();
                        });
                  },
                  icon: const Icon(
                    Icons.comment,
                    color: white,
                    size: 35,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "200",
                    style: TextStyle(
                        color: white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Column(
              children: const [
                Icon(
                  Icons.share,
                  color: white,
                  size: 35,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    "200",
                    style: TextStyle(
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
