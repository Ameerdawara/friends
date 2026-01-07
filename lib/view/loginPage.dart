import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';
import 'package:testing/view/HomePage.dart';
import 'package:testing/view/SignUpPage.dart';
import 'package:testing/view/widget/MyButton.dart';
import 'package:testing/view/widget/TextForm.dart';
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Text(
              "Log",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              "in",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: MyColors.primary),
            ),
            Icon(
              Icons.login,
              color: MyColors.primary,
              size: 30,
            )
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          SizedBox(height: 10,),
          CircleAvatar(
              radius: 130,
        backgroundImage: AssetImage('images/logo.jpg',)),

          const SizedBox(
            height: 40,
          ),
          MyTestForm(
              hint: "Enter your E_mail",
              icon: const Icon(Icons.email_outlined),
              label: "E_mail",
              mycontroller: email),
          const SizedBox(
            height: 20,
          ),
          MyTestForm(
              hint: "Enter your password",
              icon: const Icon(Icons.lock_outline),
              label: "Password",
              mycontroller: password),
          const SizedBox(
            height: 20,
          ),
          InkWell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text("  Forget password ? ",style: TextStyle(color: MyColors.primary),),
            ),
            onTap: (){},
          ),
          const SizedBox(
            height: 20 ,
          ),
          MyButton(
              text: "Log in",
              onPressed: ()  {
            Navigator.push(context, MaterialPageRoute(builder:(context)=> HomePage()));
              }),
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
                  "Don't have account ?  ",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Sing Up",
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
