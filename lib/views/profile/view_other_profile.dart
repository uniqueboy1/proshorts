import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/settings/settings.dart';
import 'package:pro_shorts/views/profile/draft_video.dart';
import 'package:pro_shorts/views/profile/private_videos.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';

class ViewOtherProfile extends StatefulWidget {
  ViewOtherProfile({Key? key}) : super(key: key);

  @override
  State<ViewOtherProfile> createState() => _ViewOtherProfileState();
}

class _ViewOtherProfileState extends State<ViewOtherProfile> {

  int visibilityIndex = 0;
  String followText = "Follow";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile Screen"),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text(
            "name",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          const CircleAvatar(
            backgroundImage: AssetImage(logo),
            radius: 35,
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            "username",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "your bio",
              style: TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: const [
                  Text(
                    "20K",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    "10",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Column(
                children: const [
                  Text(
                    "400K",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Total Views",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(onPressed: (){
                if(followText == "Follow"){
                  followText = "Unfollow";
                }
                else{
                  followText = "Follow";
                }
                setState(() {
                  
                });

              }, child: Text(followText)),
              const FaIcon(FontAwesomeIcons.youtube),
              const FaIcon(FontAwesomeIcons.instagram),
              const FaIcon(FontAwesomeIcons.twitter),
              ElevatedButton(onPressed: () {}, child: const Text("HIRE ME"))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left : 10),
                child: Text("Uploaded Videos"),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          PublicVideos()
        ],
      ),
    );
  }
}
