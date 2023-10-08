import 'package:get/get.dart';

class OwnProfileController extends GetxController {
  RxInt visibilityIndex = 0.obs;
  RxBool isButtonClicked = true.obs;
  RxInt totalViews = RxInt(0);

  void changeVideoScreen(int index) {
    visibilityIndex.value = index;
    isButtonClicked.value = !isButtonClicked.value;
    print("own profile button : ${isButtonClicked.value}");
  }

  void reset() {
    visibilityIndex.value = 0;
    isButtonClicked.value = true;
  }
}
