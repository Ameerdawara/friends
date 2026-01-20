import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/widget/Cartc.dart';
import 'ServicesSelectionPage.dart'; // صفحة اختيار نوع الطلب (صورة أو مباشر)

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة الخدمات
    final List<Map<String, dynamic>> services = [
      {
        "title": "الخدمات المنزلية",
        "subtitle": "سباكة، كهرباء، حدادة، نجارة...",
        "lottiePath": "animations/Home & Boiler Care.json",
        "color": MyColors.primary,
        "isActive": true, // هذا القسم فعال
      },
      {
        "title": "العقارات",
        "subtitle": "بيع، شراء، إيجار (قريباً)",
        "lottiePath": "animations/real estate.json",
        "color": Colors.grey, // لون باهت للدلالة على عدم التوفر
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// 1. قسم العنوان والترحيب


          /// 2. قسم الإعلانات (شريط أفقي) - (طلبك الجديد)
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    "الإعلانات ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 160, // ارتفاع كارد الإعلان
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: 5, // عدد الإعلانات (يمكن جلبه من السيرفر)
                    itemBuilder: (context, index) {
                      return _buildAdCard(index);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),

          /// 3. قائمة الخدمات الرئيسية
           SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child:Text( // ✅ تمت إزالة const
                "كيف تود طلب الخدمة؟",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: // داخل SliverList -> delegate
                    ServiceCard( // تأكد من إزالة const إذا كانت البيانات ديناميكية مستقبلاً
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
    );
  }

  // دالة لبناء كارد الإعلان
  // دالة لبناء كارد الإعلان مع خاصية الضغط
  Widget _buildAdCard(int index) {
    return GestureDetector( // 1. إضافة GestureDetector أو InkWell
      onTap: () {
        // هنا تضع كود الانتقال لصفحة تفاصيل الإعلان
        print("تم الضغط على الإعلان رقم $index");
        // مثال: Get.to(() => AdDetailsPage(adId: index));
      },
      child: Container(
        width: 280,
        margin: EdgeInsets.only(
            right: 15, left: index == 0 ? 20 : 0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [MyColors.primary.withOpacity(0.9), Colors.transparent], // تدرج بلون الهوية
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                // يفضل استخدام NetworkImage عند الربط بالسيرفر
                child: Image.asset(
                  "images/ads.jpg",
                  fit: BoxFit.cover, // مهم لملء الكارد
                ),
              ),
            ),
            // ... باقي الكود (النصوص والتظليل)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  "إعلان رقم ${index + 1}\nخصم خاص للصيانة!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}