import 'package:get/get.dart';

import '../../controllers/users.dart';
import '../../controllers/video.dart';

class SearchVideoUserController extends GetxController {
  @override
  void onInit() {
    // fetching top videos and users initially
    fetchVideos.value = fetchTopVideos();
    fetchUsers.value = getTopUsers();
    // TODO: implement onInit
    super.onInit();
  }

  // top videos and top users related operations
  RxBool isTopVideos = true.obs;
  RxBool isInputChanged = false.obs;

// to update ui when user clicks on top videos or top users
  void topVideos(bool topVideo) {
    isTopVideos.value = topVideo;
  }

  // to show cancel icon

  void showCancelIcon(String input) {
    if (input.isNotEmpty) {
      isInputChanged.value = true;
    } else {
      isInputChanged.value = false;
    }
  }

  // video search related operations
  RxList searchedVideos = [].obs;
  Rx<Future> fetchVideos = Future.value().obs;

  Future fetchTopVideos() async {
    searchedVideos.value = await VideoMethods().fetchTopVideos();
  }

  Future searchVideos(String searchTerm) async {
    searchedVideos.value = await VideoMethods().searchVideos(searchTerm);
    print("search videos : $searchedVideos");
  }

  Future filterVideos(String searchTerm) async {
    searchedVideos.value = await VideoMethods()
        .filterVideos(searchTerm, userSelectCategory, likes.value, views.value);
    print("filter videos : $searchedVideos");
  }

// changing fetchVideos according to user actions
  void changeVideo(String searchTerm, String action) async {
    if (action == "search") {
      fetchVideos.value = searchVideos(searchTerm);
    } else if (action == "closeIcon") {
      fetchVideos.value = fetchTopVideos();
    } else if (action == "filter") {
      fetchVideos.value = filterVideos(searchTerm);
    }
  }

  // user search related operations

  Rx<Future> fetchUsers = Future.value().obs;
  RxList searchedUsers = [].obs;

  Future getTopUsers() async {
    searchedUsers.value = await UserMethods().fetchTopUsers();
  }

  Future searchUsers(String searchTerm) async {
    searchedUsers.value = await UserMethods().searchUsers(searchTerm);
    print("search users : $searchedUsers");
  }

  Future filterUsers(String searchTerm) async {
    searchedUsers.value =
        await UserMethods().filterUsers(searchTerm, followers.value);
    print("filter users : $searchedUsers");
  }

  void changeUser(String searchTerm, String action) async {
    if (action == "search") {
      fetchUsers.value = searchUsers(searchTerm);
    } else if (action == "closeIcon") {
      fetchUsers.value = getTopUsers();
    } else if (action == "filter") {
      fetchUsers.value = filterUsers(searchTerm);
    }
  }

// filter related
// video related filter
  List userSelectCategory = [].obs;
  RxString likes = "none".obs;
  RxString views = "none".obs;

  void highlightSelectedCategory(String option) {
    if (userSelectCategory.contains(option)) {
      userSelectCategory.remove(option);
    } else {
      userSelectCategory.add(option);
    }
  }

  void highlightSelectedLikes(String option) {
    if (option == likes.value) {
      likes.value = "none";
    } else {
      likes.value = option;
    }
  }

  void highlightSelectedViews(String option) {
    if (option == views.value) {
      views.value = "none";
    } else {
      views.value = option;
    }
  }

  void resetFilter() {
    userSelectCategory = [].obs;
    likes.value = "none";
    views.value = "none";
  }

  // user related filter
  RxString followers = "none".obs;
  void highlightSelectedFollowers(String option) {
    if (option == followers.value) {
      followers.value = "none";
    } else {
      followers.value = option;
    }
  }

  void resetUserFilter() {
    followers.value = "none";
  }
}
