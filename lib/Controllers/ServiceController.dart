import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // 1. استيراد المكتبة

class ServiceController extends GetxController {
  // أضف هذا المتغير بجانب المتغيرات الأخرى في الأعلى
  final TextEditingController descriptionController = TextEditingController();
  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  var selectedCategory = ''.obs;
  var userRating = 0.obs;

  // متغير لتخزين الموقع الحالي (نصي)
  var currentAddress = ''.obs;

  void updateRating(int rating) {
    userRating.value = rating;
  }

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

  // --- دالة جديدة للتحقق من الأذونات وجلب الموقع ---
  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. التأكد من أن خدمة الموقع مفعلة في الهاتف
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("تنبيه", "خدمة الموقع غير مفعلة، الرجاء تفعيل GPS");
      return;
    }

    // 2. التحقق من الأذونات
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("رفض", "تم رفض إذن الوصول للموقع");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("تنبيه", "لا يمكننا طلب الإذن، الرجاء تفعيله من الإعدادات");
      return;
    }

    // 3. جلب الموقع الحالي
    isLoading.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // تخزين الإحداثيات (يمكنك لاحقاً تحويلها لعنوان)
      currentAddress.value = "Lat: ${position.latitude}, Long: ${position.longitude}";

      Get.snackbar("نجاح", "تم تحديد موقعك: ${currentAddress.value}",
          backgroundColor: Colors.green.withOpacity(0.2));

    } catch (e) {
      Get.snackbar("خطأ", "حدثت مشكلة أثناء جلب الموقع");
    } finally {
      isLoading.value = false;
    }
  }
  void confirmRequest(BuildContext context, String serviceType) {
    // تصغير النص عند فتح الدايلوج لضمان نظافة الحقول
    descriptionController.clear();

    Get.defaultDialog(
      title: "تأكيد الطلب ($serviceType)",
      content: SingleChildScrollView( // استخدام السكرول لضمان ظهور الحقول في الشاشات الصغيرة
        child: Column(
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

            // --- حقل الوصف الجديد ---
            TextField(
              controller: descriptionController,
              maxLines: 3, // للسماح بكتابة وصف طويل
              decoration: const InputDecoration(
                labelText: "وصف المشكلة (اختياري)",
                hintText: "مثلاً: الصنبور يسرب ماء بشكل كبير...",
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // زر تحديد الموقع
            Obx(() => ElevatedButton.icon(
              onPressed: isLoading.value ? null : () async => await getCurrentLocation(),
              icon: isLoading.value
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.location_on),
              label: Text(currentAddress.value.isEmpty ? "تأكيد موقعي الحالي" : "تم تحديد الموقع"),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentAddress.value.isEmpty ? Colors.grey : Colors.green,
                foregroundColor: Colors.white,
              ),
            )),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // جلب النص من الحقل
          String description = descriptionController.text;

          Get.back(); // إغلاق الدايلوج

          // إرسال البيانات (الوصف + الموقع)
          Get.snackbar(
            "تم إرسال الطلب",
            "الخدمة: $serviceType\nالوصف: $description\nالموقع: ${currentAddress.value}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.blue.withOpacity(0.1),
            duration: const Duration(seconds: 5),
          );
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