import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/Controllers/NavigationController.dart';
import 'package:testing/view/EventsTab.dart';
import 'package:testing/view/HomeTab.dart';
import 'package:testing/view/widget/BottomNavBar.dart';
import 'package:testing/view/widget/NotificationsTab.dart';
// تأكد من تحديث المسارات
import 'package:testing/view/widget/ProfileTab.dart';
import 'package:testing/view/widget/MyDrawer.dart'; // استيراد ملف الدروار الجديد

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NavigationController navChild = Get.put(NavigationController());

  // 1. مفتاح للتحكم في الـ Scaffold
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = const [
    HomeTap(),
    EventsTab(),
    NotificationsTab(),
    ProfileTab(), // صفحة البروفايل الجديدة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // 2. ربط المفتاح هنا
      backgroundColor: Colors.grey[50],

      // 3. إضافة الـ Drawer هنا
      drawer: const MyDrawer(),

      // لتغيير اتجاه السحب ليناسب العربية (يمين ليسار) استخدم endDrawer بدلاً من drawer
      // وغير leading في الـ AppBar للجهة الأخرى إذا لزم الأمر، لكن drawer الافتراضي جيد

      appBar: _buildHomeAppBar(),

      body: Obx(() => IndexedStack(
        index: navChild.currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
        currentIndex: navChild.currentIndex.value,
        onTap: navChild.changeIndex,
      )),
    );
  }

  AppBar _buildHomeAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          // 4. فتح الـ Drawer عند الضغط
          _scaffoldKey.currentState?.openDrawer();
        },
        icon: const Icon(Icons.menu, color: Colors.black87),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active, color: MyColors.primary, size: 28),
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0,
      backgroundColor: Colors.grey[50],
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Close ", // الاختصار المطلوب
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: "Friend",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}