// SignUpPage.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/loginPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/MyDropdown.dart';
import 'package:testing/view/widget/TextForm.dart';
// تأكد من استيراد MyDropdown إذا وضعته في ملف منفصل
// import 'package:testing/view/widget/MyDropdown.dart';

import '../Controllers/SignUpController.dart';
import '../features/auth/controller/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final SignUpController signUpController = Get.put(SignUpController());
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController username = TextEditingController();
  final TextEditingController emailOrPhone = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController passwordConfirmation = TextEditingController();
  // قمنا بحذف TextEditingController للمحافظة والمدينة لأننا سنستخدم Dropdown

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              "إنشاء ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "حساب",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          const SizedBox(height: 10),

          // قسم الصورة
          Center(
            child: Stack(
              children: [
                Obx(() => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: signUpController.selectedImagePath.value.isNotEmpty
                      ? FileImage(File(signUpController.selectedImagePath.value))
                      : null,
                  child: signUpController.selectedImagePath.value.isEmpty
                      ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                      : null,
                )),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => signUpController.pickImage(),
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

          // --- دروب داون المحافظة ---
          Obx(() => MyDropdown(
            label: "المحافظة",
            hint: "اختر المحافظة",
            icon: const Icon(Icons.map_outlined,color: MyColors.primary,),
            items: signUpController.iraqData.keys.toList(),
            value: signUpController.selectedGovernorate.value.isEmpty
                ? null
                : signUpController.selectedGovernorate.value,
            onChanged: (val) => signUpController.updateGovernorate(val),
          )),

          const SizedBox(height: 20),

          // --- دروب داون المدينة (يعتمد على المحافظة) ---
          Obx(() => MyDropdown(
            label: "المدينة / المنطقة",
            hint: "اختر المدينة",
            icon: const Icon(Icons.location_city_outlined, color: MyColors.primary),
            // نستخدم القائمة الفارغة اذا لم يتم اختيار محافظة
            items: signUpController.currentCitiesList.toList(),
            value: signUpController.selectedCity.value.isEmpty
                ? null
                : signUpController.selectedCity.value,
            onChanged: (val) => signUpController.updateCity(val),
          )),

          const SizedBox(height: 20),

          MyTestForm(
              hint: "كلمة السر",
              icon: const Icon(Icons.lock_outline, color: MyColors.primary,),
              label: "كلمة السر",
              mycontroller: password),

          const SizedBox(height: 20),

          MyTestForm(
              hint: "تأكيد كلمة السر",
              icon: const Icon(Icons.lock_reset_outlined, color: MyColors.primary),
              label: "تأكيد كلمة السر",
              mycontroller: passwordConfirmation),

          const SizedBox(height: 40),

          // زر الإنشاء
          Obx(() => MyButton(
            text: authController.loading.value ? "جاري المعالجة..." : "إنشاء حساب",
            onPressed: authController.loading.value
                ? null
                : () {
              if(signUpController.selectedGovernorate.value.isEmpty || signUpController.selectedCity.value.isEmpty){
                Get.snackbar("تنبيه", "يرجى اختيار المحافظة والمدينة");
                return;
              }

              // استدعاء الدالة مع إضافة مسار الصورة في النهاية ✅
              authController.register(
                username.text,
                emailOrPhone.text,
                password.text,
                passwordConfirmation.text,
                signUpController.selectedGovernorate.value,
                signUpController.selectedCity.value,
                  signUpController.selectedImagePath.value
                // ✅ تمرير مسار الصورة هنا
              );
            },
          )),

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