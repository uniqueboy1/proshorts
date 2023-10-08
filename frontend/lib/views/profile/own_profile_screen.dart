import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/profile/edit_profile.dart';
import 'package:pro_shorts/views/profile/followers_following.dart';
import 'package:pro_shorts/views/settings/settings.dart';
import '../../controllers/users.dart';
import '../../controllers/video.dart';
import '../../get/profile/get_followers_following.dart';
import '../../get/profile/get_own_profile.dart';

class OwnProfileScreen extends StatefulWidget {
  const OwnProfileScreen({Key? key}) : super(key: key);

  @override
  State<OwnProfileScreen> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  dynamic myProfile = [];
  late List myVideos;

  Future countViews() async {
    String email = FirebaseAuth.instance.currentUser!.email.toString();
    myVideos = await VideoMethods()
        .fetchVideosByTwoField("email", email, "videoMode", "public");
    int totalViews = 0;
    for (Map video in myVideos) {
      // print("total views : ${video['viewsCount'].runtimeType}");
      totalViews = totalViews + int.parse(video['viewsCount'].toString());
    }
    ownProfileController.totalViews.value = totalViews;
    print("total views own profile: $totalViews");
  }

  OwnProfileController ownProfileController = Get.put(OwnProfileController());
  late String profileName;
  late String profilePhoto;
  late String username;
  late List followers;
  late List following;
  late String bio;
  late String youtubeURL;
  late String instagramURL;
  late String twitterURL;
  late String portfolioURL;
  int countSocialMedia = 0;
  Future fetchMyProfile() async {
    await countViews();
    myProfile = await UserMethods().fetchUsersByField(
        "email", FirebaseAuth.instance.currentUser!.email.toString());
    myProfile = myProfile[0];
    print("my profile : $myProfile");
    profileName = myProfile['profileInformation']['name'];
    profilePhoto =
        "$getProfilePhoto/${myProfile['profileInformation']['profilePhoto']}";
    username = myProfile['profileInformation']['username'];
    followers = myProfile['followers'];
    following = myProfile['following'];
    bio = myProfile['profileInformation']['bio'];
    youtubeURL = myProfile['profileInformation']['youtubeURL'];
    instagramURL = myProfile['profileInformation']['instagramURL'];
    twitterURL = myProfile['profileInformation']['twitterURL'];
    portfolioURL = myProfile['profileInformation']['portfolioURL'];
    if (youtubeURL.isNotEmpty) {
      countSocialMedia++;
    }
    if (instagramURL.isNotEmpty) {
      countSocialMedia++;
    }
    if (twitterURL.isNotEmpty) {
      countSocialMedia++;
    }
    if (portfolioURL.isNotEmpty) {
      countSocialMedia++;
    }
    print("count social media: $countSocialMedia");
  }

  FollowersFollowingController followersFollowingController =
      Get.put(FollowersFollowingController());

  @override
  void initState() {
    ownProfileController.reset();
    // TODO: implement initState
    super.initState();
  }

  List notifications = [];

  Future fetchNotifications() async {
    notifications = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE['_id'], "notifications");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Profile Screen"),
          leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.notification_important)),
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
        drawer: FutureBuilder(
            future:
                fetchNotifications(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return Drawer(
                    child: Column(
                  children: [
                    const DrawerHeader(
                        child: Column(
                      children: [
                        Text("Recent Notifications"),
                      ],
                    )),
                    notifications.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: ((context, index) {
                                  return ListTile(
                                      title: Text(
                                          notifications[index]['message']));
                                })),
                          )
                        : const Expanded(
                            child:
                                Center(child: Text("No any new notifications")))
                  ],
                ));
              }
            }),
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
                      height: 10,
                    ),
                    Text(
                      profileName,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(profilePhoto),
                      radius: 35,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        bio,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            followersFollowingController
                                .toogleFollowersFollowing(true);
                            dynamic response = await UserMethods()
                                .fetchSpecificUserField("_id", MYPROFILE['_id'],
                                    "profileInformation");
                            response = response != null ? true : false;
                            Get.to(() => FollowersFollowing(
                                  isProfileSetup: response,
                                ));
                          },
                          child: Column(
                            children: [
                              Text(
                                "${followers.length}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                        ),
                        GestureDetector(
                          onTap: () async {
                            followersFollowingController
                                .toogleFollowersFollowing(false);
                            dynamic response = await UserMethods()
                                .fetchSpecificUserField("_id", MYPROFILE['_id'],
                                    "profileInformation");
                            response = response != null ? true : false;

                            Get.to(() => FollowersFollowing(
                                  isProfileSetup: response,
                                ));
                          },
                          child: Column(
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
                        ),
                        Column(
                          children: [
                            Obx(
                              () => Text(
                                "${ownProfileController.totalViews.value}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
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
                    ElevatedButton(
                        onPressed: () {
                          Get.to(const EditProfileOptions());
                        },
                        child: const Text("Edit Profile")),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: countSocialMedia >= 2
                          ? MainAxisAlignment.spaceAround
                          : MainAxisAlignment.center,
                      children: [
                        Offstage(
                            offstage: youtubeURL.isEmpty,
                            child: IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.youtube))),
                        Offstage(
                            offstage: instagramURL.isEmpty,
                            child: IconButton(
                                onPressed: () {},
                                icon:
                                    const FaIcon(FontAwesomeIcons.instagram))),
                        Offstage(
                            offstage: twitterURL.isEmpty,
                            child: IconButton(
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.twitter))),
                        Offstage(
                            offstage: portfolioURL.isEmpty,
                            child: ElevatedButton(
                                onPressed: () {}, child: const Text("HIRE ME")))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            tooltip: "Public Videos",
                            onPressed: () {
                              ownProfileController.changeVideoScreen(0);
                            },
                            icon: Obx(() => Icon(Icons.public,
                                color: ownProfileController
                                            .visibilityIndex.value ==
                                        0
                                    ? Colors.red
                                    : Colors.black))),
                        IconButton(
                            tooltip: "Private Videos",
                            onPressed: () {
                              ownProfileController.changeVideoScreen(1);
                            },
                            icon: Obx(() => Icon(
                                  Icons.lock,
                                  color: ownProfileController
                                              .visibilityIndex.value ==
                                          1
                                      ? Colors.red
                                      : Colors.black,
                                ))),
                        IconButton(
                            tooltip: "Watch Later",
                            onPressed: () {
                              ownProfileController.changeVideoScreen(2);
                            },
                            icon: Obx(() => Icon(
                                  Icons.watch_later,
                                  color: ownProfileController
                                              .visibilityIndex.value ==
                                          2
                                      ? Colors.red
                                      : Colors.black,
                                ))),
                      ],
                    ),
                    // here due to same index value even if i click button twice so it is not rebuilding widget again so use this
                    Obx(() => KeyedSubtree(
                        key: UniqueKey(),
                        child: ownProfileController.isButtonClicked.value
                            ? videoVisibility[
                                ownProfileController.visibilityIndex.value]
                            : videoVisibility[
                                ownProfileController.visibilityIndex.value]))
                  ],
                );
              }
            }));
  }
}
