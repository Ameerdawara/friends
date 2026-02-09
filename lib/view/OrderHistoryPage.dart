import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controllers/OrderController.dart';
import '../data/model/OrderModel.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن الكنترولر
    final OrderController controller = Get.put(OrderController());

    return Scaffold(
      // استخدام لون الخلفية من الثيم (يتغير تلقائياً بين الفاتح والداكن)
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "طلباتي السابقة",
          // استخدام الستايل من الثيم الحالي
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.refreshOrders(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.ordersList.isEmpty) {
            return _buildEmptyState(controller, context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: controller.ordersList.length,
            itemBuilder: (context, index) {
              return _buildOrderCard(controller.ordersList[index], context);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(OrderModel order, BuildContext context) {
    // تحديد خصائص الحالة
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (order.status) {
      case 'accepted':
        statusColor = Colors.green;
        statusText = "تم القبول";
        statusIcon = Icons.check_circle;
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusText = "مرفوض";
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.orange;
        statusText = "قيد الانتظار";
        statusIcon = Icons.access_time_filled;
    }

    // تحديد لون النص الثانوي بناءً على الثيم (فاتح أو داكن)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        // هنا التعديل الأساسي: استخدام لون الكارد من الثيم بدلاً من الأبيض الثابت
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.profession ??
                    (order.serviceType == 'image_request'
                        ? "طلب خاص"
                        : "طلب مباشر"),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              // عرض الحالة
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  // جعل خلفية الحالة بلون خفيف جداً ليتناسب مع الثيمين
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 5),
                    Text(
                      statusText,
                      style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Icon(Icons.description_outlined,
                  size: 16, color: secondaryTextColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  order.description ?? "لا يوجد وصف",
                  style: TextStyle(color: secondaryTextColor, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month,
                      size: 16, color: secondaryTextColor),
                  const SizedBox(width: 8),
                  Text(
                    "${order.createdAt.year}-${order.createdAt.month}-${order.createdAt.day}",
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                ],
              ),
              if (order.address != null)
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: secondaryTextColor),
                    const SizedBox(width: 4),
                    Text(order.address!,
                        style: TextStyle(fontSize: 11, color: secondaryTextColor)),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(OrderController controller, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history,
              size: 80,
              color: Theme.of(context).iconTheme.color?.withOpacity(0.3) ??
                  Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            "لا توجد طلبات سابقة",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TextButton(
              onPressed: () => controller.refreshOrders(),
              child: const Text("تحديث"))
        ],
      ),
    );
  }
}