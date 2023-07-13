import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/constants.dart';
import 'package:video_player/video_player.dart';

class WatchHistory extends StatefulWidget {
  WatchHistory({Key? key}) : super(key: key);

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  final controller = VideoPlayerController.asset("assets/videos/video.mp4")
    ..initialize();
  bool isSelectClicked = false;
  bool isSelectAllClicked = false;
  String selectAll = "Select All";
  String select = "Select";
  IconData checkedIcon = FontAwesomeIcons.solidCircleCheck;
  IconData noCheckedIcon = Icons.circle_outlined;
  List selectedVideos = [];
  int watchedVideos = 20;

  Widget showDeleteOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${selectedVideos.length} Videos Selected"),
        ElevatedButton(onPressed: () {}, child: Text("Clear Watch History"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watch History"),
        actions: [
          TextButton(
              onPressed: () {
                isSelectClicked = !isSelectClicked;
                isSelectAllClicked = false;
                selectedVideos = [];
                if (isSelectClicked) {
                  select = "Cancel";
                } else {
                  select = "Select";
                }
                selectAll = "Select All";
                setState(() {});
              },
              child: Text(
                select,
                style: TextStyle(color: Colors.white),
              )),
          TextButton(
              onPressed: () {
                isSelectAllClicked = !isSelectAllClicked;
                isSelectClicked = false;
                selectedVideos = [];
                if (isSelectAllClicked) {
                  for (var i = 0; i < watchedVideos; i++) {
                    selectedVideos.add(i);
                  }
                  selectAll = "Deselect All";
                } else {
                  selectAll = "Select All";
                }

                select = "Select";
                setState(() {});
              },
              child: Text(
                selectAll,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: (selectedVideos.isNotEmpty || isSelectAllClicked) ? size.height * 0.8 : size.height * 0.87,
                child: GridView.builder(
                    itemCount: 20,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            border: (isSelectClicked || isSelectAllClicked)
                                ? Border.all(color: Colors.blue, width: 3)
                                : null,
                          ),
                          width: 200,
                          height: 200,
                          child: VideoPlayer(controller),
                        ),
                        Positioned(
                            right: 5,
                            bottom: 5,
                            child: IconButton(
                                onPressed: () {
                                  if (isSelectAllClicked) {
                                    if (selectedVideos.contains(index)) {
                                      selectedVideos.remove(index);
                                    } else {
                                      selectedVideos.add(index);
                                    }
                                  } else if (isSelectClicked) {
                                    if (selectedVideos.contains(index)) {
                                      selectedVideos.remove(index);
                                    } else {
                                      selectedVideos.add(index);
                                    }
                                  }
          
                                  setState(() {});
                                },
                                icon: Icon(
                                  (isSelectClicked)
                                      ? (selectedVideos.contains(index)
                                          ? checkedIcon
                                          : noCheckedIcon)
                                      : ((isSelectAllClicked)
                                          ? (selectedVideos.contains(index)
                                              ? checkedIcon
                                              : noCheckedIcon)
                                          : null),
                                  color: white,
                                  size: 35,
                                )))
                      ]);
                    }),
              ),
              (selectedVideos.isNotEmpty || isSelectAllClicked)
                  ? showDeleteOption()
                  : Text("")
                    
            ],
          ),
        ),
      ),
    );
  }
}
