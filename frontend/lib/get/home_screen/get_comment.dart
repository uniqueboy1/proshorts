import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
class CommentController extends GetxController {

  dynamic fetchReply_ = Future.value().obs;
   RxString viewRepliesText = "View 10 Replies".obs;

fetchReply() async{
    var url = Uri.parse("https://jsonplaceholder.typicode.com/todos");
    var response = await http.get(url);
    return jsonDecode(response.body);
  }
  void changeFetchReplyText() {
    fetchReply_.value =   fetchReply();
    viewRepliesText.value = "View Less Replies";
  }
}
