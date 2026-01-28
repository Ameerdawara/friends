import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../Controllers/ThemeController.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../Edit_Profile.dart';
import '../OrderHistoryPage.dart';
import '../loginPage.dart'; // لتوجيه المستخدم عند تسجيل الخروج

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولرز
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.put(ThemeController());

    return Scaffold(
      // لا نضع لون خلفية ثابت هنا، بل نتركه يأخذ من الثيم (أبيض أو أسود)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 1. رأس الصفحة (الصورة والاسم) ---
            Obx(() {

              final user = authController.currentUser.value;
              print("Debug: Final Image URL is -> ${user?.fullImageUrl}");
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MyColors.primary, width: 2),
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (user?.image != null && user!.image!.isNotEmpty)
                          ? NetworkImage(user.fullImageUrl) // تأكد من استخدام fullImageUrl
                          : const AssetImage("images/CF.webp") as ImageProvider,

                    )
                  ),

                  const SizedBox(height: 15),

                  // الاسم
                  Text(
                    user?.name ?? "مستخدم زائر",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 5),

                  // رقم الهاتف
                  Text(
                    user?.email ??(user?.phone ?? ""),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              );

            }),

            const SizedBox(height: 30),

            // --- 2. قائمة الإعدادات ---
            Container(
              decoration: BoxDecoration(
                // لون الخلفية يتغير حسب الثيم (أبيض في النهار، رصاصي غامق في الليل)
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // زر تعديل الملف الشخصي
                  _buildTile(
                    icon: Icons.person_outline,
                    title: "تعديل الملف الشخصي",
                    onTap: () {
                      Get.to(() => EditProfilePage());
                    },
                    context: context,
                  ),

                  const Divider(height: 1, indent: 20, endIndent: 20),

                  // زر الوضع الليلي (Switch)
                  Obx(() => SwitchListTile(
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MyColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,
                        color: MyColors.primary,
                      ),
                    ),
                    title: Text(
                      "الوضع الليلي",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    value: themeController.isDarkMode.value,
                    activeColor: MyColors.primary,
                    onChanged: (val) {
                      themeController.toggleTheme();
                    },
                  )),

                  const Divider(height: 1, indent: 20, endIndent: 20),

                  // زر سجل الطلبات
                  _buildTile(
                    icon: Icons.history,
                    title: "سجل الطلبات",
                    onTap: () {
                      Get.to(() => const OrderHistoryPage());
                    },
                    context: context,
                  ),

                  const Divider(height: 1, indent: 20, endIndent: 20),

                  // زر الإعدادات العامة (مثال)

                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- 3. زر تسجيل الخروج ---
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ListTile(
                onTap: () {
                  authController.logout();
                  Get.offAll(() => const LoginPage());
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5E5), // لون خلفية أحمر فاتح للأيقونة
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.redAccent),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ودجت بناء العنصر (Tile)
  Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: MyColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: MyColors.primary),
      ),
      // نستخدم ستايل الثيم ليأخذ اللون المناسب (أسود أو أبيض)
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
    );
  }
}
