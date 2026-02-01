import 'package:get/get.dart';
import '../core/network/dio_client.dart';

import '../data/model/EventModel.dart'; // تأكد من المسار

class EventsController extends GetxController {
  var isLoading = true.obs;
  var eventsList = <EventModel>[].obs;

  @override
  void onInit() {
    fetchEvents();
    super.onInit();
  }

  Future<void>  fetchEvents() async {
    try {
      isLoading(true);
      // طلب GET للرابط /events
      var response = await DioClient.dio.get('/events');

      if (response.statusCode == 200) {
        // بما أن الباك اند يستخدم paginate(10)، البيانات تكون داخل 'data'
        var jsonData = response.data;
        var data = jsonData['data'] as List;

        eventsList.value = data.map((e) => EventModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching events: $e");
    } finally {
      isLoading(false);
    }
  }
}