import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/ServiceController.dart'; 
import 'package:testing/constans/MyColor.dart'; 

class CustomServicePage extends StatelessWidget {
  CustomServicePage({super.key});

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
            const Text(
              "اشرح المشكلة التي تواجهها:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

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

            const Text(
              "إرفاق صور للمشكلة (اختياري):",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              "يمكنك اختيار صورة واحدة أو أكثر لمساعدة الفني",
              style: TextStyle(fontSize: 12, color: Colors.grey),
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
                      color: Colors.blue.withOpacity(0.05),
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("التالي: تأكيد الموقع والهاتف", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_forward, color: Colors.white)
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