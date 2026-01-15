import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart'; // تأكد من المسار

class OrderController extends GetxController {
  // متغير لمعرفة حالة التحميل
  var isLoading = true.obs;

  // قائمة الطلبات (Observable)
  var orders = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // استدعاء البيانات عند فتح الصفحة
  }

  // محاكاة جلب البيانات من السيرفر
  void fetchOrders() async {
    try {
      isLoading.value = true;

      // تأخير وهمي لمدة ثانيتين لمحاكاة الاتصال بالإنترنت
      await Future.delayed(const Duration(seconds: 2));

      // تعبئة البيانات
      orders.value = [
        {
          "id": "#1023",
          "type": "مباشر",
          "serviceName": "كهربائي",
          "status": "قيد التنفيذ",
          "statusColor": Colors.orange,
          "date": "2023-10-25 | 10:30 AM",
          "location": "حي اليرموك، شارع 15",
          "description": "تصليح أسلاك التوصيل الرئيسية",
          "icon": Icons.electric_bolt,
        },
        {
          "id": "#1022",
          "type": "خاص",
          "serviceName": "طلب خاص (صورة)",
          "status": "مكتمل",
          "statusColor": Colors.green,
          "date": "2023-10-20 | 04:15 PM",
          "location": "حي النخيل، قرب المول",
          "description": "الحنفية تسرب الماء بشدة، تم إرفاق صورة.",
          "icon": Icons.camera_alt,
        },
        {
          "id": "#1021",
          "type": "مباشر",
          "serviceName": "نجار",
          "status": "ملغي",
          "statusColor": Colors.red,
          "date": "2023-10-18 | 09:00 AM",
          "location": "حي الملقا",
          "description": "تركيب أبواب خشبية",
          "icon": Icons.weekend,
        },
      ];
    } finally {
      isLoading.value = false;
    }
  }

  // دالة لتحديث القائمة (للسحب من الأعلى Refresh)
  Future<void> refreshOrders() async {
    fetchOrders();
  }
}