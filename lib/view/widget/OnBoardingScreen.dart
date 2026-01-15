import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

import '../../Controllers/OnBoardingController.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OnBoardingController controller = Get.put(OnBoardingController());

    return Scaffold(
      // نستخدم Container لتطبيق التدرج اللوني على كامل الخلفية
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // يبدأ التدرج من الأعلى
            end: Alignment.bottomCenter, // ينتهي في الأسفل
            colors: [
              MyColors.primary.withOpacity(0.8), // لون أساسي مشبع قليلاً في الأعلى
              MyColors.primary.withOpacity(0.4), // لون أخف في المنتصف
              Colors.white, // ينتهي باللون الأبيض لراحة العين عند قراءة النصوص
            ],
            stops: const [0.0, 0.4, 0.9], // توزيع الألوان على الشاشة
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // زر التخطي
              Align(
                alignment: Alignment.topLeft,
                child: TextButton(
                  onPressed: controller.skip,
                  child: const Text(
                    "تخطي",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              // منطقة عرض الخدمات (PageView)
              Expanded(
                flex: 3,
                child: PageView.builder(
                  controller: controller.pageController,
                  onPageChanged: controller.onPageChanged,
                  itemCount: controller.onBoardingData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // أنيميشن الصورة
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.8, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            builder: (context, double val, child) {
                              return Transform.scale(scale: val, child: child);
                            },
                            child: Container(
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white, // خلفية بيضاء دائرية خلف الشعار لتبرزه
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  )
                                ],
                              ),
                              padding: const EdgeInsets.all(10),
                              child: ClipOval(
                                // داخل itemBuilder في OnBoardingScreen
                                child: controller.onBoardingData[index]['isAsset'] == true
                                    ? Image.asset(controller.onBoardingData[index]['image']!) // يعرض اللوجو
                                    : Icon(controller.onBoardingData[index]['icon'], size: 150, color: MyColors.primary), // يعرض أيقونة إذا الصورة غير موجودة
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),

                          // العنوان بنص أبيض ليظهر بوضوح على التدرج
                          Text(
                            controller.onBoardingData[index]['title']!,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // جعلناه أبيض ليتناسب مع الخلفية الزرقاء
                              shadows: [Shadow(blurRadius: 10, color: Colors.black26, offset: Offset(0, 2))],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // الوصف
                          Text(
                            controller.onBoardingData[index]['body']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // التحكم السفلي (النقاط والزر)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // مؤشر النقاط
                    Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          controller.onBoardingData.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(right: 5),
                            height: 8,
                            width: controller.currentIndex.value == index ? 25 : 8,
                            decoration: BoxDecoration(
                              color: controller.currentIndex.value == index
                                  ? MyColors.primary
                                  : Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),

                    // زر المتابعة بشكل عصري
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: Obx(
                              () => ElevatedButton(
                            onPressed: controller.next,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // زر أبيض على خلفية ملونة
                              foregroundColor: MyColors.primary,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              controller.currentIndex.value == controller.onBoardingData.length - 1
                                  ? "ابدأ رحلتك"
                                  : "التالي",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}