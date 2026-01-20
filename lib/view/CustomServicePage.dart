import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/ServiceController.dart'; // تأكد من مسار الكنترولر الصحيح
import 'package:testing/constans/MyColor.dart'; // تأكد من مسار ملف الألوان

class CustomServicePage extends StatelessWidget {
  CustomServicePage({super.key});

  // استدعاء الكنترولر الذي يحتوي على منطق الإرسال والبيانات
  final ServiceController controller = Get.put(ServiceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title:  Text(
          "وصف المشكلة",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,        elevation: 0,
        iconTheme: const IconThemeData(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- عنوان حقل الوصف ---
            const Text(
              "اشرح المشكلة التي تواجهها:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // --- حقل إدخال الوصف ---
            // ملاحظة: نستخدم controller.descriptionController لكي نرسل هذا النص لاحقاً للباك اند
            TextField(
              controller: controller.descriptionController,
              style: Theme.of(context).textTheme.bodyLarge, // لون النص المكتوب
              decoration: InputDecoration(
                hintText: "مثال: لدي تسريب مياه في المطبخ تحت الحوض، واحتاج فني بأسرع وقت...",
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                border: Theme.of(context).inputDecorationTheme.border,

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: MyColors.primary, width: 1.5),
                ),
                filled: true,
                fillColor: Colors.grey[50], // يأخذ اللون من الثيم
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 25),

            // --- عنوان الصورة ---
            const Text(
              "إرفاق صورة للمشكلة (اختياري):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              "تساعد الصورة الفني على فهم المشكلة وإحضار الأدوات المناسبة",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 15),

            // --- منطقة اختيار الصورة ---
            Center(
              child: Obx(() => GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: controller.selectedImagePath.value.isEmpty
                          ? Theme.of(context).dividerColor
                          : MyColors.primary,

                      width: 1.5,
                      style: controller.selectedImagePath.value.isEmpty
                          ? BorderStyle.solid // كان dashed سابقاً، solid أجمل
                          : BorderStyle.solid,
                    ),
                  ),
                  child: controller.selectedImagePath.value == ''
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, size: 50, color: MyColors.primary.withOpacity(0.5)),
                      const SizedBox(height: 10),
                      Text(
                        "اضغط هنا لفتح المعرض",
                        style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                      : Stack(
                    children: [
                      // عرض الصورة
                      ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.file(
                          File(controller.selectedImagePath.value),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // زر لتغيير الصورة (أيقونة صغيرة)
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, color: Colors.white, size: 20),
                        ),
                      )
                    ],
                  ),
                ),
              )),
            ),

            const SizedBox(height: 40),

            // --- زر المتابعة ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  // التحقق من أن المستخدم كتب وصفاً للمشكلة
                  if(controller.descriptionController.text.trim().isEmpty) {
                    Get.snackbar(
                      "تنبيه",
                      "يرجى كتابة وصف للمشكلة قبل المتابعة",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red.shade100,
                      colorText: Colors.red.shade900,
                      margin: const EdgeInsets.all(10),
                      borderRadius: 10,
                    );
                    return;
                  }

                  // فتح نافذة التأكيد (الموجودة في الكنترولر)
                  // نمرر "طلب خاص" كنوع للخدمة
                  controller.confirmRequest(context, "طلب خاص");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "التالي: تأكيد الموقع ورقم الهاتف",
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20)
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}