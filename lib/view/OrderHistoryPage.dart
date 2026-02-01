import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../Controllers/OrderController.dart';
import '../data/model/OrderModel.dart'; // استيراد الموديل

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final OrderController controller = Get.put(OrderController());

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "سجل الطلبات",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.primary),
      ),
      body: RefreshIndicator(
        color: MyColors.primary,
        onRefresh: () async {
          await controller.refreshOrders();
        },
        child: Obx(() {
          // 1. حالة التحميل
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: MyColors.primary));
          }

          // 2. حالة القائمة فارغة
          if (controller.ordersList.isEmpty) {
            return _buildEmptyState(controller);
          }

          // 3. عرض القائمة
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.ordersList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemBuilder: (context, index) {
              final order = controller.ordersList[index];
              return _buildOrderCard(context, order);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    // تحديد الألوان والأيقونات بناءً على نوع الطلب
    final bool isDirect = order.isDirect;
    final Color statusColor = isDirect ? Colors.orange : Colors.green; // لون افتراضي
    final IconData icon = isDirect ? Icons.handyman : Icons.camera_alt;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الرأس: الرقم والحالة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: MyColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "#${order.id}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: MyColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status, // "قيد المعالجة"
                  style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // المحتوى
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الأيقونة الجانبية
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: MyColors.primary, size: 24),
              ),
              const SizedBox(width: 15),

              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.displayTitle,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      order.description.isNotEmpty
                          ? order.description
                          : "لا يوجد وصف إضافي",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // التاريخ
                    _buildInfoRow(Icons.calendar_today, order.createdAt.substring(0, 10)),

                    // الموقع (إن وجد)
                    if (order.address != null) ...[
                      const SizedBox(height: 5),
                      _buildInfoRow(Icons.location_on, order.address!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(OrderController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          const Text(
            "لا توجد طلبات سابقة",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => controller.refreshOrders(),
            style: ElevatedButton.styleFrom(backgroundColor: MyColors.primary),
            child: const Text("تحديث الصفحة", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}