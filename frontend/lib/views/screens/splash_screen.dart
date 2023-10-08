import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/views/signup/login_screen.dart';
import '../../constants.dart';
import '../../get/profile/get_profile_fetch.dart';
import '../../get/videos/get_all_videos.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // fetching profile details
    if (FirebaseAuth.instance.currentUser != null) {
      Get.put(FetchProfileController()).fetchMyProfile();
    }
    Timer(const Duration(seconds: 2), () {
      Get.off(() => FirebaseAuth.instance.currentUser != null
          ? const HomeScreen()
          : LoginScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Splash Screen"),
      ),
      body: const Center(
          child: CircleAvatar(
        radius: 100,
        backgroundImage: AssetImage(logo),
      )),
    );
  }
}
