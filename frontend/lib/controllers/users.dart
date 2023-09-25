import 'dart:convert';

import 'package:get/get.dart';
import 'package:pro_shorts/constants.dart';
import "package:http/http.dart" as http;

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
        FETCHPROFILECONTROLLER.profileSetup();
      } else {
        print('Error: ${actualResponse['message']}');
      }
    } catch (error) {
      print("Error while updating profile : $error");
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

  Future<List> fetchSpecificUserField(
      String searchField, String searchValue, String returnField) async {
    try {
      final URL = Uri.parse(
          "$RETURN_USER_FIELD_URL/$searchField/$searchValue/$returnField");
      final response = await http.get(URL);
      final actualResponse = jsonDecode(response.body);
      return actualResponse['response'][0][returnField];
    } catch (error) {
      print("error while fetching specifc user field : $error");
      return [];
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
      return null;
    }
  }
}
