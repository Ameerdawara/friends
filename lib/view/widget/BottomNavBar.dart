import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "الرئيسية",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "الأحداث",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: "الإشعارات",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "الإعدادات",
        ),
      ],
    );
  }
}
