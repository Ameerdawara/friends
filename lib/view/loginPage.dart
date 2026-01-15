import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/features/auth/controller/auth_controller.dart';
import 'package:testing/view/HomePage.dart';
import 'package:testing/view/SignUpPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/TextForm.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text(
              "تسجيل",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "دخول",
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
          SizedBox(height: 10,),
          CircleAvatar(
              radius: 130,
        backgroundImage: AssetImage('images/CF.webp',)),

          const SizedBox(
            height: 40,
          ),
          MyTestForm(
              hint: "ادخل الايميل",
              icon: const Icon(Icons.email_outlined),
              label: "Email",
              mycontroller: email),
          const SizedBox(
            height: 20,
          ),
          MyTestForm(
              hint: "ادخل كلمة السر",
              icon: const Icon(Icons.lock_outline),
              label: "Password",
              mycontroller: password),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text("  هل نسيت كلمة السر ؟ ",style: TextStyle(color: MyColors.primary),),
            ),
            onTap: (){},
          ),
          const SizedBox(
            height: 20 ,
          ),
          Obx(() => MyButton(
            text: authController.loading.value ? "تحميل..." : "تسجيل دخول ",
            onPressed: () {
              authController.login(
                email.text,
                password.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>HomePage(),
                ),
              );

            },
          )),
          const SizedBox(
            height: 20,
          ),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>SignUpPage(),
                ),
              );

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ليس لديك حساب؟ ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "أنشئ حساب ",
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
