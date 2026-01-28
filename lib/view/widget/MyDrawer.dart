import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../features/auth/controller/auth_controller.dart';
import 'ProfileTab.dart'; // لتوجيه الضغط على البروفايل

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          Obx(() {
            final user = authController.currentUser.value;
            return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: MyColors.primary,
              ),
              accountName: Text(user?.name ?? "Guest", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
              accountEmail: Text(user?.email ?? ""),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: (user?.fullImageUrl.isNotEmpty ?? false)
                    ? NetworkImage(user!.fullImageUrl)
                    : const AssetImage("images/CF.webp") as ImageProvider,
              ),
              onDetailsPressed: () {
                // عند الضغط على الهيدر يذهب للبروفايل
                Get.to(() => const ProfileTab());
              },
            );
          }),

          // Body
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text("الرئيسية"),
            onTap: () => Get.back(),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("الملف الشخصي"),
            onTap: () {
              Get.back(); // إغلاق الدروار
              Get.to(() => const ProfileTab());
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text("الإعدادات"),
            onTap: () {},
          ),

          const Spacer(), // لدفع زر الخروج للأسفل

          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("تسجيل الخروج", style: TextStyle(color: Colors.red)),
            onTap: () => authController.logout(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}