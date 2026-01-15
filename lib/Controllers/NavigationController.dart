import 'package:get/get.dart';

class NavigationController extends GetxController {
  var currentIndex = 0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }
  // تحديث التقييم
  var userRating = 0.obs;
  void updateRating(int rating) => userRating.value = rating;

  // استدعِ هذه الدالة عند تسجيل الخروج (Logout)
  void resetToHome() {
    currentIndex.value = 0;
  }
}