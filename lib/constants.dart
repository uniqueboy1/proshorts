

// logo
import 'package:flutter/material.dart';
import 'package:pro_shorts/views/profile/setup_profile.dart';
import 'package:pro_shorts/views/home_screen/add_video.dart';

import 'package:pro_shorts/views/home_screen/video_screen.dart';
import 'package:pro_shorts/views/profile/draft_video.dart';
import 'package:pro_shorts/views/profile/private_videos.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';

import 'views/profile/watch_later.dart';

const String logo = "assets/images/logo.png";

// video
const String videoPath = "assets/videos/video.mp4";

// bottom navigation bar
List bottomNavBar = [
  VideoScreen(),
  AddVideo(),
  SetupProfile()
];


// colors
const Color white = Colors.white;
const Color black = Colors.black;
const Color red = Colors.red;
const Color green = Colors.green;


// public, private and draft section of profile screen
List videoVisibility = [
  PublicVideos(),
  PrivateVideos(),
  DraftVideos(),
  WatchLater()
];
