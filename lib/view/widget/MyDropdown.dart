import 'package:flutter/material.dart';
import 'package:testing/constans/MyColor.dart'; // تأكد من المسار

class MyDropdown extends StatelessWidget {
  final String hint;
  final String label;
  final Icon icon;
  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;

  const MyDropdown({
    super.key,
    required this.hint,
    required this.label,
    required this.icon,
    required this.items,
    required this.onChanged,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // تسمية الحقل فوق الصندوق (اختياري حسب تصميمك)
        Padding(
          padding: const EdgeInsets.only(right: 10, bottom: 5),
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        DropdownButtonFormField<String>(

          value: (value != null && value!.isNotEmpty && items.contains(value)) ? value : null,
          items: items.map((e) {
            return DropdownMenuItem(value: e, child: Text(e));
          }).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.arrow_drop_down_circle_outlined ,color: MyColors.primary,),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15), // تدوير الحواف
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyColors.primary, width: 2),
            ),
            filled: true,
            fillColor: Colors.grey[50], // لون خلفية خفيف جداً
          ),
          menuMaxHeight: 300,
          // تحديد ارتفاع القائمة
        ),
      ],
    );
  }
}