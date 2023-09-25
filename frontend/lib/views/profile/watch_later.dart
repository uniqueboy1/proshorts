import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';
import 'package:video_player/video_player.dart';

import '../../controllers/users.dart';
import '../../controllers/video.dart';

class WatchLater extends StatefulWidget {
  const WatchLater({Key? key}) : super(key: key);

  @override
  State<WatchLater> createState() => _WatchLaterState();
}

class _WatchLaterState extends State<WatchLater> {
  List myWatchLaterVideos = [];
  Future fetchMyWatchLaterVideos() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    print("email : $email");
    myWatchLaterVideos = await UserMethods().fetchUsersByField("email", email);
    myWatchLaterVideos = myWatchLaterVideos[0]['watchLater'];
  }

  @override
  Widget build(BuildContext context) {
    print("myWatchLaterVideos : $myWatchLaterVideos");
    return FutureBuilder(
      future:
          fetchMyWatchLaterVideos(), // The Future<T> that you want to monitor
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while waiting for the Future to complete
          return Center(child: const CircularProgressIndicator());
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
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 16,
                              child: Image.network(
                                "$GET_THUMBNAIL_URL/${myWatchLaterVideos[index]['videoInformation']['thumbnailName']}",
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
                                          "${myWatchLaterVideos[index]['videoInformation']['viewsCount']}",
                                          style: const TextStyle(
                                              color: white, fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                          ],
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
