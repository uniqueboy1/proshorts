import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/video.dart';
import '../videos/get_all_videos.dart';
import "package:http/http.dart" as http;

enum ReportReason {
  notProgramming,
  hateHarrasement,
  nuditySexual,
  misinformation
}

class VideoScreenController extends GetxController {
  VideoMethods videoMethods = VideoMethods();
  RxInt shareCount = 0.obs;
  RxInt commentsCount = 0.obs;
  RxInt viewsCount = 0.obs;
  Map<String, dynamic> currentVideo = {};
  void initializeVideoDetails(Map<String, dynamic> video) {
    viewsCount.value = currentVideo['viewsCount'];
    commentsCount.value = currentVideo['comments'].length;
    likeCount.value = currentVideo['likeCount'];
    dislikeCount.value = currentVideo['dislikeCount'];
    shareCount.value = currentVideo['shareCount'];
    videoDescription.value = video['description'].length >= 25
        ? "${video["description"].substring(0, 25)} ..."
        : video['description'];
    isSeeMoreClicked = false;
    isVideoPlaying.value = true;
    seeMore.value = "SEE MORE";
    isUserAlreadyLikedDislikedVideo();
    changeFollowIcon();
  }

  void changeFollowIcon() {
    if (isFollowingUser) {
      followIcon.value = Icons.check;
    } else {
      followIcon.value = Icons.add;
    }
  }

  Future updateComments(String videoId) async {
    List comments = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "comments");
    commentsCount.value = comments.length;
  }

  Future fetchCurrentVideo(String videoId) async {
    List videos = await VideoMethods().fetchVideosByField("_id", videoId);
    currentVideo = videos[0];
    return currentVideo;
  }

  Future initializeVideo(Map<String, dynamic> video) async {
    String videoPath = video['videoPath'];
    String videoId = video['_id'];
    await fetchCurrentVideo(videoId);
    await fetchLikedDislikedVideos();
    await isFollowing(video['userInformation']['_id']);
    controller = VideoPlayerController.network("$getVideo/$videoPath")
      ..initialize();
  }

// to update video details when details is updated from other screen
  Future updateVideoDetails(String videoId, String userId) async {
    Map<String, dynamic> currentVideo = await fetchCurrentVideo(videoId);
    await fetchLikedDislikedVideos();
    await isFollowing(userId);
    initializeVideoDetails(currentVideo);
  }

  /* start : working on following */
  Rx<IconData> followIcon = Icons.add.obs;

  void updateFollowIcon(String userId) async {
    await isFollowing(userId);
    // user can't follow own profile
    if (userId != MYPROFILE['_id']) {
      if (!isFollowingUser) {
        followIcon.value = Icons.check;
        await followUser(userId);
      } else {
        followIcon.value = Icons.add;
        await followUser(userId);
      }
    }
  }

  late bool isFollowingUser;
  Future isFollowing(String userId) async {
    Map<String, dynamic> user = await UserMethods().checkValueExistInArray(
        MYPROFILE['_id'], "following", "userInformation", userId);
    isFollowingUser = user['following'].isNotEmpty;
  }

  Future followUser(String userId) async {
    Map<String, dynamic> followingInformation = {"userInformation": userId};
    Map<String, dynamic> followersInformation = {
      "userInformation": MYPROFILE['_id']
    };
    UserMethods userMethods = UserMethods();
    if (!isFollowingUser) {
      await userMethods.editUserArrayField(
          MYPROFILE['_id'], followingInformation, "following");
      await userMethods.editUserArrayField(
          userId, followersInformation, "followers");

      dynamic response = await userMethods.fetchSpecificUserField(
          "_id", MYPROFILE['_id'], "profileInformation");

      await userMethods.editUserArrayField(
          userId,
          {
            "message": response != null
                ? "${response['username']} started following you"
                : "Someone started following you"
          },
          "notifications");
    } else {
      await userMethods.deleteUserArrayField(
          MYPROFILE['_id'], followingInformation, "following");
      await userMethods.deleteUserArrayField(
          userId, followersInformation, "followers");

      dynamic response = await userMethods.fetchSpecificUserField(
          "_id", MYPROFILE['_id'], "profileInformation");

      await userMethods.deleteUserArrayField(
          userId,
          {
            "message": response != null
                ? "${response['username']} started following you"
                : "Someone started following you"
          },
          "notifications");
    }
  }

  /* end : working on following */

  /*     start : like and dislike related variables and operations  */
  RxInt likeCount = 0.obs;
  RxInt dislikeCount = 0.obs;
  List likedVideos = [];
  List dislikedVideos = [];
  late bool isLikeClicked;
  late Color likeButtonColor;
  late bool isDislikeClicked;
  late Color dislikeButtonColor;

