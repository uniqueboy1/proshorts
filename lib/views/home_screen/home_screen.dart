import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';
import 'package:pro_shorts/views/home_screen/search.dart';
import 'package:pro_shorts/views/home_screen/video_screen.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavBar = 0;
  String forYou = "foryou";
  TextDecoration underline = TextDecoration.underline;

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double bottomNavBarHeight = AppBar().preferredSize.height;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.6),
          elevation: 0,
          actions: [
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        forYou = "following";
                        setState(() {});
                      },
                      child: Text(
                        "Following",
                        style: TextStyle(
                          color: white,
                          decoration: forYou == "following"
                              ? TextDecoration.underline
                              : TextDecoration.none,
                        ),
                      )),
                  TextButton(
                      onPressed: () {
                        forYou = "foryou";
                        setState(() {});
                      },
                      child: Text(
                        "For You",
                        style: TextStyle(
                            decoration: forYou == "foryou"
                                ? TextDecoration.underline
                                : TextDecoration.none,
                            color: white),
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Search()));
                      },
                      icon: Icon(Icons.search))
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            onTap: (index) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => bottomNavBar[index]));
            },
            currentIndex: selectedNavBar,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add), label: "Add Video"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile"),
            ]),
        body: VideoScreen(),
        // body: ListView.builder(
        //     itemCount: 5,
        //     itemBuilder: (context, index) {
        //       return SizedBox(
        //           height: size.height - appBarHeight - bottomNavBarHeight,
        //           child: VideoScreen());
        //     })
            
            );
  }
}
