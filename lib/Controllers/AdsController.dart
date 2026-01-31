import 'package:get/get.dart';
import '../core/network/dio_client.dart';
import '../data/model/AdModel.dart';

class AdsController extends GetxController {
  var isLoading = true.obs;
  var adsList = <AdModel>[].obs;

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }

  // قمنا بتغيير void إلى Future<void>
  Future<void> fetchAds() async {
    try {
      isLoading(true);
      var response = await DioClient.dio.get('/ads');

      if (response.statusCode == 200) {
        var data = response.data['ads'] as List;
        adsList.value = data.map((e) => AdModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error fetching ads: $e");
    } finally {
      isLoading(false);
    }
  }
}