import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_comment.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';
import 'package:pro_shorts/methods/update_comments.dart';

import '../../controllers/video.dart';

class Comment extends StatefulWidget {
  final String videoId;
  const Comment({Key? key, required this.videoId}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  CommentController commentController = Get.put(CommentController());
  TextEditingController userCommentController = TextEditingController();
  TextEditingController replyTextController = TextEditingController();

  // working on commenting

  Future updateComments() async {
    await commentController.updateComments(
        widget.videoId, userCommentController.text.trim());
    userCommentController.clear();
  }

  Future deleteComment() async {
    await commentController.deleteComment(widget.videoId);
  }

  Future fetchAllComments() async {
    await commentController.fetchAllComments(widget.videoId);
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

  Future<List> fetchReply(String commentId) async {
    dynamic replies = await VideoMethods().checkValueExistInArray(
        widget.videoId, "comments-replies", "_id", commentId);
    replies = replies['comments'][0]['replies'];
    return replies;
  }

  @override
  void initState() {
    commentController.reset();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Obx(() => Text("${commentController.allComments.length} Comments")),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: MYPROFILE['profileInformation'] != null
                    ? NetworkImage(
                        "$getProfilePhoto/${MYPROFILE['profileInformation']['profilePhoto']}")
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
                          onPressed: () async {
                            await updateComments();
                            await updateVideoComments(widget.videoId);
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
                  commentController.isExpanded.value = List.generate(
                      commentController.allComments.length, (index) => false);
                  return Obx(() => commentController.allComments.isNotEmpty
                      ? SizedBox(
                          height: size.height * 0.43,
                          width: size.width,
                          child: ListView.builder(
                              itemCount: commentController.allComments.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundImage: commentController
                                                                    .allComments[
                                                                index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? NetworkImage(
                                                    "$getProfilePhoto/${commentController.allComments[index]['userInformation']['profileInformation']['profilePhoto']}")
                                                : null),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          children: [
                                            Text(commentController.allComments[
                                                                index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? commentController.allComments[
                                                                index]
                                                            ['userInformation']
                                                        ['profileInformation']
                                                    ['name']
                                                : "Unknown"),
                                            Text(commentController.allComments[
                                                                index]
                                                            ['userInformation'][
                                                        'profileInformation'] !=
                                                    null
                                                ? commentController.allComments[
                                                                index]
                                                            ['userInformation']
                                                        ['profileInformation']
                                                    ['username']
                                                : "Unknown")
                                          ],
                                        )
                                      ],
                                    ),
                                    Text(commentController.allComments[index]
                                        ['comment']),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          children: [
                                            Text(commentController
                                                .allComments[index]['likeCount']
                                                .toString()),
                                            IconButton(
                                                onPressed: () async {
                                                  await commentController
                                                      .changeCommentLike(
                                                          commentController
                                                                  .allComments[
                                                              index]['_id'],
                                                          widget.videoId);

                                                  await fetchAllComments();
                                                },
                                                icon: Obx(() => Icon(
                                                    Icons.thumb_up,
                                                    color: commentController
                                                            .likedComments
                                                            .any((comment) =>
                                                                comment[
                                                                    "commentId"] ==
                                                                commentController
                                                                        .allComments[
                                                                    index]['_id'])
                                                        ? Colors.blue
                                                        : Colors.black))),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(commentController
                                                .allComments[index]
                                                    ['dislikeCount']
                                                .toString()),
                                            IconButton(
                                                onPressed: () async {
                                                  await commentController
                                                      .changeCommentDislike(
                                                          commentController
                                                                  .allComments[
                                                              index]['_id'],
                                                          widget.videoId);

                                                  await fetchAllComments();
                                                },
                                                icon: Obx(() => Icon(
                                                    Icons.thumb_down,
                                                    color: commentController
                                                            .dislikedComments
                                                            .any((comment) =>
                                                                comment[
                                                                    "commentId"] ==
                                                                commentController
                                                                        .allComments[
                                                                    index]['_id'])
                                                        ? Colors.red
                                                        : Colors.black))),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await deleteComment();
                                                  await fetchAllComments();
                                                  // changing comments count on individual video and on video screen
                                                  await updateVideoComments(widget.videoId);
                                                  
                                                },
                                                icon: commentController.isMyComment(
                                                        commentController
                                                                        .allComments[
                                                                    index][
                                                                'userInformation']
                                                            ['_id'])
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
                                                                              commentController.allComments[index]['_id'],
                                                                              replyTextController.text.trim());
                                                                          replyTextController
                                                                              .clear();
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
                                    Obx(() =>
                                        commentController
                                                .allComments[index]['replies']
                                                .isNotEmpty
                                            ? ExpansionTile(
                                                onExpansionChanged: (value) {
                                                  if (value) {
                                                    commentController
                                                        .changeFetchReplyText(
                                                            index, value);
                                                  } else {
                                                    commentController
                                                        .changeFetchReplyText(
                                                            index, value);
                                                  }
                                                },
                                                trailing: const Text(""),
                                                title: Center(
                                                  child: Obx(() =>
                                                      !commentController
                                                              .isExpanded[index]
                                                          ? Text(
                                                              "View ${commentController.allComments[index]['replies'].length} Replies")
                                                          : const Text(
                                                              "Hide Replies")),
                                                ),
                                                children: [
                                                  FutureBuilder(
                                                      future: fetchReply(
                                                          commentController
                                                                  .allComments[
                                                              index]["_id"]),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return const CircularProgressIndicator();
                                                        } else {
                                                          if (snapshot
                                                              .hasData) {
                                                            List replies =
                                                                snapshot.data!;
                                                            return Column(
                                                              children: [
                                                                ...replies.map(
                                                                    (reply) {
                                                                  return ListTile(
                                                                    title: Row(
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            CircleAvatar(backgroundImage: reply['userInformation']['profileInformation'] != null ? NetworkImage("$getProfilePhoto/${reply['userInformation']['profileInformation']['profilePhoto']}") : null),
                                                                            const SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Column(
                                                                              children: [
                                                                                Text(reply['userInformation']['profileInformation'] != null ? reply['userInformation']['profileInformation']['name'] : "Unknown"),
                                                                                Text(reply['userInformation']['profileInformation'] != null ? reply['userInformation']['profileInformation']['username'] : "Unknown")
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              30,
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Text(reply['reply'])),
                                                                      ],
                                                                    ),
                                                                  );
                                                                })
                                                              ],
                                                            );
                                                          } else {
                                                            return const SizedBox();
                                                          }
                                                        }
                                                      }),
                                                ],
                                              )
                                            : const SizedBox(
                                                height: 10,
                                              ))
                                  ],
                                );
                              }),
                        )
                      : const Expanded(
                          child: Center(child: Text("No any comments"))));
                }
              }),
        ],
      ),
    );
  }
}
