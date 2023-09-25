import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';

class ViewOtherProfile extends StatefulWidget {
  Map<String, dynamic> userInformation;
  ViewOtherProfile({Key? key, required this.userInformation}) : super(key: key);

  @override
  State<ViewOtherProfile> createState() => _ViewOtherProfileState();
}

class _ViewOtherProfileState extends State<ViewOtherProfile> {
  int visibilityIndex = 0;
  String followText = "Follow";
  int totalViews = 0;
  void countViews() {
    List uploadedVideos = widget.userInformation['uploaded_videos'];
    for (Map video in uploadedVideos) {
      totalViews += int.parse(video['viewsCount'].toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> profileInformation =
        widget.userInformation['profileInformation'];
    List followers = widget.userInformation['followers'];
    List following = widget.userInformation['following'];
    List uploadedVideos = widget.userInformation['uploaded_videos'];
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
          Text(
            profileInformation['name'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
           CircleAvatar(
            backgroundImage: NetworkImage(
                "$getProfilePhoto/${profileInformation['profilePhoto']}"),
            radius: 35,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            profileInformation['username'],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              profileInformation['bio'],
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "${followers.length}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "Followers",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "${following.length}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Following",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "$totalViews",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const Text(
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
              ElevatedButton(
                  onPressed: () {
                    if (followText == "Follow") {
                      followText = "Unfollow";
                    } else {
                      followText = "Follow";
                    }
                    setState(() {});
                  },
                  child: Text(followText)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Offstage(
                      offstage: profileInformation['youtubeURL'].isEmpty,
                      child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.youtube))),
                  Offstage(
                      offstage: profileInformation['instagramURL'].isEmpty,
                      child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.instagram))),
                  Offstage(
                      offstage: profileInformation['twitterURL'].isEmpty,
                      child: IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.twitter))),
                  Offstage(
                      offstage: profileInformation['portfolioURL'].isEmpty,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text("HIRE ME")))
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Uploaded Videos"),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          PublicVideos(
            email: widget.userInformation['email'],
          )
        ],
      ),
    );
  }
}
