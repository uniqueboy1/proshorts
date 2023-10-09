import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:video_player/video_player.dart';

class ViewVideoController extends GetxController {
  RxString videoDescription = "".obs;
  bool isSeeMoreClicked = false;
  RxString seeMore = "SEE MORE".obs;
  RxInt commentsCount = 0.obs;

  RxString selectedVideoMode = "".obs;

  Future changeVideoMode(String videoMode, String videoId) async {
    selectedVideoMode.value = videoMode;
    Map<String, dynamic> videoInformation = {"videoInformation": videoId};
    await VideoMethods().editVideo(videoId, {"videoMode": videoMode});
    await UserMethods().deleteUserArrayField(
        MYPROFILE['_id'], videoInformation, "private_videos");
    await UserMethods().deleteUserArrayField(
        MYPROFILE['_id'], videoInformation, "public_videos");
    if (videoMode.toLowerCase() == "public") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "public_videos");
    } else if (videoMode.toLowerCase() == "private") {
      await UserMethods().editUserArrayField(
          MYPROFILE['_id'], videoInformation, "private_videos");
    }
  }

  Future updateComments(String videoId) async {
    List comments = await VideoMethods()
        .fetchSpecificVideosField("_id", videoId, "comments");
    commentsCount.value = comments.length;
  }

  void resetValue(String description) {
    isSeeMoreClicked = false;
    seeMore.value = "SEE MORE";
    videoDescription.value = description;
  }

  void toogleSeeMore(String description) {
    isSeeMoreClicked = !isSeeMoreClicked;
    if (isSeeMoreClicked) {
      seeMore.value = "SEE LESS";
      videoDescription.value = description;
    } else {
      seeMore.value = "SEE MORE";
      videoDescription.value = description.length >= 25
          ? "${description.substring(0, 25)} ..."
          : description;
    }
  }

  RxBool isVideoPlaying = false.obs;

  void showPlayPauseIcon(VideoPlayerController videoPlayerController) {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
    isVideoPlaying.value = videoPlayerController.value.isPlaying;
  }
}
