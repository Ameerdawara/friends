import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/Controllers/NavigationController.dart'; // المسار الجديد
import 'package:testing/view/EventsTab.dart';
import 'package:testing/view/HomeTab.dart';
import 'package:testing/view/widget/BottomNavBar.dart';
import 'package:testing/view/widget/NotificationsTab.dart';
import 'package:testing/view/widget/ProfileTab.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // استدعاء الكنترولر
  final NavigationController navChild = Get.put(NavigationController());

  final List<Widget> pages = const [
    HomeTap(),
    EventsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildHomeAppBar(),
      // استخدام Obx لتحديث الجزء المتغير فقط عند تغيير currentIndex
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
        onPressed: () {},
        icon: const Icon(Icons.menu, color: Colors.black87),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87, size: 28),
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
              text: "Close ",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            TextSpan(
              text: "Friend",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: MyColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}