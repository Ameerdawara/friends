import 'package:flutter/material.dart';
import 'package:testing/view/pages/SignUpPage.dart';
import 'package:testing/view/pages/loginPage.dart';

void main()async {
  runApp(const MyApp ());
}
class MyApp  extends StatelessWidget{
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home:LoginPage(),
      //LoginPage(),
    );
  }
}

