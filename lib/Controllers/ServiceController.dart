import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ServiceController extends GetxController {
  final TextEditingController descriptionController = TextEditingController();

  var isLoading = false.obs;
  var selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  // --- متغيرات الموقع والهرمية الإدارية ---
  var currentAddress = ''.obs;
  var currentCity = ''.obs;         // مهم جداً: لتوجيه الطلب لأدمن المدينة
  var currentGovernorate = ''.obs;  // مهم جداً: لتوجيه الطلب لأدمن المحافظة
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  // --- متغيرات الحظر والإعلانات ---
  var isAreaBlocked = false.obs;    // هل هذه المنطقة محظورة من الخدمة؟
  var areaAds = <String>[].obs;     // قائمة إعلانات خاصة بهذه المنطقة فقط

  @override
  void onInit() {
    super.onInit();
    // عند تشغيل التطبيق، نحاول جلب الموقع فوراً لمعرفة الإعدادات
    getCurrentLocation();
  }

  // تحديث التقييم
  var userRating = 0.obs;
  void updateRating(int rating) => userRating.value = rating;

  // اختيار صورة
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) selectedImagePath.value = image.path;
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحميل الصورة");
    }
  }

  // --- دالة تحديد الموقع والتحقق من المنطقة ---
  Future<void> getCurrentLocation() async {
    isLoading.value = true;
    try {
      // 1. التحقق من الأذونات (كما في الكود السابق)
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

      // 2. جلب الإحداثيات
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // 3. تحويل الإحداثيات لعنوان (Reverse Geocoding)
      // Note: remove unsupported named parameter; use default locale or update package if needed
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // استخراج البيانات بدقة للهرمية
        currentCity.value = place.locality ?? "";
        // في بعض المناطق locality تكون فارغة، نستخدم subAdministrativeArea كبديل
        if (currentCity.value.isEmpty) currentCity.value = place.subAdministrativeArea ?? "غير معروف";

        currentGovernorate.value = place.administrativeArea ?? "غير معروف";

        currentAddress.value = "${place.street}، ${place.subLocality}، ${currentCity.value}";

        // 4. التحقق من السيرفر: هل هذه المدينة محظورة؟ وما هي إعلاناتها؟
        checkAreaRules(currentCity.value, currentGovernorate.value);
      }
    } catch (e) {
      currentAddress.value = "فشل تحديد العنوان بدقة";
      debugPrint("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // --- محاكاة الاتصال بالباك إند للتحقق من المنطقة ---
  void checkAreaRules(String city, String governorate) {
    // هنا يجب أن يكون كود الاتصال بالـ API الحقيقي
    // مثال المحاكاة:
    print("Checking rules for: $city, Admin: $governorate");

    if (city.contains("منطقة محظورة")) {
      isAreaBlocked.value = true;
      Get.defaultDialog(
        title: "عذراً",
        middleText: "خدمات تطبيق Close Friend غير متوفرة حالياً في $city.",
        barrierDismissible: false,
      );
    } else {
      isAreaBlocked.value = false;
      // جلب إعلانات المدينة (تأتي من أدمن المدينة أو المالك)
      areaAds.assignAll([
        "خصم خاص لسكان $city",
        "صيانة مكيفات فورية في $governorate"
      ]);
    }
  }

  // --- تأكيد الطلب وإرساله ---
  void confirmRequest(BuildContext context, String serviceType) {
    descriptionController.clear();

    // إذا لم يتم تحديد الموقع بعد
    if(currentCity.value.isEmpty) {
      getCurrentLocation();
    }

    Get.defaultDialog(
      title: "تأكيد الطلب ($serviceType)",
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text("سيتم توجيه الطلب لمشرفي منطقتك"),
            const SizedBox(height: 10),
            // عرض حالة الموقع
            Obx(() => Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey[100],
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.blue),
                      const SizedBox(width: 5),
                      Expanded(child: Text(currentAddress.value.isEmpty ? "جارِ تحديد الموقع..." : currentAddress.value)),
                    ],
                  ),
                  if(currentCity.value.isNotEmpty)
                    Text("مشرف المدينة: ${currentCity.value}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            )),
            const SizedBox(height: 10),
            const TextField(
              decoration: InputDecoration(
                labelText: "رقم الهاتف للتواصل",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: "ملاحظات إضافية",
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: () {
          // منع الإرسال إذا الموقع غير محدد
          if (currentCity.value.isEmpty || currentCity.value == "غير معروف") {
            Get.snackbar("تنبيه", "يجب تحديد الموقع بدقة لإرسال الفني المناسب");
            return;
          }

          Get.back();

          // --- إرسال البيانات للباك إند ---
          // هنا يتم إرسال (المدينة) و (المحافظة) لكي يعرف السيرفر أي أدمن يستلم الطلب
          print("Sending Order -> Service: $serviceType");
          print("Target Admin City: ${currentCity.value}");
          print("Target Admin Governorate: ${currentGovernorate.value}");

          Get.snackbar("نجاح", "تم إرسال الطلب إلى فنيي ${currentCity.value}");
        },
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3B85CE)),
        child: const Text("تأكيد وإرسال", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(onPressed: () => Get.back(), child: const Text("إلغاء")),
    );
  }
}