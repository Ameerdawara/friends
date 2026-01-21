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
  var selectedImages = <String>[].obs;
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
  // داخل ملف ServiceController.dart

Future<void> pickImage() async {
  try {
    // اختيار صور جديدة من المعرض
    final List<XFile> images = await _picker.pickMultiImage();
    
    if (images.isNotEmpty) {
      // التعديل هنا: نستخدم addAll بدلاً من '=' لدمج الصور الجديدة مع القديمة
      var newPaths = images.map((image) => image.path).toList();
      selectedImages.addAll(newPaths); 
      
      
    }
  } catch (e) {
    Get.snackbar("خطأ", "فشل تحميل الصور");
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

      // 3. تحويل الإحداثيات لعنوان (Reverse Geocoding)
      // Note: remove unsupported named parameter; use default locale or update package if needed
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

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
   

Future<void> submitOrderToBackend({required String requestType, String? categoryName}) async {
  isLoading.value = true;

  Map<String, dynamic> dataMap = {
    "description": descriptionController.text.isEmpty ? "طلب خدمة $requestType" : descriptionController.text,
    "phone": phoneController.text,
    "address": currentAddress.value,
    "latitude": latitude.value,
    "longitude": longitude.value,
  };

  dio.FormData formData = dio.FormData.fromMap(dataMap);

  if (requestType == "طلب خاص") {
    formData.fields.add(const MapEntry("service_type", "image_request"));
    
    // --- التعديل هنا لإرسال قائمة الصور ---
    if (selectedImages.isNotEmpty) {
      for (String path in selectedImages) {
        formData.files.add(MapEntry(
          "images[]", // يجب أن ينتهي بـ [] ليتعرف عليه Laravel كمصفوفة
          await dio.MultipartFile.fromFile(path, filename: path.split('/').last),
        ));
      }
    }
  } else {
    formData.fields.add(const MapEntry("service_type", "direct_request"));
    formData.fields.add(MapEntry("profession", categoryName ?? "عام"));
  }

  try {
    final response = await DioClient.dio.post("/home-services", data: formData);
    
    Get.back();
    Get.snackbar("نجاح", "تم إرسال الطلب بنجاح", backgroundColor: Colors.green, colorText: Colors.white);

    // تنظيف البيانات
    descriptionController.clear();
    phoneController.clear();
    selectedImages.clear(); // تفريغ القائمة

  } catch (e) {
    Get.snackbar("خطأ", "فشل إرسال الطلب");
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
