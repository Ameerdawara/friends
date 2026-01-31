import 'package:get/get.dart';
import 'package:dio/dio.dart'; // تأكد من استيراد dio
import '../core/network/dio_client.dart';
import '../data/model/NotificationModel.dart'; // تأكد من مسار الموديل

class NotificationsController extends GetxController {
  var isLoading = true.obs;
  var notificationList = <NotificationModel>[].obs;

  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  // دالة جلب الإشعارات باستخدام DioClient
  Future<void>  fetchNotifications() async {
    try {
      isLoading(true);

      // لا حاجة لإضافة الهيدر أو الرابط الأساسي يدوياً، DioClient يقوم بذلك
      var response = await DioClient.dio.get('/notifications');

      if (response.statusCode == 200) {
        // Dio يعيد البيانات كـ Map أو List مباشرة ولا يحتاج json.decode
        var jsonData = response.data;

        // حسب هيكلية Laravel Pagination، البيانات تكون داخل 'data'
        var data = jsonData['data'] as List;

        notificationList.value = data.map((e) => NotificationModel.fromJson(e)).toList();
      }
    } on DioException catch (e) {
      print("Dio Error: ${e.response?.statusCode} - ${e.message}");
    } catch (e) {
      print("Error fetching notifications: $e");
    } finally {
      isLoading(false);
    }
  }

  // دالة تحديد الإشعار كمقروء
  void markAsRead(int id) async {
    try {
      await DioClient.dio.post('/notifications/$id/read');

      // تحديث القيمة محلياً لإخفاء علامة "غير مقروء" دون الحاجة لإعادة التحميل
      int index = notificationList.indexWhere((n) => n.id == id);
      if(index != -1) {
        var old = notificationList[index];
        notificationList[index] = NotificationModel(
            id: old.id,
            title: old.title,
            message: old.message,
            isRead: true, // تحديث الحالة
            createdAt: old.createdAt
        );
        notificationList.refresh(); // لتحديث الواجهة في GetX
      }
    } catch (e) {
      print("Error marking as read: $e");
    }
  }
  int get unreadCount => notificationList.where((n) => !n.isRead).length;
}