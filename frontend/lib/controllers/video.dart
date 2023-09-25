import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import "package:http/http.dart" as http;
import '../constants.dart';
import '../views/profile/own_profile_screen.dart';

class VideoMethods {
  void uploadVideo(File videoPath, String videoName) async {
    // uploading video separately
    final uploadVideoAPI = Uri.parse(uploadVideoURL);
    final file = videoPath;
    final videoStream = http.ByteStream(file.openRead());
    final length = await file.length();

    final request = http.MultipartRequest('POST', uploadVideoAPI);
    final multipartFile = http.MultipartFile(
      'video', // Field name on the server
      videoStream,
      length,
      filename: videoName,
    );

    request.files.add(multipartFile);

    final response = await request.send();
    // it will return actual response send from node js
    String responseString = await response.stream.bytesToString();
    Map actualResponseString = jsonDecode(responseString);
    print("video upload : ${responseString}");

    if (actualResponseString['success']) {
      print('POST request successful');
      print('Response: ${actualResponseString}');
    } else {
      print(
          'POST request failed with status: ${actualResponseString['message']}');
    }
  }

  void uploadThumbnail(String thumbnailPath, String thumbnailName) async {
    // uploading thumbnail image
    final uploadThumbnail = Uri.parse(THUMBNAIL_URL);

    var requestThumbnail = http.MultipartRequest('POST', uploadThumbnail);
    requestThumbnail.files.add(await http.MultipartFile.fromPath(
        'thumbnail', thumbnailPath,
        filename: thumbnailName));

    final thumbnailResponse = await requestThumbnail.send();
    // it will return actual response send from node js
    String thumbnailResponseString =
        await thumbnailResponse.stream.bytesToString();
    Map actualthumbnailResponseString = jsonDecode(thumbnailResponseString);
    print("profile photo upload : $thumbnailResponseString");

    if (actualthumbnailResponseString['success']) {
      print('POST request successful');
      print('Response: $actualthumbnailResponseString');
    } else {
      print(
          'POST request failed with status: ${actualthumbnailResponseString['message']}');
    }
  }

  Future<Map<String, dynamic>> addVideo(Map video, File videoPath,
      String videoName, String thumbnailPath, String thumbnailName) async {
    try {
      final addVideoAPI = Uri.parse(addVideoURL);
      uploadVideo(videoPath, videoName);
      uploadThumbnail(thumbnailPath, thumbnailName);

      // uploading video data
      final headers = {
        'Content-Type': 'application/json',
      };
      final videoResponse = await http.post(addVideoAPI,
          headers: headers, body: jsonEncode(video));
      print("video response: ${videoResponse.body}");
      Map actualVideoResponse = jsonDecode(videoResponse.body);
      print("actual video response: ${actualVideoResponse['success']}");

      if (actualVideoResponse['success']) {
        print('POST request successful');
        print('Response: ${actualVideoResponse}');
        print("upload video response: ${actualVideoResponse['response']}");
      } else {
        print(
            'POST request failed with status: ${actualVideoResponse['message']}');
      }
      return actualVideoResponse['response'];
    } catch (error) {
      print("Error while uploading video : $error");
      return {};
    }
  }

  Future<List> fetchAllVideos() async {
    try {
      final URL = Uri.parse(allVideosURL);
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while fetching all videos : $error");
      return [];
    }
  }

   Future<List> fetchFollowingVideos(String userId) async {
    try {
      final URL = Uri.parse("$FOLLOWING_VIDEOS_URL/$userId");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while fetching following videos : $error");
      return [];
    }
  }

  Future<List> fetchSpecificVideosField(
      String searchField, String searchValue, String returnField) async {
    try {
      final URL = Uri.parse(
          "$RETURN_VIDEO_FIELD_URL/$searchField/$searchValue/$returnField");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'][0][returnField];
    } catch (error) {
      print("error while fetching specifc video field : $error");
      return [];
    }
  }

  Future<List> fetchVideosByField(String field, String value) async {
    try {
      final URL = Uri.parse("$READ_VIDEO_BY_FIELD_URL/$field/$value");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while fetching videos : $error");
      return [];
    }
  }

  Future<List> fetchVideosByTwoField(
      String field1, String value1, String field2, String value2) async {
    final URL = Uri.parse(
        "${READ_VIDEO_BY_TWO_FIELD_URL}/$field1/$value1/$field2/$value2");
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    print("actual response: ${actualResponse['response']}");
    return actualResponse['response'];
  }

  Future<List> fetchTopVideos() async {
    try {
      final URL = Uri.parse(TOP_VIDEOS_URL);
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while fetching top videos : $error");
      return [];
    }
  }

  Future<List> searchVideos(String searchTerm) async {
    try {
      final URL =
          Uri.parse("$SEARCH_VIDEO_URL?search_term=$searchTerm&limit=10");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("Error while searching videos : $error");
      return [];
    }
  }

  Future<List> filterVideos(
      String searchTerm, List categories, String likes, String views) async {
    String filteredOptions = "";
    if (categories.isNotEmpty) {
      for (String category in categories) {
        filteredOptions += "category=$category&";
      }
      // removing last & sign
      filteredOptions =
          filteredOptions.substring(0, filteredOptions.length - 1);
    }
    if (likes != "none") {
      filteredOptions += "&likes=$likes";
    }
    if (views != "none") {
      filteredOptions += "&views=$views";
    }
    if (searchTerm.isNotEmpty) {
      filteredOptions += "&search_term=$searchTerm";
    }
    print("filtered options: " + filteredOptions);
    final URL = Uri.parse("$FILTER_VIDEO_URL?$filteredOptions&limit=10");
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    return actualResponse['response'];
  }

  Future<void> editVideo(String id, Map<String, dynamic> data) async {
    try {
      final url = '$editVideoURL/$id';
      final response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      final actualResponse = jsonDecode(response.body);
      print("like count : $actualResponse");

      if (actualResponse['success']) {
        print('Video updated successfully');
      } else {
        print(
            'Failed to update data. Status code: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error occurred while updating video : $error");
    }
  }

  Future editVideoArrayField(
      String id, Map<String, dynamic> data, String field) async {
    try {
      final String apiUrl = '$EDIT_VIDEO_ARRAY_FIELD_URL/$id/$field';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('Video ${field} updated successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating ${field} : $error");
    }
  }

  Future editVideoArrayArrayField(String videoId, String fieldId, String field1,
      String field2, Map<String, dynamic> data) async {
    try {
      final String apiUrl =
          '$EDIT_VIDEO_ARRAY_ARRAY_FIELD_URL/$videoId/$fieldId/$field1/$field2';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('Video ${field1} updated successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating ${field1} : $error");
    }
  }

  Future deleteVideoArrayField(
      String id, Map<String, dynamic> data, String field) async {
    try {
      final String apiUrl = '$DELETE_VIDEO_ARRAY_FIELD_URL/$id/$field';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('Video ${field} deleted successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while deleting ${field} : $error");
    }
  }
}
