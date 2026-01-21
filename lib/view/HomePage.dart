
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
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // استخدام لون الثيم
      drawer: const MyDrawer(),
      appBar: _buildHomeAppBar(context),
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
  AppBar _buildHomeAppBar(BuildContext context) {
    // تحديد لون النص بناءً على حالة الثيم
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return AppBar(
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu, color: MyColors.primary),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_active, color: MyColors.primary, size: 28),
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "Close ",
              // هنا التغيير المهم: استخدام textColor المتغير بدلاً من Colors.black
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const TextSpan(
              text: "Friend",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: MyColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}