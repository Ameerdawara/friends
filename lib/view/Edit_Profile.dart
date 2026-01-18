import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/constans/MyColor.dart';
import '../../features/auth/controller/auth_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final AuthController authController = Get.find<AuthController>();

  // نستخدم كنترولرات نصوص محلية
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // متغير محلي للصورة الجديدة المختارة
  final Rx<File?> newImage = Rx<File?>(null);

  @override
  Widget build(BuildContext context) {
    // تعبئة البيانات الحالية
    final user = authController.currentUser.value;
    nameController.text = user?.name ?? "";
    phoneController.text = user?.phone ?? "";
    cityController.text = user?.city ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("تعديل الملف الشخصي", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // --- تغيير الصورة ---
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Obx(() {
                      // الأولوية للصورة الجديدة المختارة، ثم صورة السيرفر
                      ImageProvider bgImage;
                      if (newImage.value != null) {
                        bgImage = FileImage(newImage.value!);
                      } else if (user?.fullImageUrl.isNotEmpty ?? false) {
                        bgImage = NetworkImage(user!.fullImageUrl);
                      } else {
                        bgImage = const AssetImage("images/profile_placeholder.png");
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
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // --- الحقول ---
              _buildTextField("الاسم الكامل", nameController, Icons.person),
              const SizedBox(height: 15),
              _buildTextField("رقم الهاتف", phoneController, Icons.phone),
              const SizedBox(height: 15),
              _buildTextField("المدينة", cityController, Icons.location_city),

              const SizedBox(height: 40),

              // --- زر الحفظ ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                  onPressed: authController.loading.value ? null : () {
                    authController.updateProfile(
                      name: nameController.text,
                      phone: phoneController.text,
                      city: cityController.text,
                      imagePath: newImage.value?.path,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: authController.loading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("حفظ التغييرات", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة للحقول
  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.primary, width: 2),
        ),
      ),
    );
  }

  // دالة اختيار الصورة
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newImage.value = File(pickedFile.path);
    }
  }
}