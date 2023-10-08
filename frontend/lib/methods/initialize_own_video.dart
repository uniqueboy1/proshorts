import 'package:get/get.dart';
import 'package:pro_shorts/controllers/video.dart';
import 'package:pro_shorts/get/videos/get_own_video.dart';

Future initializeOwnVideo(String videoId) async {
  String videoDescription = await VideoMethods()
      .fetchSpecificVideosField("_id", videoId, "description");

  OwnVideoController ownVideoController = Get.put(OwnVideoController());
  ownVideoController.resetValue(videoDescription.length >= 25
      ? "${videoDescription.substring(0, 25)} ..."
      : videoDescription);

}
