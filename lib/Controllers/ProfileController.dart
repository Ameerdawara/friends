import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/features/auth/controller/auth_controller.dart';
import '../../../core/network/dio_client.dart'; // تأكد من المسار الصحيح

class ProfileController extends GetxController {
  var loading = false.obs;

  // نصل للـ AuthController لتحديث البيانات العامة للمستخدم عند نجاح التعديل
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // يمكن استدعاء جلب البيانات هنا إذا كنت تريد تحديثها عند فتح الصفحة
    // getProfileData();
  }

  // ✅ جلب بيانات البروفايل (حسب api.php الرابط هو /profile)
  Future<void> getProfileData() async {
    try {
      loading.value = true;
      final response = await DioClient.dio.get("/profile");
      // ملاحظة: الباك اند لديك في دالة me يعيد {name, email, phone}
      // قد تحتاج لتحديث الـ User Model بناءً على هذا الرد
      print("Profile Data: ${response.data}");
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      loading.value = false;
    }
  }

  // ✅ تحديث البروفايل
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? city, // ✅ تمت إضافة المدينة
    String? imagePath, // ✅ مسار الصورة
  }) async {
    loading.value = true;
    try {
      // 1. تجهيز البيانات الأساسية
      Map<String, dynamic> dataMap = {
        "_method": "PUT", // لمحاكاة PUT عند إرسال ملفات
      };

      if (name != null) dataMap["name"] = name;
      if (phone != null) dataMap["phone"] = phone;
      if (city != null) dataMap["city"] = city; // ✅ إرسال المدينة

      // 2. إنشاء FormData
      dio.FormData formData = dio.FormData.fromMap(dataMap);

      // 3. إرفاق الصورة إذا وجدت
      if (imagePath != null && imagePath.isNotEmpty) {
        formData.files.add(MapEntry(
          "image", // يجب أن يطابق الاسم في الباك اند ($request->image)
          await dio.MultipartFile.fromFile(imagePath,
              filename: "profile_pic.jpg"),
        ));
      }

      // 4. إرسال الطلب
      // تأكد أن الرابط يطابق api.php لديك (غالباً /profile أو /profile/update)
      final response = await DioClient.dio.post("/profile", data: formData);

      // 5. تحديث بيانات المستخدم في التطبيق (Refresh)
      await _authController.fetchUserProfile();

      Get.back(); // إغلاق الصفحة
      Get.snackbar("نجاح", "تم تحديث الملف الشخصي",
          backgroundColor: Colors.green.withOpacity(0.2));
    } catch (e) {
      print("Update Error: $e");
      Get.snackbar("خطأ", "فشل التحديث، تأكد من الاتصال");
    } finally {
      loading.value = false;
    }
  }
}
