import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';

import '../../controllers/users.dart';
import '../../get/videos/get_watch_history.dart';

class WatchHistory extends StatefulWidget {
  const WatchHistory({Key? key}) : super(key: key);

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  bool isSelectClicked = false;
  bool isSelectAllClicked = false;
  String selectAll = "Select All";
  String select = "Select";
  IconData checkedIcon = FontAwesomeIcons.solidCircleCheck;
  IconData noCheckedIcon = Icons.circle_outlined;
  List selectedVideos = [];

  Widget showDeleteOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${selectedVideos.length} Videos Selected"),
        ElevatedButton(
            onPressed: () {
              deleteWatchHistory();
            },
            child: const Text("Clear Watch History"))
      ],
    );
  }

  WatchHistoryController watchHistoryController =
      Get.put(WatchHistoryController());

  List watchHistory = [];
  dynamic userInformation;
  Future fetchWatchHistory() async {
    userInformation =
        await UserMethods().fetchUsersByField("email", LOGIN_EMAIL.toString());
    userInformation = userInformation[0];
    watchHistory = userInformation['watchHistory'];
    watchHistoryController.deleteWatchHistory(watchHistory.length);
  }

  Future deleteWatchHistory() async {
    // Filter out items based on the condition
    watchHistory = watchHistory
        .where(
            (item) => !selectedVideos.contains(item["videoInformation"]["_id"]))
        .toList();
    await UserMethods()
        .editUser(userInformation['_id'], {"watchHistory": watchHistory});
    Get.snackbar("Watch History",
        "${selectedVideos.length} videos removed from watch history");
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
                  style: const TextStyle(color: Colors.white),
                )),
            TextButton(
                onPressed: () {
                  isSelectAllClicked = !isSelectAllClicked;
                  isSelectClicked = false;
                  selectedVideos = [];
                  if (isSelectAllClicked) {
                    for (var i = 0; i < watchHistory.length; i++) {
                      selectedVideos
                          .add(watchHistory[i]['videoInformation']['_id']);
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
        body: FutureBuilder(
            future:
                fetchWatchHistory(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return Obx(() => watchHistoryController.noOfWatchHistory.value >
                        0
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: (selectedVideos.isNotEmpty ||
                                        isSelectAllClicked)
                                    ? size.height * 0.8
                                    : size.height * 0.87,
                                child: GridView.builder(
                                    itemCount: watchHistoryController
                                        .noOfWatchHistory.value,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10),
                                    itemBuilder: (context, index) {
                                      return Stack(children: [
                                        AspectRatio(
                                          aspectRatio: 9 / 16,
                                          child: Image.network(
                                            "$GET_THUMBNAIL_URL/${watchHistory[index]["videoInformation"]['thumbnailName']}",
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                            right: 5,
                                            bottom: 5,
                                            child: IconButton(
                                                onPressed: () {
                                                  if (isSelectAllClicked) {
                                                    if (selectedVideos.contains(
                                                        watchHistory[index][
                                                                'videoInformation']
                                                            ['_id'])) {
                                                      selectedVideos
                                                          .remove(index);
                                                    } else {
                                                      selectedVideos.add(
                                                          watchHistory[index][
                                                                  'videoInformation']
                                                              ['_id']);
                                                    }
                                                  } else if (isSelectClicked) {
                                                    if (selectedVideos.contains(
                                                        watchHistory[index][
                                                                'videoInformation']
                                                            ['_id'])) {
                                                      selectedVideos.remove(
                                                          watchHistory[index][
                                                                  'videoInformation']
                                                              ['_id']);
                                                    } else {
                                                      selectedVideos.add(
                                                          watchHistory[index][
                                                                  'videoInformation']
                                                              ['_id']);
                                                    }
                                                  }

                                                  setState(() {});
                                                },
                                                icon: Icon(
                                                  (isSelectClicked)
                                                      ? (selectedVideos.contains(
                                                              watchHistory[
                                                                          index]
                                                                      [
                                                                      'videoInformation']
                                                                  ['_id'])
                                                          ? checkedIcon
                                                          : noCheckedIcon)
                                                      : ((isSelectAllClicked)
                                                          ? (selectedVideos.contains(
                                                                  watchHistory[
                                                                          index]
                                                                      [
                                                                      'videoInformation']['_id'])
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
                                  : const Text("")
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: Text("No watch history"),
                      ));
              }
            }));
  }
}
