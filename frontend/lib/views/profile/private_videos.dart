import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';
import 'package:pro_shorts/methods/initialize_own_video.dart';
import 'package:pro_shorts/views/video/own_video.dart';

import '../../controllers/video.dart';

class PrivateVideos extends StatelessWidget {
  PrivateVideos({Key? key}) : super(key: key);
  List myPrivateVideos = [];

  Future fetchMyPrivateVideos() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    print("email : $email");
    myPrivateVideos = await VideoMethods()
        .fetchVideosByTwoField("email", email, "videoMode", "private");
    // return myPublicVideos;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMyPrivateVideos(), // The Future<T> that you want to monitor
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the Future to complete
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Display an error message if the Future throws an error
          return Text('Error: ${snapshot.error}');
        } else {
          // Display UI based on the successful result from the Future
          return myPrivateVideos.isNotEmpty
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: myPrivateVideos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            // resetting previous video description and assigning new description of video
                            await initializeOwnVideo(myPrivateVideos[index]['_id']);
                            Get.to(() => OwnVideo(
                                videoId: myPrivateVideos[index]['_id']));
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AspectRatio(
                                aspectRatio: 9 / 16,
                                child: Image.network(
                                  "$GET_THUMBNAIL_URL/${myPrivateVideos[index]['thumbnailName']}",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.lock,
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
                                            "${myPrivateVideos[index]['viewsCount']}",
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
                    child: Text("No any private videos"),
                  ),
                );
        }
      },
    );
  }
}
