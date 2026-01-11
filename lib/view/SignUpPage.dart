import 'dart:io';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/loginPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/TextForm.dart';

import '../Controller/SignUpController.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final SignUpController controller = Get.put(SignUpController());
  TextEditingController usrename = TextEditingController();
  TextEditingController emailOrPhone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text(
              "Sign",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "Up",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Center(
            child: GestureDetector(
              onTap: () => controller.pickImage(),
              child: Obx(() {
                // استخراج المسار في متغير لتسهيل التعامل معه
                String path = controller.selectedImagePath.value;

                return CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  // نقوم بإنشاء كائن File من المسار وتمريره لـ FileImage
                  backgroundImage: path.isNotEmpty
                      ? FileImage(File(path))
                      : null,
                  child: path.isEmpty
                      ? Icon(Icons.camera_alt, size: 40, color: MyColors.primary)
                      : null,
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          const SizedBox(
            height: 20,
          ),
          MyTestForm(
              hint: "Enter your username",
              icon: const Icon(Icons.text_snippet_outlined),
              label: "Username",
              mycontroller: usrename),

          const SizedBox(
            height: 30,
          ),
          MyTestForm(
              hint: "Enter Email or Phone Number",
              icon: const Icon(Icons.contact_mail_outlined),
              label: "Email or Phone",

              mycontroller: emailOrPhone),
          const SizedBox(
            height: 30,
          ),
          MyTestForm(
              hint: "Enter your password",
              icon: const Icon(Icons.lock_outline),
              label: "Password",
              mycontroller: password),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(height: 30,),
          MyButton(
              text: "Sign Up",
              onPressed: ()  {
                print("Image Path: ${controller.selectedImagePath.value}");
              }),
          const SizedBox(
            height: 30,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  " have an account ?  ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Log In",
                  style: TextStyle(
                      color: MyColors.primary, fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
