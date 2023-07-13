import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/settings/settings.dart';
import 'package:pro_shorts/views/profile/draft_video.dart';
import 'package:pro_shorts/views/profile/private_videos.dart';
import 'package:pro_shorts/views/profile/public_videos.dart';

class OwnProfileScreen extends StatefulWidget {
  OwnProfileScreen({Key? key}) : super(key: key);

  @override
  State<OwnProfileScreen> createState() => _OwnProfileScreenState();
}

class _OwnProfileScreenState extends State<OwnProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int visibilityIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Profile Screen"),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.notification_important)),
        actions:  [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: (){
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => Settings())
                  
                  );
              }, 
              icon: Icon(Icons.settings)
              ),
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: const [
            DrawerHeader(child: Text("Recent Notifications")),
            ListTile(
              title: Text("Notifications 1"),
            ),
            ListTile(
              title: Text("Notifications 2"),
            ),
            ListTile(
              title: Text("Notifications 3"),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          ElevatedButton(onPressed: () {}, child: const Text("Edit Profile")),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                tooltip: "Public Videos",
                  onPressed: () {
                    visibilityIndex = 0;
                    setState(() {});
                  },
                  icon: Icon(Icons.public, color: red)),
              IconButton(
                tooltip: "Private Videos",
                  onPressed: () {
                    visibilityIndex = 1;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.lock,
                  )),
              IconButton(
                tooltip: "Draft Videos",
                  onPressed: () {
                    visibilityIndex = 2;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.drafts,
                  )),

                  IconButton(
                tooltip: "Watch Later",
                  onPressed: () {
                    visibilityIndex = 3;
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.watch_later,
                  )),
            ],
          ),
          videoVisibility[visibilityIndex]
        ],
      ),
    );
  }
}
