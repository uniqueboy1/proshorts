import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_comment.dart';
import 'package:pro_shorts/get/videos/get_all_videos.dart';
import 'package:pro_shorts/views/home_screen/view_replies.dart';
import "package:http/http.dart" as http;

import '../../controllers/video.dart';
import '../../get/home_screen/get_video_screen.dart';

class Comment extends StatefulWidget {
  String videoId;
  Comment({Key? key, required this.videoId}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  CommentController commentController = Get.put(CommentController());
  VideoScreenController videoScreenController =
      Get.put(VideoScreenController());
  TextEditingController userCommentController = TextEditingController();
  TextEditingController replyTextController = TextEditingController();
  Map<String, dynamic> myProfile = MYPROFILE;

  // working on commenting

  void updateComments() async {
    await videoScreenController.updateComments(
        widget.videoId, userCommentController.text.trim());
    userCommentController.clear();
  }

  void deleteComment() async {
    await videoScreenController.deleteComment(widget.videoId);
  }

  Future fetchAllComments() async {
    await videoScreenController.fetchAllComments(widget.videoId);
  }

  // working on replies

  void addReply(String fieldId, String data) async {
    Map<String, dynamic> reply = {
      "userInformation": MYPROFILE['_id'],
      "reply": data
    };
    await VideoMethods().editVideoArrayArrayField(
        widget.videoId, fieldId, "comments", "replies", reply);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Obx(() =>
              Text("${videoScreenController.allComments.length} Comments")),
          // const Text("500 Comments"),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: myProfile['profileInformation'] != null
                    ? NetworkImage(
                        "$getProfilePhoto/${myProfile['profileInformation']['profilePhoto']}")
                    : null,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextFormField(
                  controller: userCommentController,
                  decoration: InputDecoration(
                      labelText: "Add a comment",
                      suffixIcon: IconButton(
                          onPressed: () {
                            updateComments();
                          },
                          icon: const Icon(Icons.send))),
                  validator: (value) {
                    return null;
                  },
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: fetchAllComments(),
              // The Future<T> that you want to monitor
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Display a loading indicator while waiting for the Future to complete
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  // Display an error message if the Future throws an error
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Obx(() => videoScreenController.allComments.isNotEmpty
                      ? SizedBox(
                          height: size.height * 0.43,
                          width: size.width,
                          child: ListView.builder(
                              itemCount:
                                  videoScreenController.allComments.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundImage: videoScreenController
                                                                    .allComments[
                                                                index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? NetworkImage(
                                                    "$getProfilePhoto/${videoScreenController.allComments[index]['userInformation']['profileInformation']['profilePhoto']}")
                                                : null),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(videoScreenController
                                                                    .allComments[
                                                                index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? videoScreenController
                                                            .allComments[index]
                                                        ['userInformation'][
                                                    'profileInformation']['name']
                                                : "Unknown"),
                                            Text(videoScreenController
                                                                    .allComments[
                                                                index]
                                                            ['userInformation']
                                                        [
                                                        'profileInformation'] !=
                                                    null
                                                ? videoScreenController
                                                                    .allComments[
                                                                index]
                                                            [
                                                            'userInformation']
                                                        ['profileInformation']
                                                    ['username']
                                                : "Unknown")
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(videoScreenController
                                        .allComments[index]['comment']),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(videoScreenController
                                                .allComments[index]['likeCount']
                                                .toString()),
                                            IconButton(
                                                onPressed: () {},
                                                icon:
                                                    const Icon(Icons.thumb_up)),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(videoScreenController
                                                .allComments[index]
                                                    ['dislikeCount']
                                                .toString()),
                                            IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.thumb_down)),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () {
                                                  deleteComment();
                                                  fetchAllComments();
                                                },
                                                icon: videoScreenController
                                                        .isUserAlreadyCommentedVideo
                                                    ? const Icon(
                                                        Icons.delete_forever)
                                                    : const SizedBox()),
                                          ],
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 15,
                                                                horizontal: 15),
                                                        child: Row(
                                                          children: [
                                                            CircleAvatar(
                                                              backgroundImage: MYPROFILE[
                                                                          'profileInformation'] !=
                                                                      null
                                                                  ? NetworkImage(
                                                                      "$getProfilePhoto/${MYPROFILE['profileInformation']['profilePhoto']}")
                                                                  : null,
                                                            ),
                                                            const SizedBox(
                                                              width: 20,
                                                            ),
                                                            Expanded(
                                                              child: TextField(
                                                                controller:
                                                                    replyTextController,
                                                                decoration: InputDecoration(
                                                                    suffixIcon: IconButton(
                                                                        onPressed: () {
                                                                          addReply(
                                                                              videoScreenController.allComments[index]['_id'],
                                                                              replyTextController.text.trim());
                                                                          Get.back();
                                                                        },
                                                                        icon: const Icon(Icons.send))),
                                                                autofocus: true,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: const Text("Reply")),
                                      ],
                                    ),
                                    Obx(
                                      () => FutureBuilder(
                                          future: commentController
                                              .fetchReply_.value,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasData) {
                                                return const ViewReplies();
                                              } else {
                                                return const SizedBox();
                                              }
                                            }
                                          }),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          commentController
                                              .changeFetchReplyText();
                                        },
                                        child: Obx(() => Text(
                                            "View ${videoScreenController.allComments[index]['replies'].length} Replies")))
                                  ],
                                );
                              }),
                        )
                      : const Expanded(
                          child: Center(child: Text("No any comments"))));
                }
              })
        ],
      ),
    );
  }
}
