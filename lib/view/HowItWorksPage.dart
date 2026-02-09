import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    // التحقق من حالة الثيم الحالي
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // 1. رأس الصفحة المتحرك
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            backgroundColor: MyColors.primary,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Close ",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    TextSpan(
                      text: "Friend",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70),
                    ),
                  ],
                ),
              ),
              background: Image.asset('images/CF.webp', fit: BoxFit.cover),
            ),
          ),

          // 2. محتوى الصفحة
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- قسم "من نحن" ---
                    _buildSectionTitle(context, "من نحن؟", Icons.info_outline),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "في Close Friend، نحن لا نصلح الأعطال فحسب، بل نعيد الهدوء إلى منزلك.",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: MyColors.primary,
                                height: 1.5),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "نحن منصة خدمات منزلية متكاملة تهدف إلى ربطك بأمهر الحرفيين الموثوقين في منطقتك بضغطة زر.",
                            style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.8),
                                height: 1.6),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // --- قسم "كيف يعمل التطبيق" ---
                    _buildSectionTitle(context, "كيف تطلب خدمة؟", Icons.touch_app_outlined),
                    const SizedBox(height: 15),

                    _buildStep(context, "1", "اختر الخدمة", "تصفح قائمة الخدمات واختر ما يناسب مشكلتك.", Icons.category_outlined),
                    _buildStep(context, "2", "حدد التفاصيل", "اكتب وصفاً بسيطاً للمشكلة وأرفق صورة إن وجد.", Icons.description_outlined),
                    _buildStep(context, "3", "أكد طلبك", "حدد موقعك ورقم هاتفك وسيصلك الحرفي.", Icons.location_on_outlined),
                    _buildStep(context, "4", "الدفع والتقييم", "بعد إتمام العمل، يمكنك الدفع وتقييم الحرفي.", Icons.star_rate_rounded),

                    const SizedBox(height: 30),

                    // --- قسم "لماذا نحن" ---
                    _buildSectionTitle(context, "لماذا Close Friend؟", Icons.verified_user_outlined),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFeatureCard(context, "حرفيون موثوقون", Icons.security),
                          _buildFeatureCard(context, "سرعة في الأداء", Icons.speed),
                          _buildFeatureCard(context, "أسعار تنافسية", Icons.attach_money),
                          _buildFeatureCard(context, "دعم فني 24/7", Icons.headset_mic),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: () => Get.back(),
                        child: const Text("ابدأ رحلتك الآن", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: MyColors.primary, size: 28),
        const SizedBox(width: 10),
        Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
      ],
    );
  }

  Widget _buildStep(BuildContext context, String number, String title, String desc, IconData icon) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: MyColors.primary, shape: BoxShape.circle),
                child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ),
              Container(width: 2, height: 60, color: Colors.grey.withOpacity(0.3)),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 20, color: MyColors.primary),
                      const SizedBox(width: 8),
                      Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(desc, style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: MyColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: MyColors.primary, size: 30),
          const SizedBox(height: 10),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }
}