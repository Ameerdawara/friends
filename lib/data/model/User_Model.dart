class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? governorate; // تأكد من وجود هذا
  final String? city;        // تأكد من وجود هذا
  final String? image;       // مسار الصورة كما هو في قاعدة البيانات

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.governorate,
    this.city,
    this.image,
  });
// داخل UserModel.fromJson إذا كنت تستخدم نظام الجدولين:
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Laravel غالباً يعيد البيانات الإضافية داخل كائن اسمه profile
    var profileData = json['profile'];

    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? (profileData != null ? profileData['phone'] : null),
      // هنا نقرأ القيم التي أضفتها أنت للتو في جدول profiles
      city: profileData != null ? profileData['city'] : json['city'],
      governorate: profileData != null ? profileData['governorate'] : json['governorate'],
      image: profileData != null ? profileData['image'] : json['image'],
    );
  }

  // ✅ دالة مهمة جداً لجلب الرابط الكامل للصورة
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return "";

    // إذا كانت الصورة رابط خارجي (مثل جوجل) نرجعه كما هو
    if (image!.startsWith('http')) return image!;

    // ⚠️ استبدل هذا الـ IP بنفس الـ IP الموجود في dio_client.dart
    // يجب أن يشير إلى مجلد storage في لارفيل
    return "http://192.168.1.3:8000/storage/$image";
  }
}