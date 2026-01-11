import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignUpController extends GetxController {
  // المسار المراقب
  var selectedImagePath = ''.obs;

  // حالة التحميل (مهمة جداً لتعطيل الأزرار أثناء اختيار الصورة)
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      isLoading.value = true; // بدء التحميل

      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // ضغط الصورة قليلاً لتحسين الأداء
      );

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
      }
    } catch (e) {
      // التعامل مع الأخطاء بذكاء
      Get.snackbar(
        "تنبيه",
        "حدث خطأ أثناء تحميل الصورة، يرجى المحاولة مرة أخرى.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false; // إنهاء التحميل سواء نجح أو فشل
    }
  }

  // دالة مساعدة لحذف الصورة المختارة
  void clearImage() {
    selectedImagePath.value = '';
  }
}