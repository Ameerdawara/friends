import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // لا نحتاج AppBar هنا لأنه موجود في HomePage، لكن يمكن إضافة مساحة علوية
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // --- 1. رأس الصفحة (الصورة والاسم) ---
            _buildProfileHeader(),

            const SizedBox(height: 30),

            // --- 2. قسم إعدادات الحساب ---
            const Align(
              alignment: Alignment.centerRight,
              child: Text("إعدادات الحساب", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            _buildSettingsCard([
              _buildTile(Icons.person_outline, "تعديل المعلومات الشخصية", () {}),
              _buildTile(Icons.history, "سجل الطلبات", () {}),
            ]),

            const SizedBox(height: 20),

            // --- 3. قسم التطبيق ---
            const Align(
              alignment: Alignment.centerRight,
              child: Text("التطبيق", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 10),
            _buildSettingsCard([
              _buildTile(Icons.dark_mode_outlined, "الوضع الليلي", () {}, isSwitch: true),
              _buildTile(Icons.help_outline, "المساعدة والدعم", () {}),
            ]),

            const SizedBox(height: 30),

            // --- 4. زر تسجيل الخروج ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  // كود تسجيل الخروج
                  Get.defaultDialog(
                    title: "تسجيل الخروج",
                    middleText: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
                    textConfirm: "نعم",
                    textCancel: "إلغاء",
                    confirmTextColor: Colors.white,
                    onConfirm: () {
                      // Get.offAll(() => LoginPage());
                    },
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("تسجيل الخروج", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent.withOpacity(0.8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text("الإصدار 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 80), // مساحة للـ BottomNavBar
          ],
        ),
      ),
    );
  }

  // ودجت بناء رأس الصفحة
  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: MyColors.primary, width: 2),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("images/profile_placeholder.png"), // ضع صورة افتراضية هنا
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white), // أيقونة احتياطية
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: MyColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        const Text(
          "اسم المستخدم",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          "05XXXXXXXX",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // ودجت لبناء الكارد الأبيض الذي يحتوي الخيارات
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  // ودجت لبناء العنصر الواحد داخل القائمة
  Widget _buildTile(IconData icon, String title, VoidCallback onTap, {bool isSwitch = false}) {
    return Column(
      children: [
        ListTile(
          onTap: isSwitch ? null : onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: MyColors.primary),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: isSwitch
              ? Switch(value: false, onChanged: (val) {}, activeColor: MyColors.primary)
              : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ),
        // فاصل خفيف بين العناصر (إلا الأخير يمكن إزالته بذكاء لكن سنبقيه للبساطة)
        Divider(height: 1, indent: 70, endIndent: 20, color: Colors.grey[100]),
      ],
    );
  }
}