import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/get/home_screen/get_search.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';
import 'package:video_player/video_player.dart';

import '../../constants.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchController searchController = Get.put(SearchController());
  TextEditingController searchKeywordsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: size.width * 0.6,
              child: TextField(
                controller: searchKeywordsController,
                onChanged: (value) {
                  searchController.showCancelIcon(value);
                },
                decoration: InputDecoration(
                    suffixIcon: Obx(
                      () => searchController.isInputChanged.value
                          ? IconButton(
                              onPressed: () {
                                searchKeywordsController.clear();
                                searchController.showCancelIcon("");
                              },
                              icon: Icon(Icons.cancel))
                          : SizedBox(),
                    ),
                    focusedBorder: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(),
                    label: Text("Enter search keywords")),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.search),
            )
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
                    searchController.topVideos();
                  },
                  child: Row(
                    children: [
                      Text("Top Videos"),
                      Obx(() => searchController.isInputChanged.value && searchController.isTopVideos.value
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          ListTile(
                                            leading: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel")),
                                            title:
                                                Center(child: Text("Filters")),
                                            trailing: TextButton(
                                                onPressed: () {},
                                                child: Text("Apply")),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Category"),
                                              Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Chip(
                                                          label: Text(
                                                              "Web Development")),
                                                      Chip(
                                                          label: Text(
                                                              "App Development")),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Chip(
                                                          label: Text(
                                                              "Machine Learning")),
                                                      Chip(
                                                          label: Text(
                                                              "Artificial Intelligence")),
                                                    ],
                                                  ),
                                                  Chip(
                                                      label: Text(
                                                          "Programming News")),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Likes"),
                                              Row(
                                                children: [
                                                  Chip(label: Text("Low")),
                                                  Chip(label: Text("High")),
                                                ],
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Views"),
                                              Row(
                                                children: [
                                                  Chip(label: Text("Low")),
                                                  Chip(label: Text("High")),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(FontAwesomeIcons.filter))
                          : SizedBox())
                    ],
                  )),
              TextButton(
                  onPressed: () {
                    searchController.topUsers();
                  },
                  child: Row(
                    children: [
                      Text("Top Users"),
                      Obx(() => searchController.isInputChanged.value && !searchController.isTopVideos.value
                          ? IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    isDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ListTile(
                                              leading: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Cancel")),
                                              title: Center(
                                                  child: Text("Filters")),
                                              trailing: TextButton(
                                                  onPressed: () {},
                                                  child: Text("Apply")),
                                            ),
                                            Text("Followers"),
                                            Row(
                                              children: [
                                                Chip(label: Text("Low")),
                                                Chip(label: Text("High")),
                                              ],
                                            )
                                          ]);
                                    });
                              },
                              icon: Icon(FontAwesomeIcons.filter))
                          : SizedBox())
                    ],
                  ))
            ],
          ),
          Obx(() =>
              searchController.isTopVideos.value ? TopVideos() : TopUsers())
        ],
      ),
    );
  }
}

class TopUsers extends StatelessWidget {
  const TopUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(ViewOtherProfile());
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(logo),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text("name"),
                              SizedBox(
                                height: 3,
                              ),
                              Text("username")
                            ],
                          )
                        ],
                      ),
                      Text("1.2M Followers")
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class TopVideos extends StatelessWidget {
  TopVideos({Key? key}) : super(key: key);
  final VideoPlayerController controller =
      VideoPlayerController.asset(videoPath)..initialize();
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 9 / 16,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return Column(
              children: [
                SizedBox(
                  height: 240,
                  child: Stack(
                    children: [
                      VideoPlayer(controller),
                      Positioned(
                          right: 10,
                          bottom: 10,
                          child: Text(
                            "20K",
                            style: TextStyle(color: white, fontSize: 20),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("title of the video"),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(logo),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text("name"),
                        SizedBox(
                          height: 3,
                        ),
                        Text("username")
                      ],
                    )
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
