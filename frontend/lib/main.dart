import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path/path.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/node.dart';
import 'package:pro_shorts/test.dart';
import 'package:pro_shorts/views/home_screen/make_notes.dart';
import 'package:pro_shorts/views/home_screen/search.dart';
import 'package:pro_shorts/views/home_screen/selected_video.dart';
import 'package:pro_shorts/views/home_screen/upload_video.dart';
import 'package:pro_shorts/views/profile/followers_following.dart';
import 'package:pro_shorts/views/profile/no_profile.dart';
import 'package:pro_shorts/views/profile/setup_profile.dart';
import 'package:pro_shorts/views/profile/setup_profile_options.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';
import 'package:pro_shorts/views/signup/forgot_password.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import 'package:pro_shorts/views/signup/otp.dart';
import 'package:pro_shorts/views/signup/signup_screen.dart';
import 'package:pro_shorts/views/settings/account_information.dart';
import 'package:pro_shorts/views/settings/change_password.dart';
import 'package:pro_shorts/views/settings/watch_history.dart';
import 'package:pro_shorts/views/home_screen/add_video.dart';
import 'package:pro_shorts/views/home_screen/home_screen.dart';
import 'package:pro_shorts/views/screens/splash_screen.dart';
import 'package:pro_shorts/views/settings/settings.dart';
import 'package:pro_shorts/views/home_screen/comment.dart';
import 'package:pro_shorts/views/widgets/home_screen/video_details_input.dart';
import 'package:pro_shorts/views/widgets/snackbar.dart';
import 'firebase_options.dart';
import 'views/profile/own_profile_screen.dart';

bool isUserLoggedIn() {
  if (FirebaseAuth.instance.currentUser != null) {
    return true;
  }
  return false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(GetMaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => const SplashScreen(),
      "/search": (context) => const Search(),
      "/home_screen": (context) => const HomeScreen(),
      "/own_profile_screen": (context) => const OwnProfileScreen()
    },
    debugShowCheckedModeBanner: false,
  ));
}
