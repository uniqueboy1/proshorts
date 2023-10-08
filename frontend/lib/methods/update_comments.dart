import 'package:get/get.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/home_screen/get_video_screen.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';

Future updateVideoComments(String videoId) async {
  List comments =
      await VideoMethods().fetchSpecificVideosField("_id", videoId, "comments");
  Get.put(OtherVideoController()).commentsCount.value = comments.length;
  Get.put(VideoScreenController()).updateComments(videoId);
  Get.put(OwnVideoController()).updateComments(videoId);
}
