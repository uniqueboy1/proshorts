import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/methods/initialize_own_video.dart';
import 'package:pro_shorts/methods/initialize_video.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';
import "package:pro_shorts/get/home_screen/get_search.dart";
import 'package:pro_shorts/views/video/own_video.dart';
import 'package:pro_shorts/views/video/view_other_video.dart';
import '../../constants.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchVideoUserController searchController =
      Get.put(SearchVideoUserController());
  TextEditingController searchKeywordsController = TextEditingController();

  @override
  void initState() {
    // resetting all the operations performed by users
    searchController.isTopVideos(true);
    searchController.changeVideo("", "closeIcon");
    searchController.changeUser("", "closeIcon");
    searchController.isInputChanged.value = false;
    // TODO: implement initState
    super.initState();
  }

  void fetchTopVideosUsers() {
    // fetching according to what user wants to see, top videos or top users
    searchController.isTopVideos.value
        ? searchController.changeVideo(
            searchKeywordsController.text.trim().toLowerCase(), "closeIcon")
        : searchController.changeUser(
            searchKeywordsController.text.trim().toLowerCase(), "closeIcon");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isDismissible: false,
                  context: context,
                  builder: (context) {
                    // showing different filter options related to videos and users
                    return searchController.isTopVideos.value
                        ? FilterVideo(
                            searchTerm: searchKeywordsController.text
                                .trim()
                                .toLowerCase())
                        : FilterUser(
                            searchTerm: searchKeywordsController.text
                                .trim()
                                .toLowerCase(),
                          );
                  },
                );
              },
              icon: const Icon(FontAwesomeIcons.filter))
        ],
        backgroundColor: white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                // width: size.width * 0.57,
                child: TextField(
                  controller: searchKeywordsController,
                  onChanged: (value) {
                    // when user type something close icon will be shown
                    searchController.showCancelIcon(value);
                    // if search value is empty fetching top videos and users
                    if (value.isEmpty) {
                      searchController.changeVideo("", "closeIcon");
                      searchController.changeUser("", "closeIcon");
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: Obx(
                        // showing close icon only when user search something
                        () => searchController.isInputChanged.value
                            ? IconButton(
                                onPressed: () {
                                  searchKeywordsController.clear();
                                  searchController.showCancelIcon("");
                                  fetchTopVideosUsers();
                                },
                                icon: const Icon(Icons.cancel))
                            : const SizedBox(),
                      ),
                      focusedBorder: const OutlineInputBorder(),
                      enabledBorder: const OutlineInputBorder(),
                      label: const Text(
                        "Enter search keywords",
                        style: TextStyle(fontSize: 15),
                      )),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (searchKeywordsController.text.trim().isNotEmpty) {
                  // fetching results according to what user wants to see, videos or users
                  searchController.isTopVideos.value
                      ? searchController.changeVideo(
                          searchKeywordsController.text.trim().toLowerCase(),
                          "search")
                      : searchController.changeUser(
                          searchKeywordsController.text.trim().toLowerCase(),
                          "search");
                }
              },
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () {
                    // specifying top videos is clicked
                    searchController.topVideos(true);
                    // showing videos when user click on top videos text button
                    if (searchKeywordsController.text.trim().isNotEmpty) {
                      searchController.changeVideo(
                          searchKeywordsController.text.trim().toLowerCase(),
                          "search");
                    } else {
                      searchController.changeVideo("", "closeIcon");
                    }
                  },
                  child: const Text("Top Videos")),
              TextButton(
                  onPressed: () {
                    // specifying top users clicked
                    searchController.topVideos(false);
                    if (searchKeywordsController.text.trim().isNotEmpty) {
                      searchController.changeUser(
                          searchKeywordsController.text.trim().toLowerCase(),
                          "search");
                    } else {
                      searchController.changeUser("", "closeIcon");
                    }
                  },
                  child: const Text("Top Users"))
            ],
          ),
          Obx(() =>
              (searchController.isTopVideos.value) ? TopVideos() : TopUsers())
        ],
      ),
    );
  }
}

class FilterUser extends StatelessWidget {
  String searchTerm;
  FilterUser({Key? key, required this.searchTerm}) : super(key: key);
  SearchVideoUserController searchController =
      Get.put(SearchVideoUserController());

