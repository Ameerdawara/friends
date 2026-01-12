import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // --- رأس القائمة (Header) ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              color: MyColors.primary,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "مرحباً، المستخدم",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // --- عناصر القائمة ---
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildDrawerItem(Icons.home_outlined, "الرئيسية", () => Get.back()),
                _buildDrawerItem(Icons.person_outline, "الملف الشخصي", () {
                  Get.back();
                  // controller.changeIndex(3); // إذا أردت الانتقال للتبويب الرابع
                }),
                _buildDrawerItem(Icons.shopping_bag_outlined, "طلباتي", () {}),
                const Divider(indent: 20, endIndent: 20),
                _buildDrawerItem(Icons.settings_outlined, "الإعدادات", () {}),
                _buildDrawerItem(Icons.info_outline, "عن التطبيق", () {}),
              ],
            ),
          ),

          // --- تذييل القائمة ---
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red[300]),
                const SizedBox(width: 10),
                Text("تسجيل الخروج", style: TextStyle(color: Colors.red[300], fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[700]),
      title: Text(title, style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
      onTap: onTap,
      hoverColor: MyColors.primary.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
    );
  }
}