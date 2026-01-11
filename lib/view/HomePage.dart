import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/EventsTap.dart';
import 'package:testing/view/HomeTap.dart';
import 'package:testing/view/widget/BottomNavBar.dart';
import 'package:testing/view/widget/NotificationsTap.dart';
import 'package:testing/view/widget/ProfileTap.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  AppBar buildHomeAppBar() {
    return AppBar(
      // تم تغيير الأيقونة إلى قائمة جانبية أو إعدادات
      leading: IconButton(
        onPressed: () {},
        icon: Icon(Icons.menu, color: Colors.black87),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications_none_rounded, color: Colors.black87, size: 28),
        ),
        const SizedBox(width: 10),
      ],
      elevation: 0, // إزالة الظل ليصبح مسطحاً
      backgroundColor: Colors.grey[50], // نفس لون خلفية الـ Body
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          children: [
            const TextSpan(
              text: "Close ",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 0.5,
              ),
            ),
            TextSpan(
              text: "Friend",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.primary,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> pages = const [
    HomeTap(),
    EventsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildHomeAppBar(),
      body: pages[currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
