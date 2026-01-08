import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/pages/HomePage.dart';
import 'package:testing/view/pages/loginPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/TextForm.dart';
import '../../features/auth/auth_service.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  TextEditingController usrename = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

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
              hint: "Enter your E_mail",
              icon: const Icon(Icons.email_outlined),
              label: "E_mail",
              mycontroller: email),
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
             onPressed: () async {
  final success = await authService.register(
    name: usrename.text.trim(),
    email: email.text.trim(),
    password: password.text,
  );

  if (success) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("فشل إنشاء الحساب")),
    );
  }
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
