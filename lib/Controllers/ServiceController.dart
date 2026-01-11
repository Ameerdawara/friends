import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

class ServiceController extends GetxController {
  // للتحكم في نوع الطلب
  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // لاختيار الفئة (نجارة، حدادة...)
  var selectedCategory = ''.obs;
  var userRating = 0.obs; // متغير مراقب لقيمة التقييم (0 إلى 5)

  void updateRating(int rating) {
    userRating.value = rating;
  }
  // اختيار صورة للطلب الخاص
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل الصورة");
    }
  }

  // دالة محاكاة لتأكيد الطلب (رقم الهاتف + الموقع)
  void confirmRequest(BuildContext context, String serviceType) {
    // هنا يجب فتح Dialog أو BottomSheet لإدخال رقم الهاتف وتأكيد الموقع
    Get.defaultDialog(
      title: "تأكيد الطلب ($serviceType)",
      content: Column(
        children: [
          const Text("سيتم اعتماد رقم هاتفك الحالي للطلب"),
          const SizedBox(height: 10),
          const TextField(
            decoration: InputDecoration(
              labelText: "رقم الهاتف",
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              // منطق جلب الموقع GPS
              Get.snackbar("الموقع", "تم تحديد موقعك الحالي بنجاح");
            },
            icon: const Icon(Icons.location_on),
            label: const Text("تأكيد موقعي الحالي"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back();
          Get.snackbar("تم", "تم إرسال الطلب بنجاح، سيتصل بك الحرفي قريباً");
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B85CE)),
        child: const Text("إرسال الطلب", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("إلغاء"),
      ),
    );
  }
}