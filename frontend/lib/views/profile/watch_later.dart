import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';
import 'package:pro_shorts/methods/initialize_video.dart';
import 'package:pro_shorts/views/home_screen/video_screen.dart';
import 'package:pro_shorts/views/video/own_video.dart';
import 'package:pro_shorts/views/video/view_other_video.dart';

import '../../controllers/video.dart';

class WatchLater extends StatefulWidget {
  const WatchLater({Key? key}) : super(key: key);

  @override
  State<WatchLater> createState() => _WatchLaterState();
}

class _WatchLaterState extends State<WatchLater> {
  List myWatchLaterVideos = [];

  Future fetchWatchLaterVideos() async {
    myWatchLaterVideos = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE['_id'], "watchLater");
    // return myPublicVideos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWatchLaterVideos(), // The Future<T> that you want to monitor
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the Future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if the Future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Display UI based on the successful result from the Future
          return myWatchLaterVideos.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: myWatchLaterVideos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            //  we can do this in view_other_video.dart but problem is widget is not initialized properly and we are assigning value to getx variablems so it will not assigned value properly

                            Map<String, dynamic> currentVideo =
                                await initializeVideo(myWatchLaterVideos[index]
                                    ['videoInformation']['_id']);

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
                                  "$GET_THUMBNAIL_URL/${myWatchLaterVideos[index]['videoInformation']['thumbnailName']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.watch_later,
                                  color: Colors.white,
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        minWidth: 50, minHeight: 50),
                                    child: Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            "${myWatchLaterVideos[index]['videoInformation']['viewsCount']}",
                                            style: const TextStyle(
                                                color: white, fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              : const Expanded(
                  child: Center(
                    child: Text("No any videos to watch later"),
                  ),
                );
        }
      },
    );
  }
}
