import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import "package:http/http.dart" as http;
import 'package:pro_shorts/controllers/users.dart';
import '../views/profile/own_profile_screen.dart';

class SetupProfile {
  void uploadProfilePhoto(String profilePhoto, String photoName) async {
    final uploadProfileAPI = Uri.parse(UPLOAD_PROFILE_PHOTO_URL);

    var request = http.MultipartRequest('POST', uploadProfileAPI);
    request.files.add(await http.MultipartFile.fromPath('profile', profilePhoto,
        filename: photoName));

    final response = await request.send();
    // it will return actual response send from node js
    String responseString = await response.stream.bytesToString();
    Map actualResponseString = jsonDecode(responseString);
    print("profile photo upload : $responseString");

    if (actualResponseString['success']) {
      print('POST request successful');
      print('Response: $actualResponseString');
    } else {
      print(
          'POST request failed with status: ${actualResponseString['message']}');
    }
  }

  Future addProfile(Map<String, dynamic> profile, String profilePhoto,
      String photoName) async {
    try {
      final addProfileAPI = Uri.parse(addProfileURL);
      uploadProfilePhoto(profilePhoto, photoName);

      final headers = {
        'Content-Type': 'application/json',
      };
      final profileResponse = await http.post(addProfileAPI,
          headers: headers, body: jsonEncode(profile));
      print("profile response: ${profileResponse.body}");
      Map actualProfileResponse = jsonDecode(profileResponse.body);
      print("actual profile response: ${actualProfileResponse}");

      // putting profile id on users collection
      String id = actualProfileResponse['response']['_id'];
      print("profile id : $id");
      print("user id : ${MYPROFILE['_id']}");
      UserMethods().editUser(MYPROFILE['_id'], {"profileInformation": id});

      print("actual profile response: ${actualProfileResponse['success']}");
      if (actualProfileResponse['success']) {
        print('POST request successful');
        print('Response: $actualProfileResponse');
      
      } else {
        print(
            'POST request failed with status: ${actualProfileResponse['message']}');
      }
    } catch (error) {
      print("Error while creating profile : $error");
    }
  }

  Future fetchOwnProfile() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$checkFieldExistance/email/${FirebaseAuth.instance.currentUser!.email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final actualResponse = jsonDecode(response.body);
      print("actual response : ${actualResponse['response']}");

      // if (actualResponse["success"]) {
      //   print("Profile fetched successfully");
      // } else {
      //   print(
      //       'Failed to fetch data. Status code: ${actualResponse['message']}');
      // }
      return actualResponse['response'];
    } catch (error) {
      print("Error while fetching profile : $error");
    }
  }

  void fetchCommentsAndProfiles() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$checkFieldExistance/email/${FirebaseAuth.instance.currentUser!.email}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      final actualResponse = jsonDecode(response.body);
      print("actual response : ${actualResponse['response']}");

      // if (actualResponse["success"]) {
      //   print("Profile fetched successfully");
      // } else {
      //   print(
      //       'Failed to fetch data. Status code: ${actualResponse['message']}');
      // }
      return actualResponse['response'];
    } catch (error) {
      print("Error while fetching profile : $error");
    }
  }

  Future deleteProfilePhoto(String profileName) async {
    try {
      final String apiUrl = '$DELETE_PROFILE_PHOTO_URL/$profileName';
      final response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('Deleted successfully');
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while deleting profile : $error");
    }
  }

  Future editProfile(String id, Map<String, dynamic> data) async {
    try {
      final String apiUrl = '$EDIT_PROFILE_URL/$id';
      final response = await http.put(Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      final actualResponse = jsonDecode(response.body);

      if (actualResponse['success']) {
        print('Profile updated successfully');
        
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating profile : $error");
    }
  }

  Future<List> fetchProfilesByField(String field, String value) async {
    try {
      final URL = Uri.parse("${READ_PROFILE_BY_FIELD_URL}/$field/$value");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'];
    } catch (error) {
      print("error occurred while fetching user : $error");
      return [];
    }
  }

}
