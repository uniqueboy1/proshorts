import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:video_player/video_player.dart';
import '../../controllers/video.dart';

enum OtherVideoReportReason {
  notProgramming,
  hateHarrasement,
  nuditySexual,
  misinformation
}

class OtherVideoController extends GetxController {
  VideoMethods videoMethods = VideoMethods();
  RxInt shareCount = 0.obs;
  RxInt commentsCount = 0.obs;
  RxInt viewsCount = 0.obs;
  Map<String, dynamic> currentVideo = {};

  void initializeVideoDetails(Map<String, dynamic> video) {
    viewsCount.value = video['viewsCount'];
    commentsCount.value = video['comments'].length;
    likeCount.value = video['likeCount'];
    dislikeCount.value = video['dislikeCount'];
    shareCount.value = video['shareCount'];
    videoDescription.value = video['description'].length >= 25
        ? "${video["description"].substring(0, 25)} ..."
        : video['description'];
    isSeeMoreClicked = false;
    isVideoPlaying.value = false;
    seeMore.value = "SEE MORE";
    isUserAlreadyLikedDislikedVideo();
    if (isFollowingUser) {
      followIcon.value = Icons.check;
    } else {
      followIcon.value = Icons.add;
    }
  }

  // Future fetchCurrentVideo(String videoId) async {
  //   List videos = await VideoMethods().fetchVideosByField("_id", videoId);
  // }

  Future initializeVideo(Map<String, dynamic> video) async {
    String videoPath = video['videoPath'];
    String videoId = video['_id'];
    currentVideo = video;
    // await fetchCurrentVideo(videoId);
    await fetchLikedDislikedVideos();
    await isFollowing(video['userInformation']['_id']);
    controller = VideoPlayerController.network("$getVideo/$videoPath")
      ..initialize();
    initializeVideoDetails(video);
  }

// to update follow icon in video screen
  Future changeFollowIcon(String userId) async {
    await isFollowing(userId);
    if (isFollowingUser) {
      followIcon.value = Icons.check;
    } else {
      followIcon.value = Icons.add;
    }
  }

  /* start : working on following */
  Rx<IconData> followIcon = Icons.add.obs;

  Future updateFollowIcon(String userId) async {
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
  bool isLikeClicked = false;
  Color likeButtonColor = Colors.white;
  bool isDislikeClicked = false;
  Color dislikeButtonColor = Colors.white;

// updating like
  Future changeLike(String videoId) async {
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

  Future changeDislike(String videoId) async {
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
  VideoPlayerController controller =
      VideoPlayerController.asset('assets/actual_video.mp4');
  RxBool isVideoPlaying = false.obs;
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

  Rx<OtherVideoReportReason> selectedReportReason =
      OtherVideoReportReason.notProgramming.obs;
  void updateReportReason(OtherVideoReportReason reason) {
    selectedReportReason.value = reason;
  }
  /* end : working on report video */
}
