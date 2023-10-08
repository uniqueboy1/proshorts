// logo
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/controllers/users.dart';
import 'package:pro_shorts/views/home_screen/home_screen.dart';
import 'package:pro_shorts/views/profile/no_profile.dart';
import 'package:pro_shorts/views/profile/own_profile_screen.dart';
import 'package:pro_shorts/views/profile/setup_profile.dart';
import 'package:pro_shorts/views/home_screen/add_video.dart';
import 'package:pro_shorts/views/profile/private_videos.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';
import 'package:pro_shorts/views/profile/watch_later.dart';

import 'get/profile/get_profile_fetch.dart';
import 'get/videos/get_all_videos.dart';

const String logo = "assets/images/logo.png";

String currentVideoId = "";
String currentVideoUserId = "";

FetchProfileController fetchProfileController =
    Get.put(FetchProfileController());

Map<dynamic, dynamic> MYPROFILE = Get.put(FetchProfileController()).myProfile;

// video
const String localVideoPath = "assets/videos/video.mp4";

// bottom navigation bar
List bottomNavBar = [
  const HomeScreen(),
  Obx(
    () => (fetchProfileController.isProfileSetup.value)
        ? AddVideo()
        : SetupProfile(),
  ),
  Obx(() => (fetchProfileController.isProfileSetup.value)
      ? const OwnProfileScreen()
      : const NoProfileScreen())
];
var LOGIN_EMAIL = FirebaseAuth.instance.currentUser != null
    ? FirebaseAuth.instance.currentUser!.email
    : null;

// colors
const Color white = Colors.white;
const Color black = Colors.black;
const Color red = Colors.red;
const Color green = Colors.green;

// public, private and draft section of profile screen
List videoVisibility = [
  PublicVideos(
    userId: MYPROFILE['_id'],
  ),
  PrivateVideos(),
  const WatchLater()
];

// api endpoint
const port = 8000;
const ipAddress = "10.0.2.2";

// users related api
const ADD_USER_URL = 'http://$ipAddress:$port/users/add_user';
const DELETE_USER_URL = 'http://$ipAddress:$port/users/delete_user';
const UPDATE_USER_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/users/update_array_field';
const CHECK_VALUE_EXIST_IN_ARRAY_USER_URL =
    'http://$ipAddress:$port/users/check_value_exist_in_array';
const RETURN_USER_FIELD_URL = 'http://$ipAddress:$port/users/return_user_field';
const FILTER_USER_URL = 'http://$ipAddress:$port/users/filter_user';
const TOP_USER_URL = 'http://$ipAddress:$port/users/top_user';
const READ_USER_BY_FIELD_URL =
    'http://$ipAddress:$port/users/read_user_by_field';
const READ_USER_BY_ID_URL =
    'http://$ipAddress:$port/users/read_user';
const EDIT_USER_URL = 'http://$ipAddress:$port/users/edit_user';
const EDIT_USER_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/users/edit_user_array_field';
const DELETE_USER_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/users/delete_user_array_field';
const SEARCH_USER_URL = 'http://$ipAddress:$port/users/search_user';
const FOLLOWING_VIDEOS_URL = 'http://$ipAddress:$port/users/following_videos';

// video related api
const CHECK_VALUE_EXIST_IN_ARRAY_VIDEO_URL =
    'http://$ipAddress:$port/videos/check_value_exist_in_array';
const UPDATE_VIDEO_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/videos/update_array_field';
const EDIT_VIDEO_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/videos/edit_video_array_field';
const EDIT_VIDEO_ARRAY_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/videos/edit_video_array_array_field';
const RETURN_VIDEO_FIELD_URL =
    'http://$ipAddress:$port/videos/return_video_field';
const DELETE_VIDEO_ARRAY_FIELD_URL =
    'http://$ipAddress:$port/videos/delete_video_array_field';
const addVideoURL = 'http://$ipAddress:$port/videos/add_video';
const FILTER_VIDEO_URL = 'http://$ipAddress:$port/videos/filter_video';
const SEARCH_VIDEO_URL = 'http://$ipAddress:$port/videos/search_video';
const TOP_VIDEOS_URL = 'http://$ipAddress:$port/videos/top_videos';
const uploadVideoURL = 'http://$ipAddress:$port/upload_video';
const THUMBNAIL_URL = 'http://$ipAddress:$port/upload_thumbnail';
const GET_THUMBNAIL_URL = 'http://$ipAddress:$port/thumbnails';
const allVideosURL = 'http://$ipAddress:$port/videos/all_videos';
const getVideo = 'http://$ipAddress:$port/videos';
const editVideoURL = 'http://$ipAddress:$port/videos/edit_video';
const READ_VIDEO_BY_FIELD_URL =
    'http://$ipAddress:$port/videos/read_video_by_field';
const READ_VIDEO_BY_TWO_FIELD_URL =
    'http://$ipAddress:$port/videos/read_video_by_two_field';

// delete
const DELETE_VIDEO_URL = 'http://$ipAddress:$port/videos/delete_video';
const DELETE_ACTUAL_VIDEO_URL = 'http://$ipAddress:$port/delete_actual_video';
const DELETE_THUMBNAIL_URL = 'http://$ipAddress:$port/delete_thumbnail';

// profile related api
const UPLOAD_PROFILE_PHOTO_URL = 'http://$ipAddress:$port/upload_profile';
const DELETE_PROFILE_PHOTO_URL = 'http://$ipAddress:$port/delete_profile_photo';
const addProfileURL = 'http://$ipAddress:$port/profiles/add_profile';
const READ_PROFILE_BY_FIELD_URL =
    'http://$ipAddress:$port/profiles/read_profile_by_field';
const SEARCH_PROFILE_URL = 'http://$ipAddress:$port/profiles/search_profile';
const EDIT_PROFILE_URL = 'http://$ipAddress:$port/profiles/edit_profile';
const allProfilesURL = 'http://$ipAddress:$port/profiles/all_profiles';
const checkFieldExistance =
    'http://$ipAddress:$port/profiles/check_field_existance';
const getProfilePhoto = 'http://$ipAddress:$port/profiles';

// FetchProfileController FETCHPROFILECONTROLLER =
//     Get.put(FetchProfileController());
// Map<String, dynamic> MYPROFILE =
//     FETCHPROFILECONTROLLER.myOwnProfileDetails.isNotEmpty
//         ? FETCHPROFILECONTROLLER.myOwnProfileDetails[0]
//         : {};
