import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../Controllers/ServiceController.dart'; // تأكد من صحة المسار

class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. حقن الكنترولر لضمان وجوده في الذاكرة عند فتح الصفحة
    final ServiceController controller = Get.put(ServiceController());

    // بيانات وهمية للاختبار
    final List<Map<String, String>> notifications = [
      {
        "title": "يرجى تقييم الخدمة",
        "time": "منذ ساعتين",
        "message": "كيف كانت تجربتك مع خدمة السباكة؟",
        "type": "rating"
      },
      {
        "title": "تحديث الطلب",
        "time": "منذ 10 دقائق",
        "message": "الفني أحمد بانتظارك الآن عند الموقع.",
        "type": "info"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],

      body: ListView.separated(
        padding: const EdgeInsets.all(15),
        itemCount: notifications.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: ListTile(
              onTap: () {
                // إذا كان نوع الإشعار تقييم، نفتح النافذة
                if (notifications[index]['type'] == "rating") {
                  _showRatingDialog(controller);
                }
              },
              leading: CircleAvatar(
                backgroundColor: MyColors.primary.withOpacity(0.1),
                child: Icon(Icons.notifications_active, color: MyColors.primary),
              ),
              title: Text(notifications[index]['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(notifications[index]['message']!),
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.blue),
                onPressed: () {
                  Get.snackbar("الدردشة", "جاري فتح المحادثة مع الفني...");
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // دالة عرض نافذة التقييم التفاعلية
  void _showRatingDialog(ServiceController controller) {
    controller.userRating.value = 0; // تصفير النجوم عند الفتح

    Get.defaultDialog(
      title: "تقييم الخدمة",
      content: Column(
        children: [
          const Text("ما هو تقييمك لأداء الحرفي؟"),
          const SizedBox(height: 15),

          //
          // الجزء التفاعلي للنجوم
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  // إذا كان التقييم المختار 3 مثلاً، النجوم 1 و 2 و 3 ستمتلئ
                  index < controller.userRating.value
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  color: Colors.amber,
                  size: 25,
                ),
                onPressed: () {
                  controller.updateRating(index + 1); // تحديث القيمة
                },
              );
            }),
          )),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ملاحظات إضافية...",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          if (controller.userRating.value > 0) {
            Get.back();
            Get.snackbar("شكراً لك", "تم استلام تقييمك بـ ${controller.userRating.value} نجوم");
          } else {
            Get.snackbar("تنبيه", "يرجى اختيار النجوم للتقييم");
          }
        },
        child: const Text("إرسال التقييم", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}