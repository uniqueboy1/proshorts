import 'package:get/get.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/videos/get_other_video.dart';

Future<Map<String, dynamic>> initializeVideo(String videoId) async {
  List video = await VideoMethods().fetchVideosByField("_id", videoId);
  Map<String, dynamic> currentVideo = video[0];
  await Get.put(OtherVideoController()).initializeVideo(currentVideo);
  return currentVideo;
}
