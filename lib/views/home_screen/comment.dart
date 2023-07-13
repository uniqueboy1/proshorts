import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/get/home_screen/get_comment.dart';
import 'package:pro_shorts/views/home_screen/view_replies.dart';
import "package:http/http.dart" as http;


class Comment extends StatefulWidget {
  const Comment({Key? key}) : super(key: key);

  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {

 CommentController commentController = Get.put(CommentController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Text("500 Comments"),
          SizedBox(
            height: size.height * 0.5,
            width: size.width,
            child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundImage: AssetImage(logo),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Column(
                            children:  const [
                               Text("name"),
                               Text("proshorts")
                            ],
                          )
                          
                        ],
                      ),
                      const Text("this is your comment"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: const Icon(Icons.thumb_up)),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.thumb_down)),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Align(
                                        alignment: Alignment.topCenter,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: TextField(
                                            decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(Icons.send))),
                                            autofocus: true,
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: const Text("Reply")),
                        ],
                      ),
                      Obx(() => FutureBuilder(
                        future: commentController.fetchReply_.value,
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }
                          else{
                            if(snapshot.hasData){
                              return const ViewReplies();
                            }
                            else{
                              return const SizedBox();
                            }
                          }
                        }),),
                      TextButton(
                          onPressed: () {
                            commentController.changeFetchReplyText();
                            
                          },
                          child: Obx(() => Text(commentController.viewRepliesText.value)))
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