// updating like
  void changeLike(String videoId) async {
    // storing video id when user clicks on like button
    Map<String, dynamic> likedVideo = {
      "videoInformation": videoId,
    };

    int latestLikeCount = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "likeCount");

    isLikeClicked = !isLikeClicked;
    if (isLikeClicked) {
      if (isDislikeClicked) {
        isDislikeClicked = false;
        dislikeCount.value--;
        dislikeButtonColor = Colors.white;
      }
      likeButtonColor = Colors.blue;
      latestLikeCount++;
      likeCount.value = latestLikeCount;
      await UserMethods()
          .editUserArrayField(MYPROFILE['_id'], likedVideo, "likedVideos");
      await UserMethods()
          .deleteUserArrayField(MYPROFILE['_id'], likedVideo, "dislikedVideos");
    } else {
      isDislikeClicked = false;
      likeButtonColor = Colors.white;
      likeCount.value--;
      await UserMethods()
          .deleteUserArrayField(MYPROFILE['_id'], likedVideo, "likedVideos");
    }
    await videoMethods.editVideo(videoId,
        {"likeCount": likeCount.value, "dislikeCount": dislikeCount.value});
  }

  void changeDislike(String videoId) async {
    Map<String, dynamic> dislikedVideo = {
      "videoInformation": videoId,
    };
    int latestDislikeCount = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "dislikeCount");
    isDislikeClicked = !isDislikeClicked;
    if (isDislikeClicked) {
      if (isLikeClicked) {
        isLikeClicked = false;
        likeCount.value--;
        likeButtonColor = Colors.white;
      }
      dislikeButtonColor = Colors.red;
      latestDislikeCount++;
      dislikeCount.value = latestDislikeCount;
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], dislikedVideo, "dislikedVideos");
      await UserMethods()
          .deleteUserArrayField(MYPROFILE['_id'], dislikedVideo, "likedVideos");
    } else {
      isLikeClicked = false;
      dislikeButtonColor = Colors.white;
      dislikeCount.value--;
      await UserMethods().deleteUserArrayField(
          MYPROFILE['_id'], dislikedVideo, "dislikedVideos");
    }
    await videoMethods.editVideo(videoId,
        {"dislikeCount": dislikeCount.value, "likeCount": likeCount.value});
  }

  Future fetchLikedDislikedVideos() async {
    List response = await UserMethods().fetchUsersByField(
        "email", FirebaseAuth.instance.currentUser!.email.toString());
    likedVideos = response[0]['likedVideos'];
    dislikedVideos = response[0]['dislikedVideos'];
  }

  void isUserAlreadyLikedDislikedVideo() {
    isLikeClicked = likedVideos.any((video) {
      print("video: $video");
      final videoInformation = video.containsKey(['_id'])
          ? video["videoInformation"]['_id']
          : video['videoInformation'];
      print("videoInformation : $videoInformation");
      print("video id : ${currentVideo['_id']}");
      if (videoInformation == currentVideo['_id']) {
        return true;
      }
      return false;
    });

    print("islikedClicked : $isLikeClicked");

    isDislikeClicked = dislikedVideos.any((video) {
      final videoInformation = video.containsKey(['_id'])
          ? video["videoInformation"]['_id']
          : video['videoInformation'];
      print("videoInformation : $videoInformation");
      if (videoInformation == currentVideo['_id']) {
        return true;
      }
      return false;
    });

    if (isLikeClicked) {
      likeButtonColor = Colors.blue;
    } else {
      likeButtonColor = Colors.white;
    }
    if (isDislikeClicked) {
      dislikeButtonColor = Colors.red;
    } else {
      dislikeButtonColor = Colors.white;
    }
  }

  /*   end : like and dislike related variables and operations  */

  /*  start : video playing related methods and variables  */
  late VideoPlayerController controller;
  RxBool isVideoPlaying = true.obs;
  void showPlayPauseIcon() {
    if (isVideoPlaying.value) {
      controller.pause();
    } else {
      controller.play();
      controller.setLooping(true);
    }
    isVideoPlaying.value = controller.value.isPlaying;
  }

  playVideo() {
    try {
      controller.play();
      controller.setLooping(true);
    } catch (error) {
      print("Error occurred while playing video: $error");
    }
  }

  /*  end : video playing related methods and variables  */

  /*   start : working on see more button */

  bool isSeeMoreClicked = false;
  RxString seeMore = "SEE MORE".obs;
  RxString videoDescription = "".obs;

  void toogleSeeMore(Map<String, dynamic> video) {
    isSeeMoreClicked = !isSeeMoreClicked;
    if (isSeeMoreClicked) {
      seeMore.value = "SEE LESS";
      videoDescription.value = video["description"];
    } else {
      seeMore.value = "SEE MORE";
      videoDescription.value = video['description'].length >= 25
          ? "${video["description"].substring(0, 25)} ..."
          : video['description'];
    }
  }

  /*   end : working on see more button  */

  /* start : working on report video */

  Rx<ReportReason> selectedReportReason = ReportReason.notProgramming.obs;
  void updateReportReason(ReportReason reason) {
    selectedReportReason.value = reason;
  }
  /* end : working on report video */
}
