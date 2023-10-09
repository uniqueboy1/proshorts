import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/admin/admin_screen.dart';
import 'package:pro_shorts/admin/view_public_videos.dart';
import 'package:pro_shorts/admin/view_users.dart';
import 'package:pro_shorts/firebase_options.dart';
import 'package:pro_shorts/views/home_screen/home_screen.dart';
import 'package:pro_shorts/views/home_screen/search.dart';
import 'package:pro_shorts/views/screens/splash_screen.dart';
import 'package:pro_shorts/views/settings/settings.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
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
      // "/": (context) =>  LoginScreen(),
      "/": (context) => const SplashScreen(),
      "/settings": (context) => const Settings(),
      "/search": (context) => const Search(),
      "/home_screen": (context) => const HomeScreen(),
      "/own_profile_screen": (context) => const OwnProfileScreen()
    },
    debugShowCheckedModeBanner: false,
  ));
}
