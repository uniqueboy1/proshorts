// FutureBuilder(
//                     future: initializeVideo(allVideos[index][
//                         'videoPath']), // The Future<T> that you want to monitor
//                     builder: (BuildContext context, AsyncSnapshot snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         // Display a loading indicator while waiting for the Future to complete
//                         return Center(child: const CircularProgressIndicator());
//                       } else if (snapshot.hasError) {
//                         // Display an error message if the Future throws an error
//                         return Text('Error: ${snapshot.error}');
//                       } else {

//                       }
//                     });