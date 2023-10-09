import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/admin/search_video_user.dart';
import 'package:pro_shorts/admin/view_video.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/controllers/video.dart';
import "package:http/http.dart" as http;
import 'package:pro_shorts/views/home_screen/search.dart';

class ViewPublicVideos extends StatefulWidget {
  const ViewPublicVideos({super.key});

  @override
  State<ViewPublicVideos> createState() => _ViewPublicVideosState();
}

class _ViewPublicVideosState extends State<ViewPublicVideos> {
  List publicVideos = [];

  Future fetchPublicVideos() async {
    publicVideos =
        await VideoMethods().fetchVideosByField("videoMode", "public");
  }

  Future<void> deleteVideoById(
      String id, String thumbnailName, String videoPath, String userId) async {
    try {
      final URL = Uri.parse("$DELETE_VIDEO_URL/$id");
      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.delete(URL, headers: headers);
      final actualResponse = jsonDecode(response.body);

      Map<String, dynamic> videoInformation = {"videoInformation": id};

      // deleting from public videos
      UserMethods userMethods = UserMethods();
      VideoMethods videoMethods = VideoMethods();
      await userMethods.deleteUserArrayField(
          userId, videoInformation, "public_videos");

      // deleting from private videos
      await userMethods.deleteUserArrayField(
          userId, videoInformation, "private_videos");

      // deleting video thumbnail
      await videoMethods.deleteVideoThumbnail(thumbnailName);

      // deleting actual video
      await videoMethods.deleteActualVideo(videoPath);

      if (actualResponse['success']) {
        print("Video Deleted successfully");
      } else {
        print("Error while deleting video : ${actualResponse['message']}");
      }
    } catch (error) {
      print("error while deleting video : $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Video List"),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(() => const AdminSearch());
                },
                icon: const Icon(Icons.search))
          ],
        ),
        body: FutureBuilder(
            future:
                fetchPublicVideos(), // The Future<T> that you want to monitor
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a loading indicator while waiting for the Future to complete
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Display an error message if the Future throws an error
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                    itemCount: publicVideos.length,
                    itemBuilder: ((context, index) {
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(() => ViewVideo(
                                        videoId: publicVideos[index]['_id']));
                                  },
                                  child: BeautifulImage(
                                    imageUrl: publicVideos[index]
                                        ['thumbnailName'],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "Title:",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                          width:
                                              8), // Add spacing between label and value
                                      Text(
                                        publicVideos[index]['title'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Are you sure want to delete this video ?"),
                                              content: const Text(
                                                  "This video will be permanently deleted"),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("Cancel")),
                                                TextButton(
                                                    onPressed: () async {
                                                      await deleteVideoById(
                                                          publicVideos[index]
                                                              ['_id'],
                                                          publicVideos[index]
                                                              ['thumbnailName'],
                                                          publicVideos[index]
                                                              ['videoPath'],
                                                          publicVideos[index][
                                                                  'userInformation']
                                                              ['_id']);
                                                      setState(() {});
                                                    },
                                                    child:
                                                        const Text("Delete")),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                      size: 32,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text(
                                    "Description:",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Add spacing between label and value
                                  Expanded(
                                    child: Text(
                                      publicVideos[index]['description'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  const Text(
                                    "Uploaded By :",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                      width:
                                          8), // Add spacing between label and value
                                  Expanded(
                                    child: Text(
                                      publicVideos[index]['userInformation']
                                          ['profileInformation']['username'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Keywords:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(children: [
                                ...publicVideos[index]['keywords']
                                    .map((keyword) {
                                  return Chip(
                                    deleteIcon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                    ),
                                    label: Text(keyword),
                                  );
                                }),
                              ]),
                              const SizedBox(height: 16),
                              const Text(
                                "Report message:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              publicVideos[index]['reportMessage'].isNotEmpty
                                  ? Column(children: [
                                      ...publicVideos[index]['reportMessage']
                                          .map((keyword) {
                                        return Card(
                                          elevation: 4,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 16),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Text(
                                              keyword['message'],
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                          ),
                                        );
                                      }),
                                    ])
                                  : const Card(
                                      elevation: 4,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 16),
                                      child: Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          "No report on this video",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      );
                    }));
              }
            }));
  }
}

class BeautifulImage extends StatelessWidget {
  final String imageUrl;

  const BeautifulImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.network(
          "$GET_THUMBNAIL_URL/$imageUrl",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
