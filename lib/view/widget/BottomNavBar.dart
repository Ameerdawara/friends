import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
// تأكد من استيراد الكونترولر هنا
import 'package:testing/Controllers/NotificationsController.dart';

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
    // الوصول للكونترولر الموجود مسبقاً في الذاكرة
    final NotificationsController notifyController = Get.find<NotificationsController>();

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: MyColors.primary,
      unselectedItemColor: Colors.grey,
      // تمت إزالة const من هنا لتفعيل التحديث الديناميكي
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "الرئيسية",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "الأحداث",
        ),
        BottomNavigationBarItem(
          // استخدام Obx لتحديث الأيقونة عند تغير عدد الإشعارات
          icon: Obx(() => Stack(
            children: [
              const Icon(Icons.notifications),
              if (notifyController.unreadCount > 0)
                Positioned(
                  right: -1,
                  top: -3,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 13,
                      minHeight: 13,
                    ),
                    child: Text(
                      '${notifyController.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          )),
          label: "الإشعارات",
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: "الإعدادات",
        ),
      ],
    );
  }
}