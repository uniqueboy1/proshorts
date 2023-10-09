import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/get/profile/get_profile_fetch.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';

import '../../constants.dart';
import '../../controllers/users.dart';
import '../../get/profile/get_followers_following.dart';

class FollowersFollowing extends StatelessWidget {
  bool isProfileSetup;
  FollowersFollowing({Key? key, required this.isProfileSetup})
      : super(key: key);
  FollowersFollowingController followersFollowingController =
      Get.put(FollowersFollowingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Followers and Following"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isProfileSetup
                  ? TextButton(
                      onPressed: () {
                        followersFollowingController
                            .toogleFollowersFollowing(true);
                      },
                      child: const Text("Followers"))
                  : SizedBox(),
              TextButton(
                  onPressed: () {
                    followersFollowingController
                        .toogleFollowersFollowing(false);
                  },
                  child: const Text("Following")),
            ],
          ),
          Obx(() => followersFollowingController.isFollowersClicked.value
              ? Followers()
              : Following())
        ],
      ),
    );
  }
}

class Followers extends StatelessWidget {
  Followers({Key? key}) : super(key: key);
  List followers = [];

  Future fetchFollowers() async {
    followers = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE["_id"], "followers");
  }

  @override
  Widget build(BuildContext context) {
    List followers = MYPROFILE['followers'];
    print("followers : $followers");
    return FutureBuilder(
        future: fetchFollowers(), // The Future<T> that you want to monitor
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return Text('Error: ${snapshot.error}');
          } else {
            return followers.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: followers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              followers[index]['userInformation']
                                          ['profileInformation'] !=
                                      null
                                  ? Get.to(ViewOtherProfile(
                                      userId: followers[index]['_id'],
                                    ))
                                  : null;
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundImage: followers[index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? NetworkImage(
                                                    "$getProfilePhoto/${followers[index]['userInformation']['profileInformation']['profilePhoto']}")
                                                : null),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(followers[index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? followers[index]
                                                            ['userInformation']
                                                        ['profileInformation']
                                                    ['name']
                                                : "Unknown"),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(followers[index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? followers[index]
                                                            ['userInformation']
                                                        ['profileInformation']
                                                    ['username']
                                                : "Unknown"),
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(followers[index]['userInformation']
                                                ['profileInformation'] !=
                                            null
                                        ? "${followers[index]['userInformation']['followers'].length} Followers"
                                        : "N/A")
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const Expanded(
                    child: Center(
                      child: Text("No followers"),
                    ),
                  );
          }
        });
  }
}

class Following extends StatelessWidget {
  Following({Key? key}) : super(key: key);
  FollowersFollowingController followersFollowingController =
      Get.put(FollowersFollowingController());

  Future fetchFollowing() async {
    followersFollowingController.fetchFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchFollowing(), // The Future<T> that you want to monitor
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return Text('Error: ${snapshot.error}');
          } else {
            return Obx(() => followersFollowingController.following.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount:
                            followersFollowingController.following.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(ViewOtherProfile(
                                  userId: followersFollowingController
                                      .following[index]['_id']));
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              "$getProfilePhoto/${followersFollowingController.following[index]['userInformation']['profileInformation']['profilePhoto']}"),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(followersFollowingController
                                                        .following[index]
                                                    ['userInformation']
                                                ['profileInformation']['name']),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(followersFollowingController
                                                            .following[index]
                                                        ['userInformation']
                                                    ['profileInformation']
                                                ['username'])
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                        "${followersFollowingController.following[index]['userInformation']['followers'].length} Followers"),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await UserMethods()
                                              .deleteUserArrayField(
                                                  MYPROFILE['_id'],
                                                  {
                                                    "userInformation":
                                                        followersFollowingController
                                                                    .following[
                                                                index][
                                                            'userInformation']['_id']
                                                  },
                                                  "following");
                                          await UserMethods()
                                              .deleteUserArrayField(
                                                  followersFollowingController
                                                              .following[index]
                                                          ['userInformation']
                                                      ['_id'],
                                                  {
                                                    "userInformation":
                                                        MYPROFILE['_id']
                                                  },
                                                  "followers");
                                          await fetchFollowing();
                                          //         await Get.put(OtherVideoController())
                                          // .changeFollowIcon(user['_id']);
                                        },
                                        child: const Text("Unfollow"))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const Expanded(
                    child: Center(
                      child: Text("You are not following to anyone"),
                    ),
                  ));
          }
        });
  }
}
