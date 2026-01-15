import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart'; // تأكد من وجود ملف الألوان
import 'CustomServicePage.dart';
import 'CategorySelectionPage.dart';

class ServicesSelectionPage extends StatelessWidget {
  const ServicesSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("نوع الطلب", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "كيف تود طلب الخدمة؟",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // الخيار الأول: طلب خدمة مباشرة
            _buildSelectionCard(
              context,
              title: "طلب خدمة مباشرة",
              subtitle: "اختر الحرفي (حداد، نجار، كهربائي...) مباشرة",
              icon: Icons.handyman_outlined,
              color: MyColors.primary,
              onTap: () => Get.to(() => const CategorySelectionPage()),
            ),

            const SizedBox(height: 20),

            // الخيار الثاني: إرسال صورة ووصف
            _buildSelectionCard(
              context,
              title: "طلب خاص (صورة + وصف)",
              subtitle: "صف المشكلة بصورة وكتابة ليتم توجيهك",
              icon: Icons.camera_alt_outlined,
              color: Colors.orange,
              onTap: () => Get.to(() => CustomServicePage()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard(BuildContext context,
      {required String title,
        required String subtitle,
        required IconData icon,
        required Color color,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}