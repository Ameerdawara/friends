import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

// نموذج بيانات بسيط للحدث (يمكن نقله لاحقاً لملف منفصل)
class WorkEvent {
  final String title;
  final String description;
  final String beforeImage;
  final String afterImage;
  final String date;
  final String category;

  WorkEvent({
    required this.title,
    required this.description,
    required this.beforeImage,
    required this.afterImage,
    required this.date,
    required this.category,
  });
}

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // بيانات وهمية للتجربة (يتم جلبها لاحقاً من قاعدة البيانات)
    final List<WorkEvent> events = [
      WorkEvent(
        title: "إصلاح تسريب مطبخ",
        description: "تم استبدال الأنابيب القديمة بالكامل وإصلاح التسريب.",
        beforeImage: "images/before_plumbing.jpg", // تأكد من وجود صور تجريبية أو استخدم رابط
        afterImage: "images/after_plumbing.jpg",
        date: "منذ ساعتين",
        category: "سباكة",
      ),
      WorkEvent(
        title: "تصميم طاولة مكتبية",
        description: "تفصيل طاولة خشب بلوط حسب طلب الزبون.",
        beforeImage: "images/before_carpentry.jpg",
        afterImage: "images/after_carpentry.jpg",
        date: "أمس",
        category: "نجارة",
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: events.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return _buildEventCard(context, events[index]);
        },
      ),
    );
  }

  // بطاقة عرض العمل (الحدث)
  Widget _buildEventCard(BuildContext context, WorkEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. رأس البطاقة (التصنيف والتاريخ)
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MyColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.handyman, color: MyColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.category,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      event.date,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                // زر خيارات إضافية
                const Icon(Icons.more_horiz, color: Colors.grey),
              ],
            ),
          ),

          // 2. قسم الصور (قبل وبعد)
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // صورة قبل
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // في حال عدم وجود صورة حقيقية نضع لون رمادي
                      Container(color: Colors.grey[300], child: const Icon(Icons.image_not_supported)),
                      // Image.asset(event.beforeImage, fit: BoxFit.cover), // فعل هذا السطر عند وجود الصور
                      Container(
                        color: Colors.black.withOpacity(0.3),
                        alignment: Alignment.center,
                        child: const Text("قبل", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                ),
                Container(width: 2, color: Colors.white), // فاصل بسيط
                // صورة بعد
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.grey[400], child: const Icon(Icons.check_circle_outline)),
                      // Image.asset(event.afterImage, fit: BoxFit.cover), // فعل هذا السطر عند وجود الصور
                      Container(
                        color: MyColors.primary.withOpacity(0.2), // تلوين خفيف بلون التطبيق
                        alignment: Alignment.center,
                        child: const Text("بعد", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. الوصف والتفاصيل
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  style: TextStyle(color: Colors.grey[700], height: 1.4),
                ),
                const SizedBox(height: 15),

                // 4. أزرار التفاعل (محادثة + طلب مماثل)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // فتح محادثة بخصوص هذا العمل
                          Get.snackbar("مراسلة", "جارِ فتح المحادثة مع الإدارة بخصوص هذا العمل");
                        },
                        icon:  Icon(Icons.chat_bubble_outline, size: 18,color: Theme.of(context).textTheme.bodyMedium?.color,),
                        label:  Text("استفسار / محادثة",style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // توجيه لطلب نفس الخدمة
                          // Get.to(() => CategorySelectionPage());
                        },
                        icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.white),
                        label: const Text("طلب خدمة", style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // حالة الصفحة الفارغة
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "لا توجد أعمال منشورة حالياً",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
