import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/videos/get_watch_later.dart';
import 'package:pro_shorts/methods/initialize_video.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';
import 'package:pro_shorts/views/video/view_other_video.dart';

class WatchLaterHistory extends StatefulWidget {
  const WatchLaterHistory({Key? key}) : super(key: key);

  @override
  State<WatchLaterHistory> createState() => _WatchLaterHistoryState();
}

class _WatchLaterHistoryState extends State<WatchLaterHistory> {
  Widget showDeleteOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${watchLaterController.selectedVideos.length} Videos Selected"),
        ElevatedButton(
            onPressed: () {
              deleteWatchHistory();
            },
            child: const Text("Clear Watch Later"))
      ],
    );
  }

  WatchLaterController watchLaterController = Get.put(WatchLaterController());

  Future fetchWatchLater() async {
    await watchLaterController.fetchWatchLater();
  }

  Future deleteWatchHistory() async {
    await watchLaterController.deleteWatchLater();
    await fetchWatchLater();
    showSnackBar("Watch History",
        "${watchLaterController.selectedVideos.length} videos removed from watch later");
    // after removing videos selected videos is empty
    watchLaterController.selectedVideos.value = [];
  }

  @override
  void initState() {
    // resetting all the observables to their default values
    watchLaterController.reset();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text("Watch Later"),
          actions: [
            TextButton(
                onPressed: () {
                  watchLaterController.changeSelect();
                },
                child: Obx(() => Text(
                      watchLaterController.select.value,
                      style: const TextStyle(color: Colors.white),
                    ))),
            TextButton(
                onPressed: () {
                  watchLaterController.changeSelectAll();
                },
                child: Obx(() => Text(
                      watchLaterController.selectAll.value,
                      style: const TextStyle(color: Colors.white),
                    ))),
          ],
        ),
        body: FutureBuilder(
            future: fetchWatchLater(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return Obx(() => watchLaterController.watchLater.isNotEmpty
                    ? SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Obx(
                                () => SizedBox(
                                  height: (watchLaterController
                                              .selectedVideos.isNotEmpty ||
                                          watchLaterController
                                              .isSelectAllClicked.value)
                                      ? size.height * 0.8
                                      : size.height * 0.87,
                                  child: GridView.builder(
                                      itemCount: watchLaterController
                                          .watchLater.length,
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
                                                    watchLaterController
                                                                    .watchLater[
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
                                                    "$GET_THUMBNAIL_URL/${watchLaterController.watchLater[index]["videoInformation"]['thumbnailName']}",
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                    right: 5,
                                                    bottom: 5,
                                                    child: IconButton(
                                                        onPressed: () {
                                                          watchLaterController
                                                              .changeIcon(
                                                                  watchLaterController
                                                                          .watchLater[
                                                                      index]);
                                                        },
                                                        icon: Obx(() => Icon(
                                                              (watchLaterController
                                                                      .isSelectAllClicked
                                                                      .value)
                                                                  ? (watchLaterController
                                                                          .selectedVideos
                                                                          .contains(watchLaterController.watchLater[index]['videoInformation']
                                                                              [
                                                                              '_id'])
                                                                      ? watchLaterController
                                                                          .checkedIcon
                                                                      : watchLaterController
                                                                          .noCheckedIcon)
                                                                  : ((watchLaterController
                                                                          .isSelectClicked
                                                                          .value)
                                                                      ? (watchLaterController
                                                                              .selectedVideos
                                                                              .contains(watchLaterController.watchLater[index]['videoInformation']['_id'])
                                                                          ? watchLaterController.checkedIcon
                                                                          : watchLaterController.noCheckedIcon)
                                                                      : null),
                                                              color: white,
                                                              size: 35,
                                                            ))))
                                              ]),
                                        );
                                      }),
                                ),
                              ),
                              Obx(() => (watchLaterController
                                      .selectedVideos.isNotEmpty)
                                  ? showDeleteOption()
                                  : const Text(""))
                            ],
                          ),
                        ),
                      )
                    : const Center(
                        child: Text("No any videos to watch later"),
                      ));
              }
            }));
  }
}
