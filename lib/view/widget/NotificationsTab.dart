import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // تأكد من إضافة هذه المكتبة في pubspec.yaml لتنسيق التاريخ
import '../../Controllers/NotificationsController.dart';
import '../../Controllers/NavigationController.dart'; // نحتاجه فقط إذا كنت ستستخدم التقييم
import 'package:testing/constans/MyColor.dart'; // تأكد من المسار

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر الجديد
    final NotificationsController controller = Get.put(NotificationsController());
    // كنترولر التقييم (اختياري حسب منطقك الحالي)
    final NavigationController navController = Get.put(NavigationController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body:RefreshIndicator(
      color: MyColors.primary,
    onRefresh: () async {
    await controller.fetchNotifications();
    },
    child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notificationList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.withOpacity(0.5)),
                const SizedBox(height: 15),
                const Text("لا توجد إشعارات حالياً", style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.fetchNotifications();
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: controller.notificationList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = controller.notificationList[index];

              // تحويل تاريخ النص إلى كائن تاريخ لتنسيقه
              DateTime? parsedDate = DateTime.tryParse(notification.createdAt);
              String timeDisplay = parsedDate != null
                  ? DateFormat('yyyy-MM-dd – kk:mm').format(parsedDate)
                  : notification.createdAt;

              return InkWell(
                onTap: () {
                  // تحديد كـ مقروء عند الضغط
                  if (!notification.isRead) {
                    controller.markAsRead(notification.id);
                  }

                  // ملاحظة: قاعدة البيانات لديك لا تحتوي على عمود "type"
                  // لذا سيتم عرض تفاصيل عادية، أو يمكنك فتح نافذة التقييم يدوياً للتجربة
                  _showNotificationDetails(context, notification.title, notification.message);
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? Theme.of(context).cardColor
                        : MyColors.primary.withOpacity(0.05), // لون مميز لغير المقروء
                    borderRadius: BorderRadius.circular(12),
                    border: notification.isRead
                        ? Border.all(color: Colors.grey.withOpacity(0.2))
                        : Border.all(color: MyColors.primary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 3)
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // أيقونة الإشعار
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: notification.isRead
                              ? Colors.grey.withOpacity(0.1)
                              : MyColors.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: notification.isRead ? Colors.grey : MyColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 15),

                      // النصوص
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                        fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                                        fontSize: 15,
                                        color: Theme.of(context).textTheme.bodyLarge?.color
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!notification.isRead)
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              notification.message,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                                  height: 1.4
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              timeDisplay,
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    ));
  }

  // نافذة عرض التفاصيل بسيطة
  void _showNotificationDetails(BuildContext context, String title, String body) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Text(body, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                onPressed: () => Get.back(),
                child: const Text("إغلاق", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}