import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/methods/show_snack_bar.dart';

class CommentController extends GetxController {
  RxList<bool> isExpanded = <bool>[].obs;

  void changeFetchReplyText(int index , bool data) {
    isExpanded[index] = data;
  }

  /* start : working on comments */

  RxInt commentsCount = 0.obs;
  bool isCommentLikeClicked = false;
  Color commentLikeButtonColor = Colors.white;
  bool isCommentDislikeClicked = false;
  Color commentDislikeButtonColor = Colors.white;
  dynamic fetchComments = Future.value().obs;
  RxList allComments = [].obs;
  RxList likedComments = [].obs;
  RxList dislikedComments = [].obs;

  RxInt commentDislikeCount = 0.obs;
  RxInt commentLikeCount = 0.obs;

  bool isUserAlreadyCommentedVideo = false;
  bool userAlreadyCommented() {
    isUserAlreadyCommentedVideo = allComments.any((comment) {
      String userId = comment['userInformation']["_id"];
      if (userId == MYPROFILE['_id']) {
        return true;
      }
      return false;
    });
    return isUserAlreadyCommentedVideo;
  }

  bool isMyComment(String userId) {
    if (userId == MYPROFILE['_id']) {
      return true;
    }
    return false;
  }

  Future updateComments(String videoId, String data) async {
    if (!isUserAlreadyCommentedVideo) {
      Map<String, dynamic> comment = {
        "comment": data,
        "userInformation": MYPROFILE['_id']
      };
      await VideoMethods().editVideoArrayField(videoId, comment, "comments");
      showSnackBar("Comment", "Comment added successfully");
    } else {
      showSnackBar("Comment", "You can add one comment per video");
    }
  }

  Future fetchAllComments(String videoId) async {
    allComments.value = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "comments");
    print("all comments : $allComments");
    userAlreadyCommented();
    likedComments.value = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE["_id"], "likedComments");
    dislikedComments.value = await UserMethods()
        .fetchSpecificUserField("_id", MYPROFILE["_id"], "dislikedComments");
  }

  Future deleteComment(String videoId) async {
    Map<String, dynamic> comment = {"userInformation": MYPROFILE['_id']};
    await VideoMethods().deleteVideoArrayField(videoId, comment, "comments");
    showSnackBar("Comment", "Comment deleted successfully");
  }

  Future changeCommentLike(String commentId, String videoId) async {
    UserMethods userMethods = UserMethods();
    VideoMethods videoMethods = VideoMethods();
    if (dislikedComments.any((comment) => comment['commentId'] == commentId)) {
      await userMethods.deleteUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "dislikedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int dislikeCount = comment['dislikeCount'];
      dislikeCount--;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"dislikeCount": dislikeCount});
    }

    if (!likedComments.any((comment) => comment['commentId'] == commentId)) {
      await userMethods.editUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "likedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int likeCount = comment['likeCount'];
      likeCount++;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"likeCount": likeCount});
    } else {
      await userMethods.deleteUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "likedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int likeCount = comment['likeCount'];
      likeCount--;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"likeCount": likeCount});
    }
  }

  Future changeCommentDislike(String commentId, String videoId) async {
    UserMethods userMethods = UserMethods();
    VideoMethods videoMethods = VideoMethods();
    if (likedComments.any((comment) => comment['commentId'] == commentId)) {
      await userMethods.deleteUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "likedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int likeCount = comment['likeCount'];
      likeCount--;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"likeCount": likeCount});
    }

    if (!dislikedComments.any((comment) => comment['commentId'] == commentId)) {
      await userMethods.editUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "dislikedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int dislikeCount = comment['dislikeCount'];
      dislikeCount++;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"dislikeCount": dislikeCount});
    } else {
      await userMethods.deleteUserArrayField(
          MYPROFILE['_id'], {"commentId": commentId}, "dislikedComments");
      dynamic comment = await videoMethods.checkValueExistInArray(
          videoId, "comments", "_id", commentId);
      comment = comment['comments'][0];
      int dislikeCount = comment['dislikeCount'];
      dislikeCount--;
      await videoMethods.updateVideoArrayField(
          videoId, "comments", commentId, {"dislikeCount": dislikeCount});
    }
  }


  void reset() {
    commentsCount.value = 0;
    isCommentLikeClicked = false;
    commentLikeButtonColor = Colors.white;
    isCommentDislikeClicked = false;
    commentDislikeButtonColor = Colors.white;
    allComments.value = [];
    isUserAlreadyCommentedVideo = false;
    isExpanded.value = [];
  }

  /* end : working on comments */
}
