import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../Edit_Profile.dart';
import '../OrderHistoryPage.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // استدعاء الكنترولر الموجود بالفعل
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // --- 1. رأس الصفحة (مربوط بـ Obx) ---
            Obx(() {
              final user = authController.currentUser.value;
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
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (user?.fullImageUrl.isNotEmpty ?? false)
                          ? NetworkImage(user!.fullImageUrl)
                          : const AssetImage("images/profile_placeholder.png") as ImageProvider,
                      // تأكد من وضع صورة افتراضية في مجلد images
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    user?.name ?? "اسم المستخدم",
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? "email@example.com",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              );
            }),

            const SizedBox(height: 30),

            // --- 2. الإعدادات ---
            const Align(
              alignment: Alignment.centerRight,
              child: Text("إعدادات الحساب",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey)),
            ),
            const SizedBox(height: 10),

            _buildSettingsCard([
              _buildTile(
                Icons.person_outline,
                "تعديل المعلومات الشخصية",
                    () => Get.to(() => EditProfilePage()), // الذهاب لصفحة التعديل
              ),
              _buildTile(
                Icons.history,
                "سجل الطلبات",
                    () => Get.to(() => const OrderHistoryPage()),
              ),
              _buildTile(
                Icons.lock_outline,
                "تغيير كلمة المرور",
                    () {}, // يمكن إضافتها لاحقاً
              ),
            ]),

            const SizedBox(height: 20),

            // --- 3. زر تسجيل الخروج ---
            _buildSettingsCard([
              Obx(() => ListTile(
                onTap: authController.loading.value ? null : () => authController.logout(),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.logout, color: Colors.red),
                ),
                title: const Text(
                  "تسجيل الخروج",
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                ),
                trailing: authController.loading.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.redAccent),
              )),
            ]),
          ],
        ),
      ),
    );
  }

  // ودجت الحاوية البيضاء
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

  // ودجت العنصر
  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: MyColors.primary),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ),
        Divider(height: 1, indent: 60, endIndent: 20, color: Colors.grey[100]),
      ],
    );
  }
}
