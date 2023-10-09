import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/home_screen/get_home_screen.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/get/profile/get_profile_fetch.dart';
import 'package:pro_shorts/views/home_screen/video_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavBar = 0;
  HomeScreenController homeScreenController = Get.put(HomeScreenController());
  List allVideos = [];
  Future fetchFollowingVideos() async {
    allVideos = await VideoMethods().fetchFollowingVideos(MYPROFILE['_id']);
    isFirstVideoInitialized = false;
  }

  Future fetchPublicVideos() async {
    allVideos = await VideoMethods().fetchVideosByField("videoMode", "public");
    isFirstVideoInitialized = false;
  }

// to call initializeVideoDetails for once
  bool isFirstVideoInitialized = false;
  Future initializeVideo(Map<String, dynamic> video, int index) async {
    await Get.put(VideoScreenController()).initializeVideo(video);
    if (index == 0 && !isFirstVideoInitialized) {
      currentVideoId = video['_id'];
      currentVideoUserId = video['userInformation']["_id"];
      isFirstVideoInitialized = true;
      print("first video");
      initializeVideoDetails(video);
    }
  }

  void initializeVideoDetails(Map<String, dynamic> video) {
    Get.put(VideoScreenController()).initializeVideoDetails(video);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          elevation: 0,
          actions: [
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        isFirstVideoInitialized = false;
                        homeScreenController.changeForYou("following");
                      },
                      child: Obx(() => Text(
                            "Following",
                            style: TextStyle(
                              color: white,
                              decoration: homeScreenController.forYou.value ==
                                      "following"
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ))),
                  TextButton(
                      onPressed: () {
                        isFirstVideoInitialized = false;
                        homeScreenController.changeForYou("foryou");
                      },
                      child: Obx(() => Text(
                            "For You",
                            style: TextStyle(
                                decoration: homeScreenController.forYou.value ==
                                        "foryou"
                                    ? TextDecoration.underline
                                    : TextDecoration.none,
                                color: white),
                          ))),
                  IconButton(
                      onPressed: () {
                        Get.put(VideoScreenController()).controller.pause();
                        Get.toNamed("/search");
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              Get.put(VideoScreenController()).controller.pause();

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => bottomNavBar[index]));
            },
            currentIndex: selectedNavBar,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: "Add Video"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
        body: Obx(() => FutureBuilder(
            future: homeScreenController.forYou.value == "foryou"
                ? fetchPublicVideos()
                : fetchFollowingVideos(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return allVideos.isNotEmpty
                    ? PageView.builder(
                        onPageChanged: (value) {
                          Get.put(VideoScreenController())
                              .initializeVideoDetails(allVideos[value]);
                          currentVideoId = allVideos[value]['_id'];
                          currentVideoUserId =
                              allVideos[value]['userInformation']["_id"];
                        },
                        scrollDirection: Axis.vertical,
                        itemCount: allVideos.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: initializeVideo(allVideos[index], index),
                              // The Future<T> that you want to monitor
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Display a loading indicator while waiting for the Future to complete
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  // Display an error message if the Future throws an error
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  return AspectRatio(
                                    aspectRatio: 9 / 16,
                                    child: VideoScreen(
                                      video: allVideos[index],
                                    ),
                                  );
                                }
                              });
                        })
                    : const Center(child: Text("No any videos"));
              }
            })));
  }
}