  // color
  Color backgroundColor = Colors.blue;
  Color backgroundDefaultColor = Colors.grey;
  Color textColor = Colors.white;
  Color textDefaultColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ListTile(
          leading: TextButton(
              onPressed: () {
                // resetting all user performed operations
                searchController.resetUserFilter();
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          title: const Center(child: Text("Filters")),
          trailing: TextButton(
              onPressed: () {
                // fetching filtered users and resetting all operations performed by users
                searchController.changeUser(searchTerm, "filter");
                searchController.resetUserFilter();
                Navigator.pop(context);
              },
              child: const Text("Apply")),
        ),
        const Text("Followers"),
        Row(
          children: [
            GestureDetector(
                onTap: () {
                  searchController.highlightSelectedFollowers("low");
                },
                child: Obx(() => Chip(
                    // changing background color when user select option
                    backgroundColor: searchController.followers.value == "low"
                        ? backgroundColor
                        : backgroundDefaultColor,
                    label: Text("Low",
                        style: TextStyle(
                          color: searchController.followers.value == "low"
                              ? textColor
                              : textDefaultColor,
                        ))))),
            GestureDetector(
                onTap: () {
                  searchController.highlightSelectedFollowers("high");
                },
                child: Obx(() => Chip(
                    backgroundColor: searchController.followers.value == "high"
                        ? backgroundColor
                        : backgroundDefaultColor,
                    label: Text("High",
                        style: TextStyle(
                          color: searchController.followers.value == "high"
                              ? textColor
                              : textDefaultColor,
                        ))))),
          ],
        )
      ]),
    );
  }
}

class FilterVideo extends StatelessWidget {
  String searchTerm;
  FilterVideo({Key? key, required this.searchTerm}) : super(key: key);

  SearchVideoUserController searchController =
      Get.put(SearchVideoUserController());

  // color
  Color backgroundColor = Colors.blue;
  Color backgroundDefaultColor = Colors.grey;
  Color textColor = Colors.white;
  Color textDefaultColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: TextButton(
              onPressed: () {
                searchController.resetFilter();
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          title: const Center(child: Text("Filters")),
          trailing: TextButton(
              onPressed: () {
                searchController.changeVideo(searchTerm, "filter");
                searchController.resetFilter();
                Navigator.pop(context);
              },
              child: const Text("Apply")),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category"),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          searchController
                              .highlightSelectedCategory("web development");
                        },
                        child: Obx(() => Chip(
                            backgroundColor: searchController.userSelectCategory
                                    .contains("web development")
                                ? backgroundColor
                                : backgroundDefaultColor,
                            label: Text("Web Development",
                                style: TextStyle(
                                  color: searchController.userSelectCategory
                                          .contains("web development")
                                      ? textColor
                                      : textDefaultColor,
                                ))))),
                    GestureDetector(
                        onTap: () {
                          searchController
                              .highlightSelectedCategory("app development");
                        },
                        child: Obx(() => Chip(
                            backgroundColor: searchController.userSelectCategory
                                    .contains("app development")
                                ? backgroundColor
                                : backgroundDefaultColor,
                            label: Text("App Development",
                                style: TextStyle(
                                  color: searchController.userSelectCategory
                                          .contains("app development")
                                      ? textColor
                                      : textDefaultColor,
                                ))))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                        onTap: () {
                          searchController
                              .highlightSelectedCategory("machine learning");
                        },
                        child: Obx(() => Chip(
                            backgroundColor: searchController.userSelectCategory
                                    .contains("machine learning")
                                ? backgroundColor
                                : backgroundDefaultColor,
                            label: Text("Machine Learning",
                                style: TextStyle(
                                  color: searchController.userSelectCategory
                                          .contains("machine learning")
                                      ? textColor
                                      : textDefaultColor,
                                ))))),
                    GestureDetector(
                        onTap: () {
                          searchController.highlightSelectedCategory(
                              "artificial intelligence");
                        },
                        child: Obx(() => Chip(
                            backgroundColor: searchController.userSelectCategory
                                    .contains("artificial intelligence")
                                ? backgroundColor
                                : backgroundDefaultColor,
                            label: Text("Artificial Intelligence",
                                style: TextStyle(
                                  color: searchController.userSelectCategory
                                          .contains("artificial intelligence")
                                      ? textColor
                                      : textDefaultColor,
                                ))))),
                  ],
                ),
                GestureDetector(
                    onTap: () {
                      searchController
                          .highlightSelectedCategory("programming news");
                    },
                    child: Obx(() => Chip(
                        backgroundColor: searchController.userSelectCategory
                                .contains("programming news")
                            ? backgroundColor
                            : backgroundDefaultColor,
                        label: Text("Programming News",
                            style: TextStyle(
                              color: searchController.userSelectCategory
                                      .contains("programming news")
                                  ? textColor
                                  : textDefaultColor,
                            ))))),
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Likes"),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      searchController.highlightSelectedLikes("low");
                    },
                    child: Obx(() => Chip(
                        backgroundColor: searchController.likes.value == "low"
                            ? backgroundColor
                            : backgroundDefaultColor,
                        label: Text("Low",
                            style: TextStyle(
                              color: searchController.likes.value == "low"
                                  ? textColor
                                  : textDefaultColor,
                            ))))),
                GestureDetector(
                    onTap: () {
                      searchController.highlightSelectedLikes("high");
                    },
                    child: Obx(() => Chip(
                        backgroundColor: searchController.likes.value == "high"
                            ? backgroundColor
                            : backgroundDefaultColor,
                        label: Text("High",
                            style: TextStyle(
                              color: searchController.likes.value == "high"
                                  ? textColor
                                  : textDefaultColor,
                            ))))),
              ],
            )
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Views"),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      searchController.highlightSelectedViews("low");
                    },
                    child: Obx(() => Chip(
                        backgroundColor: searchController.views.value == "low"
                            ? backgroundColor
                            : backgroundDefaultColor,
                        label: Text("Low",
                            style: TextStyle(
                              color: searchController.views.value == "low"
                                  ? textColor
                                  : textDefaultColor,
                            ))))),
                GestureDetector(
                    onTap: () {
                      searchController.highlightSelectedViews("high");
                    },
                    child: Obx(() => Chip(
                        backgroundColor: searchController.views.value == "high"
                            ? backgroundColor
                            : backgroundDefaultColor,
                        label: Text("High",
                            style: TextStyle(
                              color: searchController.views.value == "high"
                                  ? textColor
                                  : textDefaultColor,
                            ))))),
              ],
            )
          ],
        )
      ],
    );
  }
}

