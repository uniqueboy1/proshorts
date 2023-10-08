import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/get/profile/get_other_profile.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';

class ViewOtherProfile extends StatefulWidget {
  final String userId;
  const ViewOtherProfile({Key? key, required this.userId}) : super(key: key);

  @override
  State<ViewOtherProfile> createState() => _ViewOtherProfileState();
}

class _ViewOtherProfileState extends State<ViewOtherProfile> {
  int totalViews = 0;
  Future countViews() async {
    List publicVideos = await UserMethods()
        .fetchSpecificUserField("_id", widget.userId, "public_videos");
    for (Map video in publicVideos) {
      totalViews +=
          int.parse(video['videoInformation']['viewsCount'].toString());
    }
    return totalViews;
  }

  late Map<String, dynamic> profileInformation;
  late List followers;
  late List following;
  Map<String, dynamic> user = {};
  Future fetchUser() async {
    user = await otherProfileController.fetchUser(widget.userId);
    profileInformation = user['profileInformation'];
    following = user['following'];
    await countViews();
  }

  OtherProfileController otherProfileController =
      Get.put(OtherProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile Screen"),
        ),
        body: FutureBuilder(
            future: fetchUser(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      profileInformation['name'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          "$getProfilePhoto/${profileInformation['profilePhoto']}"),
                      radius: 35,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      profileInformation['username'],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        profileInformation['bio'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Obx(
                              () => Text(
                                "${otherProfileController.followers.length}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Followers",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "${following.length}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Following",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "$totalViews",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Total Views",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await otherProfileController
                                  .updateFollowText(user['_id']);
                              // updating follow or not in video screen (main screen)
                              await Get.put(VideoScreenController())
                                  .isFollowing(user['_id']);
                              Get.put(VideoScreenController())
                                  .changeFollowIcon();

                              // updating follow or not in video screen (individual video screen)
                              await Get.put(OtherVideoController())
                                  .changeFollowIcon(user['_id']);
                            },
                            child: Obx(() =>
                                Text(otherProfileController.followText.value))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Offstage(
                                offstage:
                                    profileInformation['youtubeURL'].isEmpty,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const FaIcon(
                                        FontAwesomeIcons.youtube))),
                            Offstage(
                                offstage:
                                    profileInformation['instagramURL'].isEmpty,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const FaIcon(
                                        FontAwesomeIcons.instagram))),
                            Offstage(
                                offstage:
                                    profileInformation['twitterURL'].isEmpty,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const FaIcon(
                                        FontAwesomeIcons.twitter))),
                            Offstage(
                                offstage:
                                    profileInformation['portfolioURL'].isEmpty,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    child: const Text("HIRE ME")))
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Uploaded Videos"),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    PublicVideos(userId: widget.userId)
                  ],
                );
              }
            }));
  }
}
