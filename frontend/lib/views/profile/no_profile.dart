import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/profile/get_followers_following.dart';
import 'package:pro_shorts/views/profile/followers_following.dart';
import 'package:pro_shorts/views/profile/setup_profile_options.dart';
import 'package:pro_shorts/views/settings/settings.dart';

import '../../controllers/users.dart';

class NoProfileScreen extends StatefulWidget {
  const NoProfileScreen({Key? key}) : super(key: key);

  @override
  State<NoProfileScreen> createState() => _NoProfileScreenState();
}

class _NoProfileScreenState extends State<NoProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  dynamic myProfile;
  List following = [];
  List watchLaterVideos = [];
  Future fetchMyProfile() async {
    myProfile = await UserMethods().fetchUsersByField(
        "email", FirebaseAuth.instance.currentUser!.email.toString());
    myProfile = myProfile[0];
    following = myProfile['following'];
    watchLaterVideos = myProfile['watchLater'];
  }

  FollowersFollowingController followersFollowingController =
      Get.put(FollowersFollowingController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile Screen"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Settings()));
                  },
                  icon: const Icon(Icons.settings)),
            )
          ],
        ),
        body: FutureBuilder(
            future: fetchMyProfile(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        followersFollowingController
                            .toogleFollowersFollowing(false);
                        dynamic response = await UserMethods()
                            .fetchSpecificUserField(
                                "_id", MYPROFILE['_id'], "profileInformation");
                        response = response != null ? true : false;
                        Get.to(() => FollowersFollowing(
                              isProfileSetup: response,
                            ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Following"),
                          const SizedBox(
                            width: 20,
                          ),
                          Text("${following.length}")
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Watch Later",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    WatchLaterVideos(myWatchLaterVideos: watchLaterVideos),
                    SizedBox(
                      width: size.width * 0.9,
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => SetupProfileOptions());
                          },
                          child: const Text("Create Profile")),
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                );
              }
            }));
  }
}

class WatchLaterVideos extends StatelessWidget {
  WatchLaterVideos({Key? key, required this.myWatchLaterVideos})
      : super(key: key);
  List myWatchLaterVideos;
  @override
  Widget build(BuildContext context) {
    print("my watch later videos : $myWatchLaterVideos");
    return myWatchLaterVideos.isNotEmpty
        ? Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: myWatchLaterVideos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
}
