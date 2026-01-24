import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing/Controllers/ProfileController.dart';
import 'package:testing/constans/MyColor.dart'; // تأكد من المسار

// استيراد الكنترولرات
import '../../features/auth/controller/auth_controller.dart';
// تأكد من استيراد البروفايل كنترولر الجديد
class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  // ✅ 1. نحتاج AuthController فقط لقراءة البيانات الحالية
  final AuthController authController = Get.find<AuthController>();
  
  // ✅ 2. نحتاج ProfileController للقيام بعملية التحديث (Put)
  // نستخدم Get.put لضمان إنشاء الكنترولر إذا لم يكن موجوداً
  final ProfileController profileController = Get.put(ProfileController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final Rx<File?> newImage = Rx<File?>(null);

  @override
  Widget build(BuildContext context) {
    // تعبئة البيانات الحالية عند فتح الصفحة
    final user = authController.currentUser.value;
    
    nameController.text = user?.name ?? "";
    // تأكد أن مودل User لديك يحتوي على حقل phone و city
    // أو user?.profile?.phone إذا كانت البيانات متداخلة
    phoneController.text = user?.phone ?? ""; 
    cityController.text = user?.city ?? "";   

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
              // --- تغيير الصورة ---
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Obx(() {
  ImageProvider bgImage;
  final user = authController.currentUser.value;

  if (newImage.value != null) {
    // 1. إذا قام المستخدم باختيار صورة جديدة من المعرض الآن
    bgImage = FileImage(newImage.value!);
  } else if (user?.image != null && user!.image!.isNotEmpty) {
    // 2. إذا كانت الصورة موجودة في السيرفر
    // تأكد من استخدام http وليس https إذا كنت تعمل محلياً
    // وتأكد من كتابة الرابط بشكل صحيح مع المنفذ 8000 ومجلد storage
    String fullUrl = "http://192.168.1.3:8000/storage/${user.image}";
    bgImage = NetworkImage(fullUrl);
  } else {
    // 3. إذا لم يرفع المستخدم صورة أبداً (صورة افتراضية)
    // تأكد أن هذا الملف موجود في مجلد assets/images لديك
    bgImage = const AssetImage("assets/images/CF.webp");
  }

  return CircleAvatar(
    radius: 60,
    backgroundImage: bgImage,
    // هذا السطر يمنع ظهور الخطأ الأحمر في واجهة المستخدم إذا فشل التحميل
    onBackgroundImageError: (exception, stackTrace) {
       print("خطأ في تحميل الصورة: $exception");
    },
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

              // --- الحقول ---
              _buildTextField(context, "الاسم الكامل", nameController, Icons.person),
              const SizedBox(height: 15),
              _buildTextField(context, "رقم الهاتف", phoneController, Icons.phone),
              const SizedBox(height: 15),
              _buildTextField(context, "المدينة", cityController, Icons.location_city),

              const SizedBox(height: 40),

              // --- زر الحفظ ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Obx(() => ElevatedButton(
                      // ✅ نراقب التحميل من profileController
                      onPressed: profileController.loading.value
                          ? null
                          : () {
                              // ✅ استدعاء دالة التحديث من ProfileController
                              profileController.updateProfile(
                                name: nameController.text,
                                phone: phoneController.text,
                                city: cityController.text,
                                imagePath: newImage.value?.path,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      child: profileController.loading.value
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
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: MyColors.primary, width: 2),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      newImage.value = File(pickedFile.path);
    }
  }
}