import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/widget/Cartc.dart';
import '../Controllers/AdsController.dart';
import 'ServicesSelectionPage.dart';

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    final AdsController adsController = Get.put(AdsController());

    // قائمة الخدمات
    final List<Map<String, dynamic>> services = [
      {
        "title": "الخدمات المنزلية",
        "subtitle": "سباكة، كهرباء، حدادة، نجارة...",
        "lottiePath": "animations/Home & Boiler Care.json",
        "color": MyColors.primary,
        "isActive": true,
      },
      {
        "title": "العقارات",
        "subtitle": "بيع، شراء، إيجار (قريباً)",
        "lottiePath": "animations/real estate.json",
        "color": Colors.grey,
        "isActive": false,
      },
      {
        "title": "التوصيل",
        "subtitle": "توصيل الطلبات (قريباً)",
        "lottiePath": "animations/Delivery guy.json",
        "color": Colors.grey,
        "isActive": false,
      },
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: RefreshIndicator(
      color: MyColors.primary,
      onRefresh: () async {
      // استدعاء دالة التحديث وانتظارها
      await adsController.fetchAds();
      },
      child:CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 1. قسم الإعلانات (Slider)
          SliverToBoxAdapter(
            child: Obx(() {
              if (adsController.isLoading.value) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (adsController.adsList.isEmpty) {
                return const SizedBox.shrink();
              }

              return SizedBox(
                height: 200,
                child: PageView.builder(
                  itemCount: adsController.adsList.length,
                  itemBuilder: (context, index) {
                    final ad = adsController.adsList[index];
                    return _buildAdCard(context, ad); // مررنا الـ context هنا
                  },
                ),
              );
            }),
          ),

          /// 2. عنوان القائمة
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "كيف تود طلب الخدمة؟",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),

          /// 3. قائمة الخدمات الرئيسية
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ServiceCard(
                      title: services[index]['title']!,
                      subtitle: services[index]['subtitle']!,
                      lottiePath: services[index]['lottiePath']!,
                      cardColor: services[index]['color']!,
                      onTap: () {
                        if (services[index]['isActive'] == true) {
                          Get.to(() => const ServicesSelectionPage());
                        } else {
                          Get.snackbar(
                            "قريباً",
                            "هذه الخدمة غير متاحة حالياً",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black87,
                            colorText: Colors.white,
                          );
                        }
                      },
                    ),
                  );
                },
                childCount: services.length,
              ),
            ),
          ),
        ],
      ),
    ));
  }

  // تصميم كارد الإعلان الاحترافي
  Widget _buildAdCard(BuildContext context, ad) {
    return GestureDetector(
      onTap: () {
        // عرض الديالوج عند الضغط
        _showAdDetailsDialog(context, ad);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
          ],
        ),
        child: Stack(
          children: [
            // الصورة من السيرفر
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  ad.fullImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      "images/ads.jpg",
                      fit: BoxFit.cover),
                ),
              ),
            ),

            // التظليل والنص
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ad.title ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      ad.description ?? "",
                      style:
                      const TextStyle(color: Colors.white70, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لعرض تفاصيل الإعلان في ديالوج
  void _showAdDetailsDialog(BuildContext context, ad) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent, // شفافية الخلفية حول الكارد
        insetPadding: const EdgeInsets.all(15),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ليأخذ الحجم المناسب للمحتوى
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة الإعلان الكبيرة
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  ad.fullImageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    "images/ads.jpg",
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان
                    Text(
                      ad.title ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // الوصف الكامل
                    Text(
                      ad.description ?? "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // زر إغلاق
              Padding(
                padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text("إغلاق",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true, // يسمح بالإغلاق عند الضغط خارج المربع
    );
  }
}