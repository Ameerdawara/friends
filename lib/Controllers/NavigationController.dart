import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // استدعِ هذه الدالة عند تسجيل الخروج (Logout)
  void resetToHome() {
    currentIndex.value = 0;
  }
}