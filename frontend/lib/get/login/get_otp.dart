import 'package:get/get.dart';

class OTPController extends GetxController {
  RxInt timer = 60.obs;
  void changeTimer() {
    timer.value--;
  }
}
