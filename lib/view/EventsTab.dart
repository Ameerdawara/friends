import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../Controllers/EventsController.dart'; // استيراد الكنترولر
import '../data/model/EventModel.dart';
import 'ServicesSelectionPage.dart'; // استيراد الموديل

class EventsTab extends StatelessWidget {
  const EventsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final EventsController controller = Get.put(EventsController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body:RefreshIndicator(
      color: MyColors.primary,
      onRefresh: () async {
      await controller.fetchEvents();
      },
      child: Column(
        children: [
          // شريط العنوان أو الفلتر العلوي (اختياري)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  "أحدث الأعمال المنجزة",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                // زر طلب خدمة (كما كان في الكود القديم)
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(() => ServicesSelectionPage());
                  },
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text("طلب خدمة", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),

          // القائمة
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.eventsList.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                itemCount: controller.eventsList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final event = controller.eventsList[index];
                  return _buildEventCard(context, event);
                },
              );
            }),
          ),
        ],
      ),
    ));
  }

  // بناء كارد الحدث باستخدام البيانات الحقيقية
  Widget _buildEventCard(BuildContext context, EventModel event) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
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
          // 1. صور قبل وبعد
          Row(
            children: [
              Expanded(child: _buildImageSection(event.fullBeforeImage, "قبل")),
              Container(width: 1, height: 150, color: Colors.white), // فاصل
              Expanded(child: _buildImageSection(event.fullAfterImage, "بعد")),
            ],
          ),

          // 2. التفاصيل
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      event.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    // عرض التاريخ بشكل بسيط (يمكن تحسينه باستخدام مكتبة intl)
                    Text(
                      event.createdAt.substring(0, 10), // يأخذ فقط السنة والشهر واليوم
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  event.description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // عرض اسم الفني إذا وجد
                if (event.workerName != null)
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 16, color: MyColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        "تنفيذ: ${event.workerName}",
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: MyColors.primary),
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

  // ودجت صغيرة لعرض الصورة مع التسمية
  Widget _buildImageSection(String imageUrl, String label) {
    return Stack(
      children: [
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10)),
          ),
        ),
      ],
    );
  }

  // تصميم الحالة الفارغة
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