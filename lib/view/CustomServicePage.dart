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
             Text(
              "اشرح المشكلة التي تواجهها:",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),

            // --- حقل إدخال الوصف ---
            // ملاحظة: نستخدم controller.descriptionController لكي نرسل هذا النص لاحقاً للباك اند
            TextField(
              controller: controller.descriptionController,

              style: Theme.of(context).textTheme.titleMedium, // لون النص المكتوب
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
                fillColor: Theme.of(context).cardColor, // يأخذ اللون من الثيم
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 25),

             Text(
              "إرفاق صور للمشكلة (اختياري):",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
             Text(
              "يمكنك اختيار صورة واحدة أو أكثر لمساعدة الفني",
              style: Theme.of(context).textTheme.bodyLarge
              ,
            ),
            const SizedBox(height: 15),

            // --- التعديل الجوهري: منطقة اختيار وعرض الصور المتعددة ---
            Obx(() => Column(
              children: [
                // زر إضافة الصور
                GestureDetector(
                  onTap: () => controller.pickImage(),
                  child: Container(
                    height: 80,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: MyColors.primary.withOpacity(0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, color: MyColors.primary),
                        const SizedBox(width: 10),
                        Text("إضافة صور من المعرض", style: TextStyle(color: MyColors.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // عرض الصور المختارة في شبكة (Grid)
                if (controller.selectedImages.isNotEmpty)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 صور في كل سطر
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              image: DecorationImage(
                                image: FileImage(File(controller.selectedImages[index])),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // زر حذف الصورة
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => controller.selectedImages.removeAt(index),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
              ],
            )),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if(controller.descriptionController.text.trim().isEmpty) {
                    Get.snackbar("تنبيه", "يرجى كتابة وصف للمشكلة");
                    return;
                  }
                  controller.confirmRequest(context, "طلب خاص");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("التالي: تأكيد الموقع والهاتف", style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: MyColors.primary)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}