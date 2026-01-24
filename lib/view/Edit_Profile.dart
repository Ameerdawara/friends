import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import '../../features/auth/controller/auth_controller.dart';
import 'package:testing/view/widget/MyDropdown.dart'; // تأكد من المسار
import '../Controllers/EditProfileController.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  // حقن الكونترولر الجديد
  final EditProfileController controller = Get.put(EditProfileController());
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("تعديل الملف الشخصي",
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- صورة الملف الشخصي ---
              GestureDetector(
                onTap: controller.pickImage,
                child: Stack(
                  children: [
                    Obx(() {
                      ImageProvider bgImage;
                      final user = authController.currentUser.value;

                      if (controller.newImage.value != null) {
                        bgImage = FileImage(controller.newImage.value!);
                      } else if (user?.fullImageUrl.isNotEmpty ?? false) {
                        bgImage = NetworkImage(user!.fullImageUrl);
                      } else {
                        bgImage = const AssetImage("images/CF.webp");
                      }

                      return CircleAvatar(
                        radius: 60,
                        backgroundImage: bgImage,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: MyColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- الحقول النصية ---
              _buildTextField(context, "الاسم الكامل", controller.nameController, Icons.person),
              const SizedBox(height: 15),
              _buildTextField(context, "رقم الهاتف", controller.phoneController, Icons.phone),

              const SizedBox(height: 15),

              // --- القوائم المنسدلة (Dropdowns) ---

              // 1. المحافظة
              Obx(() => MyDropdown(
                label: "المحافظة",
                hint: "اختر المحافظة",
                icon: const Icon(Icons.map_outlined, color: MyColors.primary),
                items: controller.iraqData.keys.toList(),
                value: controller.selectedGovernorate.value.isEmpty
                    ? null
                    : controller.selectedGovernorate.value,
                onChanged: (val) => controller.updateGovernorate(val),
              )),

              const SizedBox(height: 15),

              // 2. المدينة
              Obx(() => MyDropdown(
                label: "المدينة / المنطقة",
                hint: "اختر المدينة",
                icon: const Icon(Icons.location_city_outlined, color: MyColors.primary),
                items: controller.currentCitiesList.toList(),
                value: controller.selectedCity.value.isEmpty
                    ? null
                    : controller.selectedCity.value,
                onChanged: (val) => controller.updateCity(val),
              )),

              const SizedBox(height: 40),

              // --- زر الحفظ ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: authController.loading.value
                      ? null
                      : () {
                    controller.saveProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: authController.loading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("حفظ التغييرات",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, String label,
      TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
      decoration: InputDecoration(

        labelText: label,
        labelStyle:
        TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
        prefixIcon: Icon(icon, color: Colors.grey),
        fillColor: Theme.of(context).cardColor,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.primary, width: 2),
        ),
      ),
    );
  }
}