class TopUsers extends StatelessWidget {
  // the future function is changing according to the searching
  TopUsers({Key? key}) : super(key: key);
  SearchVideoUserController searchController =
      Get.put(SearchVideoUserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
        future: searchController
            .fetchUsers.value, // The Future<T> that you want to monitor
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return Text('Error: ${snapshot.error}');
          } else {
            return searchController.searchedUsers.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: searchController.searchedUsers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => searchController.searchedUsers[index]
                                          ['email'] !=
                                      FirebaseAuth.instance.currentUser!.email
                                  ? ViewOtherProfile(
                                      userId: searchController
                                          .searchedUsers[index]['_id'])
                                  : const OwnProfileScreen());
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
                                              "$getProfilePhoto/${searchController.searchedUsers[index]['profileInformation']['profilePhoto']}"),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(searchController
                                                    .searchedUsers[index]
                                                ['profileInformation']['name']),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(searchController
                                                        .searchedUsers[index]
                                                    ['profileInformation']
                                                ['username'])
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(
                                        "${searchController.searchedUsers[index]['followers'].length} Followers")
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const Expanded(
                    child: Center(
                      child: Text("No any users found"),
                    ),
                  );
          }
        }));
  }
}

class TopVideos extends StatelessWidget {
  TopVideos({Key? key}) : super(key: key);
  SearchVideoUserController searchController =
      Get.put(SearchVideoUserController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => FutureBuilder(
        future: searchController
            .fetchVideos.value, // The Future<T> that you want to monitor
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while waiting for the Future to complete
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Display an error message if the Future throws an error
            return Text('Error: ${snapshot.error}');
          } else {
            return searchController.searchedVideos.isNotEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: searchController.searchedVideos.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 9 / 16,
                                crossAxisCount: 2,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    if (MYPROFILE['_id'] ==
                                        searchController.searchedVideos[index]
                                            ['userInformation']['_id']) {
                                      await initializeOwnVideo(searchController
                                          .searchedVideos[index]['_id']);
                                      Get.to(() => OwnVideo(
                                          videoId: searchController
                                              .searchedVideos[index]['_id']));
                                    } else {
                                      Map<String, dynamic> currentVideo =
                                          await initializeVideo(searchController
                                              .searchedVideos[index]['_id']);

                                      Get.to(() => ViewOtherVideo(
                                            video: currentVideo,
                                          ));
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: Image.network(
                                          "$GET_THUMBNAIL_URL/${searchController.searchedVideos[index]['thumbnailName']}",
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
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "${searchController.searchedVideos[index]['viewsCount']}",
                                                    style: const TextStyle(
                                                        color: white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(searchController.searchedVideos[index]
                                  ['title']),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => searchController
                                              .searchedVideos[index]['email'] !=
                                          FirebaseAuth
                                              .instance.currentUser!.email
                                      ? ViewOtherProfile(
                                          userId: searchController
                                                  .searchedVideos[index]
                                              ['userInformation']['_id'])
                                      : const OwnProfileScreen());
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "$getProfilePhoto/${searchController.searchedVideos[index]['userInformation']['profileInformation']['profilePhoto']}"),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            "${searchController.searchedVideos[index]['userInformation']['profileInformation']['name']}"),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                            "${searchController.searchedVideos[index]['userInformation']['profileInformation']['username']}")
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  )
                : const Expanded(
                    child: Center(
                      child: Text("No any videos found"),
                    ),
                  );
          }
        }));
  }
}
