import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controllers/ServiceController.dart'; // تأكد من المسار

class CategorySelectionPage extends StatelessWidget {
  const CategorySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.put(ServiceController());

    final List<Map<String, dynamic>> categories = [
      {"name": "كهربائي", "icon": Icons.electric_bolt, "color": Colors.yellow[700]},
      {"name": "سباك", "icon": Icons.water_drop, "color": Colors.blue},
      {"name": "نجار", "icon": Icons.weekend, "color": Colors.brown},
      {"name": "حداد", "icon": Icons.build, "color": Colors.grey},
      {"name": "صباغ", "icon": Icons.format_paint, "color": Colors.purple},
      {"name": "تكييف", "icon": Icons.ac_unit, "color": Colors.cyan},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("اختر الخدمة"), centerTitle: true),
      body: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              // عند الضغط يطلب التأكيد برقم الهاتف والموقع
              controller.confirmRequest(context, categories[index]['name']);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categories[index]['icon'], size: 50, color: categories[index]['color']),
                  const SizedBox(height: 10),
                  Text(
                    categories[index]['name'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}