import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/methods/initialize_video.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/video/view_other_video.dart';

import '../../controllers/users.dart';
import '../../get/videos/get_watch_history.dart';

class WatchHistory extends StatefulWidget {
  const WatchHistory({Key? key}) : super(key: key);

  @override
  State<WatchHistory> createState() => _WatchHistoryState();
}

class _WatchHistoryState extends State<WatchHistory> {
  Widget showDeleteOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${watchHistoryController.selectedVideos.length} Videos Selected"),
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

  Future fetchWatchHistory() async {
    await watchHistoryController.fetchWatchHistory();
  }

  Future deleteWatchHistory() async {
    await watchHistoryController.deleteWatchHistory();
    await fetchWatchHistory();
    showSnackBar("Watch History",
        "${watchHistoryController.selectedVideos.length} videos removed from watch history");
    watchHistoryController.selectedVideos.value = [];
  }

  @override
  void initState() {
    watchHistoryController.reset();
    // TODO: implement initState
    super.initState();
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
                  watchHistoryController.changeSelect();
                },
                child: Obx(() => Text(
                      watchHistoryController.select.value,
                      style: const TextStyle(color: Colors.white),
                    ))),
            TextButton(
                onPressed: () {
                  watchHistoryController.changeSelectAll();
                },
                child: Obx(() => Text(
                      watchHistoryController.selectAll.value,
                      style: const TextStyle(color: Colors.white),
                    ))),
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
                return Obx(() => watchHistoryController.watchHistory.isNotEmpty
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Obx(
                                () => SizedBox(
                                  height: (watchHistoryController
                                              .selectedVideos.isNotEmpty ||
                                          watchHistoryController
                                              .isSelectAllClicked.value)
                                      ? size.height * 0.8
                                      : size.height * 0.87,
                                  child: GridView.builder(
                                      itemCount: watchHistoryController
                                          .watchHistory.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 10,
                                              crossAxisSpacing: 10),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            Map<String, dynamic> currentVideo =
                                                await initializeVideo(
                                                    watchHistoryController
                                                                    .watchHistory[
                                                                index]
                                                            ["videoInformation"]
                                                        ['_id']);

                                            Get.to(() => ViewOtherVideo(
                                                  video: currentVideo,
                                                ));
                                          },
                                          child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                AspectRatio(
                                                  aspectRatio: 9 / 16,
                                                  child: Image.network(
                                                    "$GET_THUMBNAIL_URL/${watchHistoryController.watchHistory[index]["videoInformation"]['thumbnailName']}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 5,
                                                    bottom: 5,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          watchHistoryController
                                                              .changeIcon(
                                                                  watchHistoryController
                                                                          .watchHistory[
                                                                      index]);
                                                        },
                                                        icon: Obx(() => Icon(
                                                              (watchHistoryController
                                                                      .isSelectAllClicked
                                                                      .value)
                                                                  ? (watchHistoryController
                                                                          .selectedVideos
                                                                          .contains(watchHistoryController.watchHistory[index]['videoInformation']
                                                                              [
                                                                              '_id'])
                                                                      ? watchHistoryController
                                                                          .checkedIcon
                                                                      : watchHistoryController
                                                                          .noCheckedIcon)
                                                                  : ((watchHistoryController
                                                                          .isSelectClicked
                                                                          .value)
                                                                      ? (watchHistoryController
                                                                              .selectedVideos
                                                                              .contains(watchHistoryController.watchHistory[index]['videoInformation']['_id'])
                                                                          ? watchHistoryController.checkedIcon
                                                                          : watchHistoryController.noCheckedIcon)
                                                                      : null),
                                                              color: white,
                                                              size: 35,
                                                            ))))
                                              ]),
                                        );
                                      }),
                                ),
                              ),
                              Obx(() => (watchHistoryController
                                      .selectedVideos.isNotEmpty)
                                  ? showDeleteOption()
                                  : const Text(""))
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
