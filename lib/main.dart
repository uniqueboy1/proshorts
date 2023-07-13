import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pro_shorts/node.dart';
import 'package:pro_shorts/test.dart';
import 'package:pro_shorts/views/home_screen/make_notes.dart';
import 'package:pro_shorts/views/home_screen/search.dart';
import 'package:pro_shorts/views/home_screen/selected_video.dart';
import 'package:pro_shorts/views/home_screen/upload_video.dart';
import 'package:pro_shorts/views/profile/setup_profile.dart';
import 'package:pro_shorts/views/profile/view_other_profile.dart';
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
import 'firebase_options.dart';
import 'views/profile/own_profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
      GetMaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen()));
}
