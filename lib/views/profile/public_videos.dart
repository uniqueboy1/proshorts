

import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';
import 'package:video_player/video_player.dart';

class PublicVideos extends StatelessWidget {
PublicVideos({ Key? key }) : super(key: key);
final VideoPlayerController controller = VideoPlayerController.asset(videoPath)..initialize();
  @override
  Widget build(BuildContext context){
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10
          ), 
          itemBuilder: (context, index){
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: VideoPlayer(controller),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Text("10K", style: TextStyle(color: white, fontSize: 20),)
                  
                  )
              ],
            );
          
          },
          
          ),
      ),
    );
  }
}