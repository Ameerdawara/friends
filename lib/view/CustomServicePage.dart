import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/ServiceController.dart';
import 'package:testing/constans/MyColor.dart';

class CustomServicePage extends StatelessWidget {
  CustomServicePage({super.key});

  // نستخدم Get.find لأن الكنترولر تم حقنه مسبقاً أو سيتم حقنه هنا
  final ServiceController controller = Get.put(ServiceController());
  final TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("وصف المشكلة")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("اشرح المشكلة:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "مثال: الحنفية تسرب الماء بشدة...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
            const SizedBox(height: 20),

            const Text("إرفاق صورة (اختياري):", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            // منطقة عرض الصورة أو زر الإضافة
            Center(
              child: Obx(() => GestureDetector(
                onTap: () => controller.pickImage(),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: controller.selectedImagePath.value == ''
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 50, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text("اضغط لإضافة صورة", style: TextStyle(color: Colors.grey[600])),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(controller.selectedImagePath.value),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )),
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if(descController.text.isEmpty) {
                    Get.snackbar("تنبيه", "يرجى كتابة وصف للمشكلة");
                    return;
                  }
                  controller.confirmRequest(context, "طلب خاص");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("إرسال الطلب وتأكيد الموقع", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}