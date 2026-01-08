import 'package:flutter/material.dart';
import 'package:testing/view/widget/Cartc.dart';
import '../../../constans/MyColor.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ServiceCard(
          title: "الخدمات المنزلية",
          subtitle: "تنظيف، صيانة، سباكة، كهرباء وغيرها",
          imagePath: "images/home_services.jpg",
        ),
        SizedBox(height: 160),
        ServiceCard(
          title: "العقارات",
          subtitle: "بيع، شراء، إيجار الشقق والمنازل",
          imagePath: "images/real_estate.jpg",
        ),
        SizedBox(height: 16),
        ServiceCard(
          title: "التوصيل",
          subtitle: "توصيل سريع وآمن لجميع الطلبات",
          imagePath: "images/delivery.jpg",
        ),
      ],
    );
  }
}
