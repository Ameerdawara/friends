import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/features/auth/controller/auth_controller.dart';
import '../../../core/network/dio_client.dart';
import '../data/model/User_Model.dart'; // تأكد من المسار الصحيح

class ProfileController extends GetxController {
  var loading = false.obs;

  // نصل للـ AuthController لتحديث البيانات العامة للمستخدم عند نجاح التعديل
  final AuthController _authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    // يمكن استدعاء جلب البيانات هنا إذا كنت تريد تحديثها عند فتح الصفحة
     getProfileData();
  }

  // ✅ التعديل هنا: جعل الدالة تعيد UserModel بدلاً من void
  Future<UserModel?> getProfileData() async {
    try {
      loading.value = true;
      final response = await DioClient.dio.get("/profile");

      if (response.statusCode == 200) {
        // تحويل البيانات القادمة من السيرفر إلى مودل
        // افترضنا أن البيانات تأتي مباشرة أو داخل مفتاح 'data' حسب هيكلية الـ API لديك
        // يرجى التأكد من هيكلية الـ JSON (هل هي response.data أم response.data['data'])
        UserModel user = UserModel.fromJson(response.data);
        return user;
      }
    } catch (e) {
      print("Error fetching profile: $e");
    } finally {
      loading.value = false;
    }
    return null; // في حال الفشل
  }

  // ✅ تحديث البروفايل
  Future<void> updateProfile({
    String? name,
    String? phone,
    String? governorate,
    String? city, // ✅ تمت إضافة المدينة
    String? imagePath,

    // ✅ مسار الصورة
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
      if(governorate != null)dataMap["governorate"]=governorate;
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

      final response = await DioClient.dio.post("/profile", data: formData);

      if (response.statusCode == 200) {

        // ✅ الخطوة المهمة: إجبار التطبيق على جلب البيانات الجديدة من السيرفر
        // نستخدم await لننتظر حتى تصل البيانات قبل إغلاق الصفحة
        await _authController.fetchUserProfile();

        // نغلق صفحة التحميل ونظهر رسالة نجاح
        loading.value = false;
        Get.back(); // إغلاق صفحة التعديل والعودة للبروفايل

        Get.snackbar("نجاح", "تم تحديث الملف الشخصي",
            backgroundColor: Colors.green.withOpacity(0.2));

      } else {
        // في حال فشل الطلب
        loading.value = false;
        Get.snackbar("تنبيه", "لم يتم حفظ التغييرات");
      }
    } catch (e) {
      loading.value = false; // تأكد من إيقاف التحميل
      print("Error updating profile: $e");

      if (e is dio.DioException) {
        // طباعة رد السيرفر بالكامل في الكونسول
        print("Server Response: ${e.response?.data}");

        // عرض رسالة الخطأ القادمة من السيرفر للمستخدم
        String errorMessage = "حدث خطأ غير متوقع";
        if (e.response?.data != null && e.response!.data['message'] != null) {
          errorMessage = e.response!.data['message'];
        }
        Get.snackbar("تنبيه", errorMessage, backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else {
        Get.snackbar("خطأ", "فشل الاتصال بالسيرفر");
      }
    }
  }
}
