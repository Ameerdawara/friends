import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/Controllers/NavigationController.dart';
// استدعاء كونترولر الإشعارات
import 'package:testing/Controllers/NotificationsController.dart';
import 'package:testing/view/EventsTab.dart';
import 'package:testing/view/HomeTab.dart';
import 'package:testing/view/widget/BottomNavBar.dart';
import 'package:testing/view/widget/NotificationsTab.dart';
import 'package:testing/view/widget/ProfileTab.dart';
import 'package:testing/view/widget/MyDrawer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final NavigationController navChild = Get.put(NavigationController());
  // 1. حقن كونترولر الإشعارات
  final NotificationsController notifyController = Get.put(NotificationsController());

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> pages = const [
    HomeTap(),
    EventsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return AppBar(
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        icon: const Icon(Icons.menu, color: MyColors.primary),
      ),
      actions: [
        // 2. استخدام Stack لوضع العداد فوق الأيقونة
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () {
                // عند الضغط يذهب لصفحة الإشعارات (index 2)
                navChild.changeIndex(2);
              },
              icon: const Icon(Icons.notifications_active, color: MyColors.primary, size: 28),
            ),
            // مراقبة التغيرات
            Obx(() {
              return notifyController.unreadCount > 0
                  ? Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${notifyController.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
                  : const SizedBox(); // إخفاء العداد إذا كان 0
            }),
          ],
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