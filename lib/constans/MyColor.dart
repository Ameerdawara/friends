import 'package:flutter/material.dart';

class MyColors {
  static const Color primary = Color(0xFF3B85CE);
  static const Color secondary = Color(0xFF2280E1);
  static const Color third =  Color(0xFF1a237e);

  // ألوان الخدمات
  static const Color serviceHome = Color(0x9D3B85CE);
  static const Color serviceRealEstate = Color(0xFFE57373);
  static const Color serviceDelivery = Color(0xFF4DB6AC);

  // --- إعدادات الثيم الفاتح ---
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xFFFAFAFA), // رمادي فاتح جداً
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAFA),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    // لون النصوص الافتراضي
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
  );

  // --- إعدادات الثيم الداكن ---
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,
    scaffoldBackgroundColor: const Color(0xD2000000), // أسود فحمي مريح للعين
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    ),
    // لون النصوص الافتراضي
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    // ألوان البطاقات والقوائم في الوضع الليلي
    cardColor: const Color(0xFF131725),
    dialogBackgroundColor: const Color(0xFF1E1E1E),
  );
}