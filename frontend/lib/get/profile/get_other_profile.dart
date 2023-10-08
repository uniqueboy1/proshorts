import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';

import '../../constants.dart';

class OtherProfileController extends GetxController {
  RxString followText = "Follow".obs;
  RxList followers = [].obs;

  Future fetchUser(String userId) async {
    List users = await UserMethods().fetchUsersByField("_id", userId);
    followers.value = users[0]['followers'];
    await isFollowing(userId);
    return users[0];
  }

  late bool isFollowingUser;
  Future isFollowing(String userId) async {
    Map<String, dynamic> user = await UserMethods().checkValueExistInArray(
        MYPROFILE['_id'], "following", "userInformation", userId);
        isFollowingUser = user['following'].isNotEmpty;
    if (isFollowingUser) {
      followText.value = "Unfollow";
    } else {
      followText.value = "Follow";
    }
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
    await fetchUser(userId);
  }

  Future updateFollowText(String userId) async {
    await isFollowing(userId);
    if (!isFollowingUser) {
      followText.value = "Unfollow";
      await followUser(userId);
    } else {
      followText.value = "Follow";
      await followUser(userId);
    }
  }
}
