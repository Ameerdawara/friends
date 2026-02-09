import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

import '../../Controllers/ThemeController.dart';
import '../../features/auth/controller/auth_controller.dart';
import '../Edit_Profile.dart';
import '../HowItWorksPage.dart';
import '../OrderHistoryPage.dart';
import '../TeamWork.dart';
import 'ProfileTab.dart'; // لتوجيه الضغط على البروفايل

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.put(ThemeController());

    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Header
          Obx(() {
            final user = authController.currentUser.value;
            return UserAccountsDrawerHeader(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight:Radius.circular(20)),
                // استخدام تدرج لوني احترافي بدلاً من الصورة
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    MyColors.primary.withOpacity(0.2),          // اللون الأساسي لتطبيقك
                    MyColors.primary.withOpacity(0.4),
                    MyColors.primary.withOpacity(0.6),
                    MyColors.primary.withOpacity(0.8),
                    MyColors.primary,
                    MyColors.third.withOpacity(0.8)
                   




                       // درجة أزرق داكنة جداً للفخامة
                  ],
                ),
              ),
              accountName: Text(user?.name ?? "Guest", style:const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,)),
              accountEmail: Text(user?.email ?? "",style: const TextStyle(color: Colors.white),),
              currentAccountPicture: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45,width: 3)
                      ,borderRadius: BorderRadius.circular(50)
                ),
                child: CircleAvatar(
                radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: (user?.fullImageUrl.isNotEmpty ?? false)
                      ? NetworkImage(user!.fullImageUrl)
                      : const AssetImage("images/CF.webp") as ImageProvider,
                ),
              ),
              onDetailsPressed: () {
                // عند الضغط على الهيدر يذهب للبروفايل
                Get.to(() => EditProfilePage());
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
            leading: const Icon(Icons.history),
            title: const Text("سجل الطلبات "),
            onTap: () {
              Get.to(() => OrderHistoryPage());
            },
          ),
          ListTile(
            leading: const Icon(Icons.group),
            title: const Text(" فريق العمل "),
            onTap: () {
              Get.to(() => TeamWork());
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("عن التطبيق وكيف يعمل؟ "),
            onTap: () {
              Get.to(() => HowItWorksPage());
            },
          ),


          // زر الوضع الليلي (Switch)
          Obx(() => SwitchListTile(
            secondary: Container(

              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                themeController.isDarkMode.value ? Icons.dark_mode : Icons.light_mode,

              ),
            ),
            title: Text(
              "الوضع الليلي",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            value: themeController.isDarkMode.value,
            activeColor: MyColors.primary,
            onChanged: (val) {
              themeController.toggleTheme();
            },
          )),

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