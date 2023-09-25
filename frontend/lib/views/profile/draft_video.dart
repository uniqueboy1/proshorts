

import 'package:flutter/material.dart';
import 'package:pro_shorts/constants.dart';

class DraftVideos extends StatelessWidget {
const DraftVideos({ Key? key }) : super(key: key);

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
                  color: Colors.blueGrey,
                ),
                Center(child: Icon(Icons.drafts, color: white,)),
               
              ],
            );
          
          },
          
          ),
      ),
    );
  }
}