import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart';


class MyTestForm extends StatelessWidget {
  final String? hint;

  final String? label;

  final Widget? icon;

  TextEditingController? mycontroller;

  MyTestForm(
      {super.key,
        required this.hint,
        required this.icon,
        required this.label,
        required this.mycontroller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: TextFormField(

        controller: mycontroller,
        decoration: InputDecoration(
            suffixIconColor: MyColors.primary,
            focusColor: MyColors.primary,
            hintText: "$hint",
            hintStyle: Theme.of(context).textTheme.bodySmall,

            suffixIcon: icon,
            labelStyle: TextStyle(color: MyColors.primary),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text("$label"),
            ),
            // تحسين بسيط في التصميم لجعل الـ Border أكثر نعومة
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primary, width: 1.5), // تقليل السمك قليلاً للجمالية
              borderRadius: BorderRadius.circular(16), // تقليل الحواف لتصميم عصري أكثر
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(16),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(20),
        )
        ),

      ),
    );
  }
}
