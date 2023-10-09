import 'dart:convert';

import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import "package:http/http.dart" as http;
import 'package:pro_shorts/controllers/profile.dart';
import 'package:pro_shorts/controllers/video.dart';

import '../views/profile/own_profile_screen.dart';

class UserMethods {
  Future addUser(Map<String, dynamic> user) async {
    try {
      final addUserURL = Uri.parse(ADD_USER_URL);
      final headers = {
        'Content-Type': 'application/json',
      };
      final response =
          await http.post(addUserURL, headers: headers, body: jsonEncode(user));
      print("user response: ${response.body}");
      Map actualResponse = jsonDecode(response.body);
      print("actual user response: ${actualResponse['success']}");

      if (actualResponse['success']) {
        print('POST request successful');
        print('Response: $actualResponse');
      } else {
        print('POST request failed with status: ${actualResponse['message']}');
      }
      Get.snackbar("User", "SignUp Successfully");
    } catch (error) {
      print("Error while creating profile : $error");
    }
  }

  Future<List> fetchUsersByField(String field, String value) async {
    try {
      final URL = Uri.parse("${READ_USER_BY_FIELD_URL}/$field/$value");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error occurred while fetching user : $error");
      return [];
    }
  }

  Future<List> fetchTopUsers() async {
    final URL = Uri.parse(TOP_USER_URL);
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    return actualResponse['response'];
  }

  Future<List> searchUsers(String searchTerm) async {
    final URL = Uri.parse("$SEARCH_USER_URL?search_term=$searchTerm&limit=10");
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    return actualResponse['response'];
  }

  Future<List> filterUsers(String searchTerm, String followers) async {
    String filteredOptions = "";
    if (followers != "none") {
      filteredOptions += "&followers=$followers";
    }
    if (searchTerm.isNotEmpty) {
      filteredOptions += "&search_term=$searchTerm";
    }
    print("filtered options: " + filteredOptions);
    final URL = Uri.parse("$FILTER_USER_URL?$filteredOptions&limit=10");
    final response = await http.get(URL);
    final actualResponse = jsonDecode(response.body);
    return actualResponse['response'];
  }

  Future editUser(String id, Map<String, dynamic> data) async {
    try {
      final String apiUrl = '$EDIT_USER_URL/$id';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('User updated successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating profile : $error");
    }
  }

    Future<dynamic> fetchAllUsers() async {
    try {
      final URL = Uri.parse(ALL_USERS_URL);
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while fetching all videos : $error");
      return "error";
    }
  }

  Future editUserArrayField(
      String id, Map<String, dynamic> data, String field) async {
    try {
      final String apiUrl = '$EDIT_USER_ARRAY_FIELD_URL/$id/$field';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('User ${field} updated successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating ${field} : $error");
    }
  }

  Future deleteUserArrayField(
      String id, Map<String, dynamic> data, String field) async {
    try {
      final String apiUrl = '$DELETE_USER_ARRAY_FIELD_URL/$id/$field';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('User ${field} deleted successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while deleting ${field} : $error");
    }
  }

  Future<dynamic> fetchSpecificUserField(
      String searchField, String searchValue, String returnField) async {
    try {
      final URL = Uri.parse(
          "$RETURN_USER_FIELD_URL/$searchField/$searchValue/$returnField");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      if (actualResponse['response'][0].containsKey(returnField)) {
        return actualResponse['response'][0][returnField];
      } else {
        return null;
      }
    } catch (error) {
      print("error while fetching specifc user field : $error");
      return "error";
    }
  }

  Future<dynamic> checkValueExistInArray(
      String userId, String field, String key, String checkValue) async {
    try {
      final URL = Uri.parse(
          "$CHECK_VALUE_EXIST_IN_ARRAY_USER_URL/$userId/$field/$key/$checkValue");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error while checking value in array user field : $error");
      return "error";
    }
  }

  Future updateArrayField(String userId, String field1, String field2,
      String updateId, Map<String, dynamic> data) async {
    try {
      final String apiUrl =
          '$UPDATE_USER_ARRAY_FIELD_URL/$userId/$field1/$field2/$updateId';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('User ${field1} updated successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating ${field1} : $error");
    }
  }

  Future<void> deleteUserById(String id) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
      };
      // getting user information to delete actual videos, thumbnails and profile photo
      final userURL = Uri.parse("$READ_USER_BY_ID_URL/$id");
      final user = await http.get(userURL, headers: headers);
      final tempUser = jsonDecode(user.body);
      final actualUser = tempUser['response'];
      print("actual user: $actualUser");

      if (actualUser.containsKey("profileInformation")) {
        String profileName = actualUser['profileInformation']['profilePhoto'];
        await SetupProfile().deleteProfilePhoto(profileName);
      }

      List public_videos = actualUser['public_videos'];
      List private_videos = actualUser['private_videos'];

      for (Map<String, dynamic> video in public_videos) {
        String thumbnailName = video['videoInformation']['thumbnailName'];
        String videoPath = video['videoInformation']['videoPath'];
        await VideoMethods().deleteVideoThumbnail(thumbnailName);
        await VideoMethods().deleteActualVideo(videoPath);
      }

      for (Map<String, dynamic> video in private_videos) {
        String thumbnailName = video['videoInformation']['thumbnailName'];
        String videoPath = video['videoInformation']['videoPath'];
        await VideoMethods().deleteVideoThumbnail(thumbnailName);
        await VideoMethods().deleteActualVideo(videoPath);
      }

      final URL = Uri.parse("$DELETE_USER_URL/$id");

      final response = await http.delete(URL, headers: headers);
      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print("Video Deleted successfully");
      } else {
        print("Error while deleting video : ${actualResponse['message']}");
      }
    } catch (error) {
      print("error while deleting video : $error");
    }
  }
}
