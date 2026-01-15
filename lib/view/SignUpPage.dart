import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/loginPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/TextForm.dart';
import '../Controllers/SignUpController.dart';
import '../features/auth/controller/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  // استدعاء المتحكمات
  final SignUpController imageController = Get.put(SignUpController());
  final AuthController authController = Get.find<AuthController>();

  // متحكمات النصوص
  final TextEditingController username = TextEditingController();
  final TextEditingController emailOrPhone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();
  final TextEditingController governorate = TextEditingController(); // جديد
  final TextEditingController city = TextEditingController(); // جديد

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "إنشاء ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Text(
              "حساب",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: MyColors.primary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),

          // قسم الصورة الشخصية
          Center(
            child: Stack(
              children: [
                Obx(() => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: imageController.selectedImagePath.value.isNotEmpty
                      ? FileImage(File(imageController.selectedImagePath.value))
                      : null,
                  child: imageController.selectedImagePath.value.isEmpty
                      ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                      : null,
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => imageController.pickImage(),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: MyColors.primary,
                      child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          MyTestForm(
              hint: "اسم المستخدم الكامل",
              icon: const Icon(Icons.person_outline),
              label: "الاسم",
              mycontroller: username),

          const SizedBox(height: 20),

          MyTestForm(
              hint: "البريد الإلكتروني أو الهاتف",
              icon: const Icon(Icons.email_outlined),
              label: "بيانات الاتصال",
              mycontroller: emailOrPhone),

          const SizedBox(height: 20),

          // حقل المحافظة الجديد
          MyTestForm(
              hint: "أدخل المحافظة (مثلاً: بغداد)",
              icon: const Icon(Icons.map_outlined),
              label: "المحافظة",
              mycontroller: governorate),

          const SizedBox(height: 20),

          // حقل المدينة الجديد
          MyTestForm(
              hint: "أدخل المنطقة أو المدينة",
              icon: const Icon(Icons.location_city_outlined),
              label: "المدينة / المنطقة",
              mycontroller: city),

          const SizedBox(height: 20),

          MyTestForm(
              hint: "كلمة السر",
              icon: const Icon(Icons.lock_outline),
              label: "كلمة السر",
              mycontroller: password),

          const SizedBox(height: 20),

          MyTestForm(
              hint: "تأكيد كلمة السر",
              icon: const Icon(Icons.lock_reset_outlined),
              label: "تأكيد كلمة السر",
              mycontroller: passwordConfirmation),

          const SizedBox(height: 40),

          // الزر مرتبط بـ AuthController ومحدث لإرسال الحقول الجديدة
          Obx(() => MyButton(
            text: authController.loading.value ? "جاري المعالجة..." : "إنشاء حساب",
            onPressed: authController.loading.value
                ? null
                : () {
              authController.register(
                username.text,
                emailOrPhone.text,
                password.text,
                passwordConfirmation.text,
                governorate.text,
                city.text,
              );
            },
          )
          ),

          const SizedBox(height: 25),

          InkWell(
            onTap: () => Get.to(() => const LoginPage()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("لديك حساب بالفعل؟ "),
                Text(
                  "تسجيل دخول",
                  style: TextStyle(color: MyColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}