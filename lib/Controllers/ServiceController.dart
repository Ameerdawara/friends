import 'package:dio/dio.dart' as dio; // نستخدم alias لتجنب تضارب الأسماء
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/network/dio_client.dart'; // تأكد من مسار DioClient

class ServiceController extends GetxController {
  // للتحكم في حقول النصوص
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController =
      TextEditingController(); // تم إضافته

  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // --- متغيرات الموقع ---
  var currentAddress = ''.obs;
  var currentCity = ''.obs;
  var currentGovernorate = ''.obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  var isAreaBlocked = false.obs;
  var areaAds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  // دالة اختيار الصورة
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) selectedImagePath.value = image.path;
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل الصورة");
    }
  }

  // --- دالة تحديد الموقع (نفس الكود السابق) ---
  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("تنبيه", "GPS غير مفعل");
        isLoading.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: "ar");

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentCity.value =
            place.locality ?? (place.subAdministrativeArea ?? "غير معروف");
        currentGovernorate.value = place.administrativeArea ?? "غير معروف";
        currentAddress.value =
            "${place.street}، ${place.subLocality}، ${currentCity.value}";

        // هنا يمكن استدعاء دالة التحقق من المنطقة checkAreaRules
      }
    } catch (e) {
      currentAddress.value = "فشل تحديد العنوان بدقة";
    } finally {
      isLoading.value = false;
    }
  }

  // =========================================================
  // === الدالة الجديدة لإرسال البيانات للباك اند (Laravel) ===
  // =========================================================
  Future<void> submitOrderToBackend(
      {required String requestType, String? categoryName}) async {
    isLoading.value = true;

    // 1. تجهيز البيانات الأساسية المشتركة (الموقع، الهاتف، الوصف)
    Map<String, dynamic> dataMap = {
      "phone": phoneController.text,
      "description": descriptionController.text, // الوصف
      "latitude": latitude.value,
      "longitude": longitude.value,
      "address": currentAddress.value,
      "city": currentCity.value,
      "governorate": currentGovernorate.value,
    };

    // 2. تجهيز FormData (ضروري لرفع الصور)
    dio.FormData formData = dio.FormData.fromMap(dataMap);

    // 3. التخصيص حسب نوع الطلب
    if (requestType == "طلب خاص") {
      // --- حالة الطلب الخاص ---
      formData.fields
          .add(const MapEntry("type", "special")); // تحديد النوع للباك اند

      // إرفاق الصورة إذا وجدت
      if (selectedImagePath.value.isNotEmpty) {
        formData.files.add(MapEntry(
          "image",
          await dio.MultipartFile.fromFile(selectedImagePath.value,
              filename: "issue_image.jpg"),
        ));
      }
    } else {
      // --- حالة الطلب المباشر ---
      // requestType هنا يحمل اسم الحرفة (مثل: "كهربائي") أو يمكن تمريره في categoryName
      formData.fields.add(const MapEntry("type", "direct")); // تحديد النوع
      formData.fields.add(MapEntry("category",
          categoryName ?? requestType)); // نوع الفني (كهربائي، سباك..)
    }

    try {
      // 4. الإرسال عبر Dio
      // استبدل "/orders" بالمسار الصحيح في Laravel API الخاص بك
      final response = await DioClient.dio.post("/home_service", data: formData);

      Get.back(); // إغلاق الديالوج
      Get.snackbar("نجاح", "تم إرسال الطلب بنجاح، سيتم التواصل معك قريباً",
          backgroundColor: Colors.green, colorText: Colors.white);

      // تصفير الحقول
      descriptionController.clear();
      phoneController.clear();
      selectedImagePath.value = '';
    } catch (e) {
      Get.snackbar("خطأ", "فشل إرسال الطلب، تأكد من الاتصال بالشبكة");
      print("Error Sending Order: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- نافذة تأكيد الطلب ---
  void confirmRequest(BuildContext context, String serviceName) {
    // serviceName: هو اسم الحرفة (في المباشر) أو "طلب خاص"

    // التأكد من تحديد الموقع
    if (currentCity.value.isEmpty) {
      getCurrentLocation();
    }

    Get.defaultDialog(
      title: "تأكيد الطلب ($serviceName)",
      content: SingleChildScrollView(
        child: Column(
          children: [
            // عرض الموقع
            Obx(() => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color:Theme.of(context).canvasColor,borderRadius: BorderRadius.circular(30) ),
                  
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 5),
                      Container(
                        
                          child: Text(
                        currentAddress.value.isEmpty
                            ? "جارِ تحديد الموقع..."
                            : currentAddress.value,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color),
                      )),
                    ],
                  ),
                )),
            const SizedBox(height: 15),

            // حقل رقم الهاتف (مشترك)
            TextField(
              controller: phoneController, // ربطناه بالكنترولر
              decoration: const InputDecoration(
                labelText: "رقم الهاتف للتواصل",
                prefixIcon: Icon(Icons.phone,color: Colors.green,),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),

            // حقل الملاحظات (يظهر فقط في الطلب المباشر، لأن الخاص تمت كتابته في الصفحة السابقة)
            if (serviceName != "طلب خاص") ...[
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "ملاحظات للفني (اختياري)",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ]
          ],
        ),
      ),
      confirm: Obx(() => ElevatedButton(
            onPressed: isLoading.value
                ? null
                : () {
                    // التحقق من المدخلات
                    if (currentCity.value.isEmpty) {
                      Get.snackbar("تنبيه", "انتظر تحديد الموقع");
                      return;
                    }
                    if (phoneController.text.isEmpty) {
                      Get.snackbar("تنبيه", "يرجى إدخال رقم الهاتف");
                      return;
                    }

                    // استدعاء دالة الإرسال
                    if (serviceName == "طلب خاص") {
                      submitOrderToBackend(requestType: "طلب خاص");
                    } else {
                      // إرسال الاسم كنوع الفني
                      submitOrderToBackend(
                          requestType: "مباشر", categoryName: serviceName);
                    }
                  },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B85CE)),
            child: Text(isLoading.value ? "جارِ الإرسال..." : "تأكيد وإرسال",
                style: const TextStyle(color: Colors.white)),
          )),
      cancel:
          TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
    );
  }
}
