import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/widget/Cartc.dart';

import 'ServicesSelectionPage.dart';
// import '../../constans/MyColor.dart'; // تأكد من المسار أو احذفه إذا لم يعد مستخدماً

class HomeTap extends StatelessWidget {
  const HomeTap({super.key});

  @override
  Widget build(BuildContext context) {
    // قائمة البيانات مع إضافة الألوان
    final List<Map<String, dynamic>> services = [
      {
        "title": "الخدمات المنزلية",
        "subtitle": "تنظيف، صيانة، سباكة، كهرباء وغيرها",
        "lottiePath": "animations/Home & Boiler Care.json",
        "color": const Color(0x9D3B85CE)
      },
      {
        "title": "العقارات",
        "subtitle": "بيع، شراء، إيجار الشقق والمنازل",
        "lottiePath": "animations/real estate.json",
        "color": const Color(0x9D3B85CE)// لون وردي/مرجاني
      },
      {
        "title": "التوصيل",
        "subtitle": "توصيل سريع وآمن لجميع الطلبات",
        "lottiePath": "animations/Delivery guy.json",
        "color": const Color(0x5C2280E1) // لون تركواز/أخضر
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// قسم العنوان والترحيب
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 10), // تعديل البادينغ العلوي
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ما الخدمة التي تبحث\nعنها اليوم؟",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // شريط البحث
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "ابحث عن خدمة...",
                        icon: Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// قائمة الخدمات
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 500 + (index * 200)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: child,
                          ),
                        );
                      },
                      child: ServiceCard(
                        title: services[index]['title']!,
                        subtitle: services[index]['subtitle']!,
                        lottiePath: services[index]['lottiePath']!,
                        cardColor: services[index]['color']!, // تمرير اللون
                        onTap: () {
                          if(services[index]==services[0])
                          Get.to(() => const ServicesSelectionPage()); // استيراد الصفحة الجديدة
                          // إضافة التنقل هنا
                        },
                      ),
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
}