import 'package:get/get.dart';
import '../core/network/dio_client.dart';

import '../data/model/OrderModel.dart'; // تأكد من المسار

class OrderController extends GetxController {
  var isLoading = true.obs;
  var ordersList = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      // طلب GET للرابط /home-services
      var response = await DioClient.dio.get('/home-services');

      if (response.statusCode == 200) {
        // البيانات تأتي داخل مفتاح 'data' حسب كود الباك اند
        var data = response.data['data'] as List;
        ordersList.value = data.map((e) => OrderModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching orders: $e");
    } finally {
      isLoading(false);
    }
  }

  // دالة لتحديث الصفحة عند السحب
  Future<void> refreshOrders() async {
    await fetchOrders();
  }
}