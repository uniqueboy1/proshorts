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
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  VideoMethods videoMethods = VideoMethods();
  RxInt shareCount = 0.obs;
  Map<String, dynamic> currentVideo = {};
  void initializeVideoDetails(Map<String, dynamic> video) {
    commentsCount.value = currentVideo['comments'].length;
    likeCount.value = currentVideo['likeCount'];
    dislikeCount.value = currentVideo['dislikeCount'];
    shareCount.value = video['shareCount'];
    videoDescription.value = video['description'].length >= 25
        ? "${video["description"].substring(0, 25)} ..."
        : video['description'];
    isSeeMoreClicked = false;
    isVideoPlaying.value = true;
    seeMore.value = "SEE MORE";
    isUserAlreadyLikedDislikedVideo();
    if (isFollowingUser) {
      followIcon.value = Icons.check;
    } else {
      followIcon.value = Icons.add;
    }
  }

  Future fetchCurrentVideo(String videoId) async {
    List videos = await VideoMethods().fetchVideosByField("_id", videoId);
    currentVideo = videos[0];
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

  /* start : working on following */
  Rx<IconData> followIcon = Icons.add.obs;

  void updateFollowIcon(String userId) async {
    if (!isFollowingUser) {
      followIcon.value = Icons.check;
      await followUser(userId);
    } else {
      followIcon.value = Icons.add;
      await followUser(userId);
    }
  }

  late bool isFollowingUser;
  Future isFollowing(String userId) async {
    isFollowingUser = await UserMethods().checkValueExistInArray(
        MYPROFILE['_id'], "following", "userInformation", userId);
  }

  Future followUser(String userId) async {
    Map<String, dynamic> followingInformation = {"userInformation": userId};
    Map<String, dynamic> followersInformation = {
      "userInformation": MYPROFILE['_id']
    };
    if (!isFollowingUser) {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], followingInformation, "following");
      await UserMethods()
          .editUserArrayField(userId, followersInformation, "followers");
    } else {
      await UserMethods().deleteUserArrayField(
          MYPROFILE['_id'], followingInformation, "following");
      await UserMethods()
          .deleteUserArrayField(userId, followersInformation, "followers");
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

    isLikeClicked = !isLikeClicked;
    if (isLikeClicked) {
      if (isDislikeClicked) {
        isDislikeClicked = false;
        dislikeCount.value--;
        dislikeButtonColor = Colors.white;
      }
      likeButtonColor = Colors.blue;
      likeCount.value++;
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
    isDislikeClicked = !isDislikeClicked;
    if (isDislikeClicked) {
      if (isLikeClicked) {
        isLikeClicked = false;
        likeCount.value--;
        likeButtonColor = Colors.white;
      }
      dislikeButtonColor = Colors.red;
      dislikeCount.value++;
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

  /* start : working on comments */

  RxInt commentsCount = 0.obs;
  bool isCommentLikeClicked = false;
  Color commentLikeButtonColor = Colors.white;
  bool isCommentDislikeClicked = false;
  Color commentDislikeButtonColor = Colors.white;
  dynamic fetchComments = Future.value().obs;
  RxList allComments = [].obs;
  dynamic fetchReply_ = Future.value().obs;
  RxString viewRepliesText = "".obs;

  void initializeComments(String videoId) {
    fetchComments = fetchAllComments(videoId);
  }

  bool isUserAlreadyCommentedVideo = false;
  void userAlreadyCommented() {
    isUserAlreadyCommentedVideo = allComments.any((comment) {
      String userId = comment['userInformation']['_id'];
      if (userId == MYPROFILE['_id']) {
        return true;
      }
      return false;
    });
  }

  Future updateComments(String videoId, String data) async {
    if (!isUserAlreadyCommentedVideo) {
      Map<String, dynamic> comment = {
        "comment": data,
        "userInformation": MYPROFILE['_id']
      };
      await VideoMethods().editVideoArrayField(videoId, comment, "comments");
      Get.snackbar("Comment", "Comment added successfully");
    } else {
      Get.snackbar("Comment", "You can add one comment per video");
    }
  }

  Future fetchAllComments(String videoId) async {
    allComments.value = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "comments");
    print("all comments : $allComments");
    userAlreadyCommented();
  }

  Future deleteComment(String videoId) async {
    Map<String, dynamic> comment = {"userInformation": MYPROFILE['_id']};
    await VideoMethods().deleteVideoArrayField(videoId, comment, "comments");
    Get.snackbar("Comment", "Comment deleted successfully");
  }

  void changeCommentLike(String id) {
    isCommentLikeClicked = !isCommentLikeClicked;
    if (isCommentLikeClicked) {
      if (isCommentLikeClicked) {
        isCommentLikeClicked = false;
        dislikeCount.value--;
        commentDislikeButtonColor = Colors.white;
      }
      likeButtonColor = Colors.blue;
      likeCount.value++;
    } else {
      isDislikeClicked = false;
      likeButtonColor = Colors.white;
      likeCount.value--;
    }
    videoMethods.editVideo(
        id, {"likeCount": likeCount.value, "dislikeCount": dislikeCount.value});
  }

  void changeCommentDislike(String id) {
    isDislikeClicked = !isDislikeClicked;
    if (isDislikeClicked) {
      if (isLikeClicked) {
        isLikeClicked = false;
        likeCount.value--;
        likeButtonColor = Colors.white;
      }
      dislikeButtonColor = Colors.red;
      dislikeCount.value++;
    } else {
      isLikeClicked = false;
      dislikeButtonColor = Colors.white;
      dislikeCount.value--;
    }
    videoMethods.editVideo(
        id, {"dislikeCount": dislikeCount.value, "likeCount": likeCount.value});
  }

  void increaseComments(int commentCount) {
    commentsCount.value = commentCount;
  }
  /* end : working on comments */

  /* start : working on report video */

  Rx<ReportReason> selectedReportReason = ReportReason.notProgramming.obs;
  void updateReportReason(ReportReason reason) {
    selectedReportReason.value = reason;
  }
  /* end : working on report video */

  /* start : working on follow and unfollow */

  /* end : working on follow and unfollow */

  // @override
  // void onInit() {
  //   commentsCount.value = currentVideo['comments'].length;
  //   likeCount.value = currentVideo['likeCount'];
  //   dislikeCount.value = currentVideo['dislikeCount'];
  //   print("comments : ${currentVideo['comments'].length}");
  //   shareCount.value = currentVideo['shareCount'];
  //   videoDescription.value = currentVideo['description'].length >= 25
  //       ? "${currentVideo["description"].substring(0, 25)} ..."
  //       : currentVideo['description'];
  //   controller =
  //       VideoPlayerController.network("$getVideo/${currentVideo['videoPath']}")
  //         ..initialize();

  //   super.onInit();
  // }

  // @override
  // void onInit() {
  //   videos1 = ALLVIDEOS;
  //   id = videos1['_id'];
  //   print("id : $id");
  //   videoDescription.value = videos1["description"].substring(0, 24);
  //   videoPath = videos1['videoPath'];
  //   likeCount.value = videos1['likeCount'];
  //   dislikeCount.value = videos1['dislikeCount'];
  //   commentsCount.value = videos1['comments'].length;
  //   shareCount.value = videos1['shareCount'];
  //   controller = VideoPlayerController.network("$getVideo/$videoPath")
  //     ..initialize();
  //   // controller = VideoPlayerController.network("$getVideo/$videoPath")
  //   //   ..initialize().then((_) {
  //   //     // Use the ever method to observe changes in the controller value
  //   //     ever(controller.obs, (_) {
  //   //       // This callback will be triggered whenever the controller value changes
  //   //       // Update any UI components here
  //   //       update(); // Notify GetX to update the UI
  //   //     });
  //   //   });
  //   print("video path: $getVideo/$videoPath");
  //   // controller = VideoPlayerController.asset(localVideoPath)..initialize();

  //   super.onInit();
  // }

  // final controller = VideoPlayerController.asset("assets/videos/video.mp4")
  //   ..initialize();
}
