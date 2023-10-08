import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';
import 'package:pro_shorts/methods/initialize_own_video.dart';
import 'package:pro_shorts/views/video/own_video.dart';

import '../../controllers/video.dart';

class PublicVideos extends StatefulWidget {
  String userId;
  PublicVideos({Key? key, required this.userId}) : super(key: key);

  @override
  State<PublicVideos> createState() => _PublicVideosState();
}

class _PublicVideosState extends State<PublicVideos> {
  List myPublicVideos = [];

  Future fetchMyPublicVideos() async {
    myPublicVideos = await UserMethods()
        .fetchSpecificUserField("_id", widget.userId, "public_videos");
    print("public videos : ${myPublicVideos.length}");
  }

  @override
  Widget build(BuildContext context) {
    print("own profile button clicked");
    print("myPublicVideos : $myPublicVideos");
    return FutureBuilder(
      future: fetchMyPublicVideos(), // The Future<T> that you want to monitor
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the Future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if the Future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Display UI based on the successful result from the Future
          return myPublicVideos.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: myPublicVideos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            // resetting previous video description and assigning new description of video
                            await initializeOwnVideo(myPublicVideos[index]
                                ['videoInformation']['_id']);
                            Get.to(() => OwnVideo(
                                videoId: myPublicVideos[index]
                                    ['videoInformation']['_id']));
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AspectRatio(
                                aspectRatio: 9 / 16,
                                child: Image.network(
                                  "$GET_THUMBNAIL_URL/${myPublicVideos[index]['videoInformation']['thumbnailName']}",
                                  fit: BoxFit.cover,
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
                                            "${myPublicVideos[index]['videoInformation']['viewsCount']}",
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
                    child: Text("No any public videos"),
                  ),
                );
        }
      },
    );
  }
}
